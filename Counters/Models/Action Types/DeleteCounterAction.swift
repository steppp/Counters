//
//  DeleteCounterAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI

class DeleteCounterAction: CheckpointAction {
    var counter: CounterCore
    var countersManager: CountersManager
    
    init(deleteCounter counter: CounterCore, from countersManager: CountersManager) {
        self.counter = counter
        self.countersManager = countersManager
    }
    
    final func performAction() -> CounterStatusAfterStep {
        return self.delete(counter: self.counter)
    }
    
    private final func delete(counter: CounterCore) -> CounterStatusAfterStep {
        /* TODO: consider what to do when a checkpoint of
            another counter refers to a counter that has been deleted
        */
        let res = self.countersManager.delete(counter: counter)
        return res ? .deleted : .success(nil)
    }
    
    var actionType: ActionType = DeleteCounterAction.staticActionType
    static var staticActionType: ActionType = .deleteCounterAction
}

extension DeleteCounterAction: CustomStringConvertible {
    var description: String {
        return DeleteCounterAction.staticActionType.rawValue
    }
}

extension DeleteCounterAction {
    static func == (lhs: DeleteCounterAction, rhs: DeleteCounterAction) -> Bool {
        return lhs.counter == rhs.counter &&
            lhs.description == rhs.description
    }
}
