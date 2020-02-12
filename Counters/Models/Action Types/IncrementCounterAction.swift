//
//  IncrementCounterAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI

class IncrementCounterAction: CheckpointAction {
    var counter: CounterCore
    
    init(target counter: CounterCore) {
        self.counter = counter
    }
    
    final func performAction() -> CounterStatusAfterStep {
        // update counter variable with the actual counter reference
        if self.counterIsPlaceholder(self.counter) {
            self.counter = CountersManager.shared.getCounter(withId: self.counter.id)
        }
        
        return self.nextStep(for: self.counter)
    }
    
    private final func nextStep(for counter: CounterCore) -> CounterStatusAfterStep {
        return counter.next()
    }
    
    internal func counterIsPlaceholder(_ counter: CounterCore) -> Bool {
        return counter.isPlaceholder
    }
    
    var actionType: ActionType = IncrementCounterAction.staticActionType
    static var staticActionType: ActionType = .incrementCounterAction
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let counterId = try values.decode(String.self, forKey: .counter)
        
        self.counter = CounterCore(overrideId: counterId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.counter.id, forKey: .counter)
    }
    
    enum CodingKeys: String, CodingKey {
        case counter
    }
}

extension IncrementCounterAction: CustomStringConvertible {
    var description: String {
        return IncrementCounterAction.staticActionType.rawValue
    }
}

extension IncrementCounterAction {
    static func == (lhs: IncrementCounterAction, rhs: IncrementCounterAction) -> Bool {
        return lhs.counter == rhs.counter &&
            lhs.description == rhs.description
    }
}
