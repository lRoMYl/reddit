//
//  TopicListVC.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import UIKit

class TopicListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    //
    let dataSource = TopicListDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupListener()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Setup
    private func setupView() {
        tableView.estimatedRowHeight = UITableViewAutomaticDimension
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }
    
    private func setupNavBar() {
        let itemAdd = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: nil
        )
        
        navigationItem.rightBarButtonItem = itemAdd
    }
    
    private func setupListener() {
        dataSource.registerClasses(tableView: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        var topic = Topic(id: "1")
        topic.content = "Lorem ipsum"
        
        dataSource.append(contentsOf: [topic])
    }
}

// MARK: - UITableViewDelegate
extension TopicListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TopicTVCell {
            cell.delegate = self
        }
    }
}

// MARK: - TopicTVCellDelegate
extension TopicListVC: TopicTVCellDelegate {
    func topicTVCellDidTapUpvote(_ cell: TopicTVCell) {
        
    }
    
    func topicTVCellDidTapDownvote(_ cell: TopicTVCell) {
        
    }
}
