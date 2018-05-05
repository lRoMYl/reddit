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
    let viewModel = TopicListVCViewModel()
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
        let itemL33t = UIBarButtonItem(
            title: "l33t",
            style: .done,
            target: self,
            action: #selector(didTapL33t)
        )
        let itemAdd = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )
        
        navigationItem.leftBarButtonItem = itemL33t
        navigationItem.rightBarButtonItem = itemAdd
    }
    
    private func setupListener() {
        dataSource.registerClasses(tableView: tableView)
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        viewModel.outputs.title.bind { [weak self] in
            self?.navigationItem.title = $0
        }
        
        viewModel.outputs.topics.bind { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.dataSource.set(topics: $0)
            strongSelf.tableView.reloadData()
        }
        
        viewModel.outputs.goToAddTopic.bind { [weak self] in
            if $0 != nil {
                self?.goToAddTopicVC()
            }
        }
        
        viewModel.outputs.error.bind { [weak self] in
            if let error = $0 {
                self?.presentError(error: error)
            }
        }
    }
    
    // MARK: - Action / Listener
    @IBAction func didTapL33t() {
        viewModel.inputs.didTapL33t()
    }
    
    @IBAction func didTapAdd() {
        viewModel.inputs.didTapAdd()
    }
    
    // MARK: - Navigation
    func presentError(error: Error) {
        let alert = UIAlertController(
            title: NSLocalizedString("Error", comment: ""),
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let actionOk = UIAlertAction(
            title: NSLocalizedString("OK", comment: ""),
            style: .default,
            handler: nil
        )
        
        alert.addAction(actionOk)
        
        navigationController?.present(alert, animated: true, completion: nil)
        
        viewModel.didPresentError()
    }
    
    func goToAddTopicVC() {
        let identifier = String(describing: AddTopicVC.self)
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        
        let navController = UINavigationController(
            navigationBarClass: UINavigationBar.self,
            toolbarClass: nil
        )
        
        navController.viewControllers = [vc]
        
        present(
            navController, animated: true, completion: nil
        )
        
        viewModel.inputs.didGotoAddTopic()
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
    func topicTVCell(_ cell: TopicTVCell, didTapUpvote topic: Topic) {
        viewModel.inputs.didUpvote(topic: topic)
        viewModel.inputs.fetchTopics()
    }
    
    func topicTVCell(_ cell: TopicTVCell, didTapDownVote topic: Topic) {
        viewModel.inputs.didDownvote(topic: topic)
        viewModel.inputs.fetchTopics()
    }
}
