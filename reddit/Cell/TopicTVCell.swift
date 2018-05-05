//
//  TopicTVCell.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import UIKit

class TopicTVCell: UITableViewCell {

    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var upvoteBtn: UIButton!
    @IBOutlet weak var voteCountBtn: UIButton!
    @IBOutlet weak var downvoteBtn: UIButton!
    
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
        
    }
    
    // MARK: - Configurator
    func configureWith(value: Topic) {
        
    }
}
