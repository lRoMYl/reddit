//
//  Repository.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation

protocol Repository {
    associatedtype Key
    associatedtype Value
    
    func getAll() -> [Value]
    func add(_ value: Value) -> Error?
    func update(_ value: Value) -> Error?
    
    func find(id: Key) -> Value?
    func delete(id: Key)
    func delete(_ value: Value)
}

enum RepositoryError: Error {
    case common(message: String)
}
