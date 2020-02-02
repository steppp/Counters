//
//  CounterCore.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

class CounterCore {
    
    // MARK: - Class variables and initializer(s)
    
    private var id: String
    private(set) var initialValue: Int
    private(set) var currentValue: Int
    private(set) var step: Int
    private(set) var finalValue: Int?
    private var checkpoints: [Checkpoint]?
    
    init(initialValue: Int, step: Int = 1, finalValue: Int? = nil) {
        self.id = UUID().uuidString
        self.initialValue = initialValue
        self.currentValue = initialValue
        self.step = step
        self.finalValue = finalValue
        
        self.checkpoints = []
    }
    
    
    // MARK: - Private functions
    
    /// Adjust the counter value setting it equal to the edge value, if set
    private final func fitToBounds() {
        guard let edge = self.finalValue else { return }
        
        self.currentValue = edge
    }
    
    /// Check that the current value is not exceeding the edge value after a step
    private final func checkBounds() -> CounterStatusAfterStep {
        guard let edge = self.finalValue else { return .success(nil) }
        
        if self.currentValue == edge + self.step {
            return .overflow(.alreadyAtEdgeValue)
        }
        
        if self.step > 0 {
            if self.currentValue > edge {
                return .overflow(.shouldExceedEdgeValue)
            }
        } else {
            if self.currentValue < edge {
                return .overflow(.shouldExceedEdgeValue)
            }
        }
        
        return .success(nil)
    }
    
    /// Returns the value of the counter after a step is performed (no bound check)
    private func nextStepValue() -> Int {
        return self.currentValue + self.step
    }
    
    /// Triggers all the actions of the checkpoint in the `checkpoints` array whose activation condition is satisfied.
    /// - Returns: list of triggered checkpoints with the execution results if any, `nil` if no checkpoints are triggered
    private final func triggerCheckpoints() -> [(Checkpoint, CounterStatusAfterStep)]? {
        guard let unwrappedCheckpoints = self.checkpoints else {
            return nil
        }
        
        var triggeredCheckpointsWithStatuses: [(Checkpoint, CounterStatusAfterStep)] = []
        
        for checkpoint in unwrappedCheckpoints {
            if checkpoint.shouldTriggerAction(self) {
                let res = checkpoint.action.performAction()
                
                // track all checkpoints that are triggered
                triggeredCheckpointsWithStatuses.append((checkpoint, res))
            }
        }
        
        return triggeredCheckpointsWithStatuses.isEmpty ? nil : triggeredCheckpointsWithStatuses
    }
    
    
    // MARK: - Public functions
    
    /// Adds a new Checkpoint to the `checkpoints` array
    /// - Parameter checkpoint: `Checkpoint` instance to be added to the array
    final func add(checkpoint: Checkpoint) {
        self.checkpoints?.append(checkpoint)
    }
    
    /// Sets the current value of the counter as its initial value
    /// - Parameter resetCheckpoints: set to true to reset the list of checkpoints too
    final func reset(alsoResetCheckpoints resetCheckpoints: Bool = false) {
        self.currentValue = self.initialValue
        
        if resetCheckpoints {
            self.checkpoints = []
        }
    }
    
    /// Increment the counter of a quantity equal to the `step` member with respect to the upper bound (if set)
    final func next() -> CounterStatusAfterStep {
        self.currentValue = self.nextStepValue()
        
        var status = self.checkBounds()
        
        // see https://fuckingifcaseletsyntax.com
        switch status {
        case .overflow(let overflowInfo):
            self.fitToBounds()
            
            if overflowInfo == .shouldExceedEdgeValue {
                fallthrough
                
                // trigger checkpoints only if the step is performed, both partially (exceeding edge value) or completely
                // if the counter is already at edge value the step is not performed and checkpoints are not triggered
            } else {
                break
            }
        case .success(_):
            if let triggeredCheckpointsWithStatuses = self.triggerCheckpoints() {
                status = .success(triggeredCheckpointsWithStatuses)
            }
        default:
            break
        }
        
        return status
    }
}


// MARK: - Hashable extension
extension CounterCore: Hashable {
    static func == (lhs: CounterCore, rhs: CounterCore) -> Bool {
        return lhs.id == rhs.id &&
            lhs.currentValue == lhs.currentValue &&
            lhs.initialValue == lhs.initialValue &&
            lhs.step == rhs.step &&
            lhs.finalValue == rhs.finalValue
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.currentValue)
        hasher.combine(self.initialValue)
        hasher.combine(self.step)
        hasher.combine(self.finalValue)
    }
}


// MARK: - CustomstringConvertible extension
extension CounterCore: CustomStringConvertible {
    var description: String {
        return self.id
    }
}
