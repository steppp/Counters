//
//  CountersTests.swift
//  CountersTests
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import XCTest
import Counters

class CountersTests: XCTestCase {
    var counter1: CounterCore!
    var counter2: CounterCore!
    var counter3: CounterCore!
    var countersManager: CountersManager!
    var alertPresenter: AlertPresenter!
    
    override func setUp() {
        self.counter1 = CounterCore(initialValue: 3, step: 2, finalValue: 8)
        self.counter2 = CounterCore(initialValue: 1, step: 5, finalValue: 11)
        self.counter3 = CounterCore(initialValue: 10, step: -7)
        
        self.countersManager = CountersManager()
        _ = self.countersManager.add(counters: [counter3])
        
        self.alertPresenter = AlertPresenter()
        
        let action1 = IncrementCounterAction(target: counter2)
        self.counter1.add(checkpoints: [Checkpoint(triggerWhen: .exactlyEqualTo, value: 7, executeAction: action1)])
    }
    
    func testSingleC1Step() {
        let status = self.counter1.next()
        
        XCTAssertEqual(status, CounterStatusAfterStep.success(nil))
    }
    
    func testC1CheckpointTrigger() {
        _ = self.counter1.next()
        let status = self.counter1.next()
        var equal = false
        
        if case CounterStatusAfterStep.success(_) = status {
            equal = true
        }
        
        XCTAssertTrue(equal)
        XCTAssertEqual(counter2.currentValue, 6)
    }
    
    func testC1MultipleSteps() {
        _ = self.counter1.next()
        _ = self.counter1.next()
        let status = self.counter1.next()
        
        var shouldExceedEdgeValue = false
        if case CounterStatusAfterStep.overflow(let overflowInfo) = status {
            shouldExceedEdgeValue = overflowInfo == .shouldExceedEdgeValue
        }
        
        XCTAssertTrue(shouldExceedEdgeValue)
    }
    
    func testC2MultipleSteps() {
        _ = self.counter2.next()
        _ = self.counter2.next()
        let status = self.counter2.next()
        
        var alreadyAtEdgeValue = false
        if case CounterStatusAfterStep.overflow(let overflowInfo) = status {
            alreadyAtEdgeValue = overflowInfo == .alreadyAtEdgeValue
        }
        
        XCTAssertTrue(alreadyAtEdgeValue)
    }
    
    func testC2EdgeValueDelete() {
        let action2 = DeleteCounterAction(deleteCounter: self.counter3, from: self.countersManager)
        
        self.counter2.add(checkpoints: [Checkpoint(triggerWhen: .exactlyEqualTo, value: self.counter2.finalValue!, executeAction: action2)])
        
        _ = self.counter2.next()
        _ = self.counter2.next()
        
        XCTAssertFalse(self.countersManager.contains(counter: self.counter3))
    }
    
    func testC3NoEdge() {
        let times = 5
        
        for _ in 1...times {
            _ = self.counter3.next()
        }
        
        let expectedValue = self.counter3.initialValue + (self.counter3.step * times)
        
        XCTAssertEqual(expectedValue, self.counter3.currentValue)
    }

    override func tearDown() {
        self.counter1.reset()
        self.counter2.reset()
        self.counter3.reset()
        _ = self.countersManager.add(counters: [counter3])
    }
}
