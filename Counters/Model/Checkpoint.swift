//
//  Checkpoint.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

class Checkpoint {
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
