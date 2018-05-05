//
//  TopicTVCell.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import UIKit

protocol TopicTVCellDelegate: class {
    func topicTVCellDidTapUpvote(
        _ cell: TopicTVCell
    )
    
    func topicTVCellDidTapDownvote(
        _ cell: TopicTVCell
    )
}

class TopicTVCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var upvoteBtn: UIButton!
    @IBOutlet weak var voteCountBtn: UIButton!
    @IBOutlet weak var downvoteBtn: UIButton!
    
    //
    weak var delegate: TopicTVCellDelegate?
    let viewModel = TopicTVCellViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
        setupListener()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Setup
    private func setupView() {
        
    }
    
    private func setupListener() {
         upvoteBtn.addTarget(
            self,
            action: #selector(actionUpvote(_:)),
            for: .touchUpInside
        )
        voteCountBtn.addTarget(
            self,
            action: #selector(actionUpvote(_:)),
            for: .touchUpInside
        )
        downvoteBtn.addTarget(
            self,
            action: #selector(actionDownvote(_:)),
            for: .touchUpInside
        )
        
        viewModel.outputs.content.bind { [weak self] in
            self?.contentLbl.text = $0
        }
        
        viewModel.outputs.vote.bind { [weak self] _ in
            self?.redrawVoteCountBtn()
        }
        viewModel.outputs.defaultVoteTxtClr.bind { [weak self] _ in
            self?.redrawVoteCountBtn()
        }
        viewModel.outputs.upvoteTxtClr.bind { [weak self] _ in
            self?.redrawVoteCountBtn()
        }
        viewModel.outputs.downvoteTxtClr.bind { [weak self] _ in
            self?.redrawVoteCountBtn()
        }
        
        viewModel.outputs.notifyDelegateDidTapUpvote.bind { [weak self] in
            guard let strongSelf = self else { return }
            
            if $0 != nil {
                self?.delegate?.topicTVCellDidTapUpvote(strongSelf)
            }
        }
        
        viewModel.outputs.notifyDelegateDidTapDownvote.bind { [weak self] in
            guard let strongSelf = self else { return }
            
            if $0 != nil {
                self?.delegate?.topicTVCellDidTapDownvote(strongSelf)
            }
        }
    }
    
    // MARK: -
    private func redrawVoteCountBtn() {
        let vote = viewModel.vote.value
        
        // Text
        let title = vote == 0
            ? NSLocalizedString("Vote", comment: "")
            : String(vote)
        
        voteCountBtn.setTitle(title, for: .normal)
        
        // Text Color
        var titleColor = viewModel.defaultVoteTxtClr.value
        if vote < 0 {
            titleColor = viewModel.downvoteTxtClr.value
        } else if vote > 0 {
            titleColor = viewModel.upvoteTxtClr.value
        }
        
        voteCountBtn.setTitleColor(titleColor, for: .normal)
    }
    
    // MARK: - Action / Listener
    @IBAction func actionUpvote(_ sender: UIButton) {
        viewModel.didTapUpvote()
    }
    
    @IBAction func actionDownvote(_ sender: UIButton) {
        viewModel.didTapDownvote()
    }
    
    // MARK: - Configurator
    func configureWith(value: Topic) {
        viewModel.content.value = value.content
        viewModel.vote.value = value.vote
    }
}
