//
//  TopicListDataSource.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation
import UIKit

class TopicListDataSource: NSObject {
    fileprivate var _topics = [Topic]()
    let TopicCellIdentifier = String(describing: TopicTVCell.self)
    
    enum Section: Int {
        case topics
    }
    
    func registerClasses(tableView: UITableView) {
        let topicTVCellNib = UINib(nibName: TopicCellIdentifier, bundle: nil)
        tableView.register(topicTVCellNib, forCellReuseIdentifier: TopicCellIdentifier)
    }
    
    func append(topic: Topic) {
        _topics.append(topic)
    }
    
    func append(contentsOf topics: [Topic]) {
        _topics.append(contentsOf: topics)
    }
    
    fileprivate func topicCell(tableView: UITableView, for indexPath: IndexPath) -> TopicTVCell? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TopicCellIdentifier, for: indexPath) as? TopicTVCell else {
            return nil
        }
        let topic = _topics[indexPath.row]
        
        cell.configureWith(value: topic)
        
        return cell
    }
}

extension TopicListDataSource: UITableViewDataSource {
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = Section(rawValue: section)
        
        switch section {
        case .some(.topics):
            return _topics.count
        case .none:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .some(.topics):
            if let cell = topicCell(tableView: tableView, for: indexPath) {
                return cell
            }
        case .none:
            break
        }
        
        return UITableViewCell()
    }
}
