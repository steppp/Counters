//
//  Checkpoint.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

class Checkpoint {
    
    // TODO: - add a variable to deactivate this checkpoint without deleting it
    // TODO: - add some variables to tell what kind of condition should be verified for the counter to activate the checkpoint, and at what value
    
    private(set) var action: CheckpointAction
    var shouldTriggerAction: (CounterCore) -> Bool
    
    init(underCondition condition: @escaping (CounterCore) -> Bool, executeAction action: CheckpointAction) {
        self.shouldTriggerAction = condition
        self.action = action
    }
}

extension Checkpoint: CustomStringConvertible {
    var description: String {
        return "Checkpoint action is \(self.action)"
    }
}

extension Checkpoint: Hashable {
    static func == (lhs: Checkpoint, rhs: Checkpoint) -> Bool {
        if lhs.action.description == rhs.action.description &&
        lhs.shouldTriggerAction(Counter(name: "tmp1", initialValue: 0)) == rhs.shouldTriggerAction(Counter(name: "tmp2", initialValue: 0)) {
            
            if let lhsInc = lhs.action as? IncrementCounterAction, let rhsInc = rhs.action as? IncrementCounterAction
                {
                    return lhsInc.counter == rhsInc.counter
            }
            
            if let lhsAlert = lhs.action as? ShowAlertAction, let rhsAlert = rhs.action as? ShowAlertAction {
                return lhsAlert.counter == rhsAlert.counter && lhsAlert.alertToPresent == rhsAlert.alertToPresent
            }
        }
        
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.action.counter)
        hasher.combine(self.action.description)
    }
}
