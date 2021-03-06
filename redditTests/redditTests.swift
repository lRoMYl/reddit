//
//  redditTests.swift
//  redditTests
//
//  Created by Cheah Bee Kim on 5/5/18.
//  Copyright © 2018 Cheah Bee Kim. All rights reserved.
//

import XCTest
@testable import reddit

class redditTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - TopicRepository
    func insertMockIn(repo: TopicRepository, numToInsert: Int) {
        for i: Int in 0..<numToInsert {
            let topic = Topic(id: String("\(i)"))
            _ = repo.add(topic)
        }
    }
    
    func testTopicRepositoryAdd() {
        let repo = TopicRepository()
        let numToInsert = 10
        
        for i: Int in 0..<numToInsert {
            let topic = Topic(id: String("\(i)"))
            let insertErr = repo.add(topic)
            let queryTopicResult = repo.find(id: topic.id)
            
            XCTAssertNil(
                insertErr,
                "Correct parameters is provied to insert, should not return error"
            )
            XCTAssertNotNil(
                queryTopicResult,
                "Repo alredy have topic id \(topic.id), should not return nil using find"
            )
        }
        
        let topics = repo.getAll()
        
        XCTAssertEqual(
            topics.count, numToInsert,
            "Inserted topic count \(topics.count) not equal with the intended count \(numToInsert)"
        )
        
        for topic in topics {
            let insertErr = repo.add(topic)
            
            XCTAssertNotNil(
                insertErr,
                "Should return error when inserting duplicate topic"
            )
        }
    }
    
    func testTopicRepositoryUpdate() {
        let repo = TopicRepository()
        let numToInsert = 10
        let updateToVote = 999
        
        insertMockIn(repo: repo, numToInsert: numToInsert)

        repo.getAll().forEach {
            var topic = $0
            topic.vote = updateToVote
            let updateErr = repo.update(topic)
            
            XCTAssertNil(
                updateErr,
                "Should not return error when updating correctly"
            )
        }
        
        repo.getAll().forEach {
            XCTAssertEqual(
                $0.vote, updateToVote,
                "\($0.vote) should be \(updateToVote) after update"
            )
        }
        
        let repoCountAfterUpdate = repo.getAll().count + 1
        let newTopic = Topic(id: "Unique test id")
        let updateErr = repo.update(newTopic)
        
        XCTAssertNil(
            updateErr,
            "Should not return error when updating topic not found in repo"
        )
        XCTAssertEqual(
            repoCountAfterUpdate,
            repo.getAll().count,
            "Updating topic not found in repo will append new topic into repo, expected count is \(repoCountAfterUpdate) but only \(repo.getAll().count) was found"
        )
    }
    
    // MARK: TopicTVCellViewModel
    func testTopicTVCell() {
        let viewModel = TopicTVCellViewModel()
        let topic: Topic = {
            var topic = Topic(id: "1")
            
            topic.content = "test"
            topic.vote = 10
            
            return topic
        }()
        
        viewModel.inputs.configure(topic: topic)
        
        viewModel.inputs.didTapUpvote()
        XCTAssertNotNil(
            viewModel.outputs.notifyDelegateDidTapUpvote.value,
            "Missing topic value after didTapUpvote"
        )
        viewModel.inputs.didNotifyDelegateDidTapUnvote()
        XCTAssertNil(
            viewModel.outputs.notifyDelegateDidTapUpvote.value,
            "Topic value not cleared after didNotifyDelegateDidTapUnvote"
        )
        
        viewModel.inputs.didTapDownvote()
        XCTAssertNotNil(
            viewModel.outputs.notifyDelegateDidTapDownvote.value,
            "Missing topic value after didTapDownvote"
        )
        viewModel.inputs.didNotifyDelegateDidTapDownvote()
        XCTAssertNil(
            viewModel.outputs.notifyDelegateDidTapDownvote.value,
            "Topic value not cleared after didNotifyDelegateDidTapDownvote"
        )
    }
    
    // MARK: - TopicListVCViewModel
    func testTopicListVCViewModel() {
        let repo = TopicRepository()
        let numToInsert = 10
        insertMockIn(repo: repo, numToInsert: numToInsert)
        
        let viewModel = TopicListVCViewModel(repo: repo)
        
        viewModel.inputs.didTapAdd()
        XCTAssertNotNil(
            viewModel.outputs.goToAddTopic.value,
            "Error goToAddTopic should not be nil before navigating"
        )
        viewModel.inputs.didGotoAddTopic()
        XCTAssertNil(
            viewModel.outputs.goToAddTopic.value,
            "Error goToAddTopic should be nil after navigating"
        )
        
        if let topic = repo.getAll().first {
            let expectedVoteCount = topic.vote + 1
            viewModel.inputs.didUpvote(topic: topic)
            
            if let updatedTopic = repo.find(id: topic.id) {
                XCTAssertEqual(
                    expectedVoteCount,
                    updatedTopic.vote,
                    "Topic vote is not upvoted in the repo"
                )
            }
        }
        
        if let topic = repo.getAll().first {
            let expectedVoteCount = topic.vote - 1
            viewModel.inputs.didDownvote(topic: topic)
            
            if let updatedTopic = repo.find(id: topic.id) {
                XCTAssertEqual(
                    expectedVoteCount,
                    updatedTopic.vote,
                    "Topic vote is not downvoted in the repo"
                )
            }
        }
    }
    
    // MARK: - AddTopicVCViewModel
    func testAddTopicVCViewModel() {
        let repo = TopicRepository()
        let numToInsert = 10
        insertMockIn(repo: repo, numToInsert: numToInsert)
        
        let viewModel = AddTopicVCViewModel(repo: repo)
        
        viewModel.inputs.didTapAdd()
        
        XCTAssertNotNil(
            viewModel.outputs.error.value,
            "Error should be created due to empty content"
        )
        
        viewModel.inputs.didDisplayError()
        XCTAssertNil(
            viewModel.outputs.error.value,
            "Error should be clear after presenting the error"
        )
        
        let charLimit = viewModel.outputs.charLimit.value
        let invalidLongString = String(
            repeating: "a", count: charLimit + 1
        )
        viewModel.outputs.content.value = invalidLongString
        XCTAssertEqual(
            viewModel.outputs.content.value,
            invalidLongString,
            "post content value should be equal with the value set"
        )
        
        viewModel.inputs.didTapAdd()
        XCTAssertNotNil(
            viewModel.outputs.error.value,
            "Error should be created because the post content string is longer that charLimit \(charLimit)"
        )
        viewModel.inputs.didDisplayError()
        
        viewModel.outputs.content.value = "Test valid value"
        viewModel.inputs.didTapAdd()
        
        XCTAssertNil(
            viewModel.outputs.error.value,
            "Should not return error for valid content"
        )
    }
}
