//
//  TopicRespository.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation

class TopicRepository: Repository {
    static let shared = TopicRepository()
    
    private var _topics = [Topic]()
    
    func getAll() -> [Topic] {
        return _topics
    }
    
    func add(_ value: Topic) -> Error? {
        if _topics.index(of: value) != nil {
            return RepositoryError.common(
                message: "Topic with id \(value.id) already exist"
            )
        } else {
           _topics.append(value)
        }
        
        return nil
    }
    
    func update(_ value: Topic) -> Error? {
        if let idx = _topics.index(of: value) {
            _topics[idx] = value
        } else {
            // Attempting to add the value if topic is not already exist
            return add(value)
        }
        
        return nil
    }
    
    func find(id: String) -> Topic? {
        return _topics.first(where: { $0.id == id })
    }
    
    func delete(id: String) {
        if let topic = find(id: id) {
            if let idx = _topics.index(of: topic) {
                _topics.remove(at: idx)
            }
        }
    }
    
    func delete(_ value: Topic) {
        delete(id: value.id)
    }
}
