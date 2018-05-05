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
    func didTapUpvote()
    func didTapDownvote()
}

protocol TopicTVCellViewModelOutputs {
    var content: Box<String?> { get }
    var vote: Box<Int> { get }
    
    var upvoteTxtClr: Box<UIColor> { get }
    var downvoteTxtClr: Box<UIColor> { get }
    var defaultVoteTxtClr: Box<UIColor> { get }
    
    var notifyDelegateDidTapUpvote: Box<Void?> { get }
    var notifyDelegateDidTapDownvote: Box<Void?> { get }
}

protocol TopicTVCellViewModelType: TopicTVCellViewModelInputs, TopicTVCellViewModelOutputs {
    var inputs: TopicTVCellViewModelInputs { get }
    var outputs: TopicTVCellViewModelOutputs { get }
}

class TopicTVCellViewModel: TopicTVCellViewModelType, TopicTVCellViewModelInputs, TopicTVCellViewModelOutputs {
    
    func didTapUpvote() {
        outputs.notifyDelegateDidTapUpvote.value = ()
        outputs.notifyDelegateDidTapUpvote.value = nil
    }
    
    func didTapDownvote() {
        outputs.notifyDelegateDidTapDownvote.value = ()
        outputs.notifyDelegateDidTapDownvote.value = nil
    }
    
    let content: Box<String?> = Box(nil)
    let vote: Box<Int> = Box(0)
    
    let upvoteTxtClr: Box<UIColor> = Box(UIColor.red)
    let downvoteTxtClr: Box<UIColor> = Box(UIColor.blue)
    let defaultVoteTxtClr: Box<UIColor> = Box(UIColor.gray)
    
    let notifyDelegateDidTapUpvote: Box<Void?> = Box(nil)
    let notifyDelegateDidTapDownvote: Box<Void?> = Box(nil)
    
    var inputs: TopicTVCellViewModelInputs { return self }
    var outputs: TopicTVCellViewModelOutputs { return self }
}
