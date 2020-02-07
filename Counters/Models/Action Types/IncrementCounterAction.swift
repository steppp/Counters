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
        return self.nextStep(for: self.counter)
    }
    
    private final func nextStep(for counter: CounterCore) -> CounterStatusAfterStep {
        return counter.next()
    }
    
    var actionType: ActionType = IncrementCounterAction.staticActionType
    static var staticActionType: ActionType = .incrementCounterAction
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
