//
//  TopicListVCViewModel.swift
//  reddit
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import Foundation
import UIKit

protocol TopicListVCViewModelInputs {
    func fetchTopics()
    
    func didUpvote(topic: Topic)
    func didDownvote(topic: Topic)
    
    func didAdd(topic: Topic)
    
    func didTapAdd()
    func didTapL33t()
    
    func didPresentError()
    func didGotoAddTopic()
}

protocol TopicListVCViewModelOutputs {
    var title: Box<String> { get }
    var topics: Box<[Topic]> { get }
    
    var error: Box<Error?> { get }
    
    var goToAddTopic: Box<Void?> { get }
    
    var fetching: Box<Bool> { get }
}

protocol TopicListVCViewModelType {
    var inputs: TopicListVCViewModelInputs { get }
    var outputs: TopicListVCViewModelOutputs { get }
}

class TopicListVCViewModel: TopicListVCViewModelType, TopicListVCViewModelInputs, TopicListVCViewModelOutputs {

    fileprivate let topicRepo: TopicRepository
    
    private func updateTopic(_ topic: Topic) {
        if let error = topicRepo.update(topic) {
            outputs.error.value = error
        } else {
            if let idx = topics.value.index(of: topic) {
                outputs.topics.value[idx] = topic
            }
        }
    }
    
    func fetchTopics() {
        outputs.fetching.value = true
        
        // Fetch data
        outputs.topics.value = Array(
            topicRepo.getAll()
            .sorted(by: >)
            .prefix(20)
        )
        
        outputs.fetching.value = false
    }
    
    func didUpvote(topic: Topic) {
        var mutableTopic = topic
        mutableTopic.vote += 1
        
        updateTopic(mutableTopic)
    }
    
    func didDownvote(topic: Topic) {
        var mutableTopic = topic
        mutableTopic.vote -= 1
        
        updateTopic(mutableTopic)
    }
    
    func didAdd(topic: Topic) {
//        outputs.topics.value.insert(topic, at: 0)
        fetchTopics()
    }
    
    func didTapAdd() {
        outputs.goToAddTopic.value = ()
    }
    
    func didTapL33t() {
        for _: Int in 0..<1 {
            let count = topicRepo.getAll().count
            var topic = Topic(id: "\(count + 1)")
            topic.content = "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum."
            
            _ = topicRepo.add(topic)
        }
        
        outputs.topics.value = topicRepo.getAll()
    }
    
    func didPresentError() {
        outputs.error.value = nil
    }
    
    func didGotoAddTopic() {
        outputs.goToAddTopic.value = nil
    }
    
    let title: Box<String> = Box("Topics")
    let topics: Box<[Topic]> = Box([])
    let error: Box<Error?> = Box(nil)
    let goToAddTopic: Box<Void?> = Box(nil)
    var fetching: Box<Bool> = Box(false)
    
    var inputs: TopicListVCViewModelInputs { return self }
    var outputs: TopicListVCViewModelOutputs { return self }
    
    init(repo: TopicRepository = TopicRepository.shared) {
        topicRepo = repo
        title.value = NSLocalizedString("Topics", comment: "")
    }
}
