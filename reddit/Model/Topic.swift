//
//  Topic.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation

struct Topic {
    let id: String
    
    var content: String?
    var vote: Int = 0
    
    let createdAt = Date()
    
    init(id: String) {
        self.id = id
    }
}

extension Topic: Equatable {
    static func == (lhs: Topic, rhs: Topic) -> Bool {
        return lhs.id == rhs.id
    }
}
