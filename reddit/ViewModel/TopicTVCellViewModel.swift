//
//  TopicTVCellViewModel.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation
import UIKit

protocol TopicTVCellViewModelInputs {
    func configure(topic: Topic)
    func didTapUpvote()
    func didTapDownvote()
    func didNotifyDelegateDidTapUnvote()
    func didNotifyDelegateDidTapDownvote()
}

protocol TopicTVCellViewModelOutputs {
    var content: Box<String?> { get }
    var vote: Box<Int> { get }
    
    var upvoteTxtClr: Box<UIColor> { get }
    var downvoteTxtClr: Box<UIColor> { get }
    var defaultVoteTxtClr: Box<UIColor> { get }
    
    var notifyDelegateDidTapUpvote: Box<Topic?> { get }
    var notifyDelegateDidTapDownvote: Box<Topic?> { get }
}

protocol TopicTVCellViewModelType: TopicTVCellViewModelInputs, TopicTVCellViewModelOutputs {
    var inputs: TopicTVCellViewModelInputs { get }
    var outputs: TopicTVCellViewModelOutputs { get }
}

class TopicTVCellViewModel: TopicTVCellViewModelType, TopicTVCellViewModelInputs, TopicTVCellViewModelOutputs {
    
    fileprivate var topic: Topic?
    
    func configure(topic: Topic) {
        self.topic = topic
        
        outputs.content.value = topic.content
        outputs.vote.value = topic.vote
    }
    
    func didTapUpvote() {
        outputs.notifyDelegateDidTapUpvote.value = topic
    }
    
    func didTapDownvote() {
        outputs.notifyDelegateDidTapDownvote.value = topic
    }
    
    func didNotifyDelegateDidTapUnvote() {
        outputs.notifyDelegateDidTapUpvote.value = nil
    }
    
    func didNotifyDelegateDidTapDownvote() {
        outputs.notifyDelegateDidTapDownvote.value = nil
    }
    
    let content: Box<String?> = Box(nil)
    let vote: Box<Int> = Box(0)
    
    let upvoteTxtClr: Box<UIColor> = Box(UIColor.red)
    let downvoteTxtClr: Box<UIColor> = Box(UIColor.blue)
    let defaultVoteTxtClr: Box<UIColor> = Box(UIColor.gray)
    
    let notifyDelegateDidTapUpvote: Box<Topic?> = Box(nil)
    let notifyDelegateDidTapDownvote: Box<Topic?> = Box(nil)
    
    var inputs: TopicTVCellViewModelInputs { return self }
    var outputs: TopicTVCellViewModelOutputs { return self }
}
