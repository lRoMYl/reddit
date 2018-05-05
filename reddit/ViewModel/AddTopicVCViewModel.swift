//
//  AddTopicVCViewModel.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation
import UIKit

protocol AddTopicVCViewModelInputs {
    func didTapCancel()
    func didTapAdd()
    
    func didDisplayError()
    
    func didNotifyDelegateDidTapCancel()
    func didNotifyDelegateDidAdd()
}

protocol AddTopicVCViewModelOutputs {
    var title: Box<String?> { get }
    var content: Box<String> { get }
    var charLimit: Box<Int> { get }
    
    var error: Box<Error?> { get }
    
    var notifyDelegateDidTapCancel: Box<Void?> { get }
    var notifyDelegateDidAdd: Box<Topic?> { get }
}

protocol AddTopicVCViewModelType {
    var inputs: AddTopicVCViewModelInputs { get }
    var outputs: AddTopicVCViewModelOutputs { get }
}

enum AddTopicError: Error {
    case contentEmpty
    case contentTooLong
    case add(message: String)
}

extension AddTopicError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .contentEmpty:
            return NSLocalizedString("Please enter content", comment: "")
        case .contentTooLong:
            return NSLocalizedString("Content too long", comment: "")
        case .add(message: let msg):
            return msg
        }
    }
}

class AddTopicVCViewModel: AddTopicVCViewModelType, AddTopicVCViewModelInputs, AddTopicVCViewModelOutputs {
    
    fileprivate let topicRepo: TopicRepository
    
    func didTapCancel() {
        outputs.notifyDelegateDidTapCancel.value = ()
    }
    
    func didTapAdd() {
        let content = self.content.value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard content.count > 0 else {
            let error = AddTopicError.contentEmpty
            
            self.error.value = error
            return
        }
        guard content.count < charLimit.value else {
            let error = AddTopicError.contentTooLong
            
            self.error.value = error
            return
        }
        
        let count = topicRepo.getAll().count
        var topic = Topic(id: "\(count + 1)")
        topic.content = content
        
        if let error = topicRepo.add(topic) {
            self.error.value = AddTopicError.add(message: error.localizedDescription)
        } else {
            outputs.notifyDelegateDidAdd.value = topic
        }
    }
    
    func didDisplayError() {
        outputs.error.value = nil
    }
    
    func didNotifyDelegateDidTapCancel() {
        outputs.notifyDelegateDidTapCancel.value = nil
    }
    
    func didNotifyDelegateDidAdd() {
        outputs.notifyDelegateDidAdd.value = nil
    }
    
    let title: Box<String?> = Box(nil)
    let content: Box<String> = Box("")
    let charLimit: Box<Int> = Box(255)
    
    let error: Box<Error?> = Box(nil)
    
    let notifyDelegateDidTapCancel: Box<Void?> = Box(nil)
    let notifyDelegateDidAdd: Box<Topic?> = Box(nil)
    
    var inputs: AddTopicVCViewModelInputs { return self }
    var outputs: AddTopicVCViewModelOutputs { return self }
    
    init(repo: TopicRepository = TopicRepository.shared) {
        topicRepo = repo
        outputs.title.value = NSLocalizedString("Text Post", comment: "")
    }
}
