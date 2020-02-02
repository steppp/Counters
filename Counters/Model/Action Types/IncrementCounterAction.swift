//
//  IncrementCounterAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation


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
}

extension IncrementCounterAction: CustomStringConvertible {
    var description: String {
        return "IncrementCounterAction"
    }
}
