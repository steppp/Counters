//
//  CounterCore.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

class CounterCore: ObservableObject, Codable {
    
    // MARK: - Class variables and initializer(s)
    
    internal var id: String
    private(set) var initialValue: Int
    @Published private(set) var currentValue: Int
    private(set) var step: Int
    private(set) var finalValue: Int?
    
    @Published var checkpoints: [Checkpoint]?
    
    private(set) var isPlaceholder = true
    
    
    // MARK: - Encodable & Decodable
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.initialValue = try values.decode(Int.self, forKey: .initialValue)
        self.currentValue = try values.decode(Int.self, forKey: .currentValue)
        self.step = try values.decode(Int.self, forKey: .step)
        self.finalValue = try values.decodeIfPresent(Int.self, forKey: .finalValue)
        
        self.isPlaceholder = false
        
        let nestedValues = try values.nestedContainer(keyedBy: CheckpointsArrayKeys.self, forKey: .checkpointsArray)
        self.checkpoints = try nestedValues.decodeIfPresent([Checkpoint].self, forKey: .checkpoints)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.initialValue, forKey: .initialValue)
        try container.encode(self.step, forKey: .step)
        try container.encode(self.currentValue, forKey: .currentValue)
        try container.encodeIfPresent(self.finalValue, forKey: .finalValue)
        
        var nestedContainer = container.nestedContainer(keyedBy: CheckpointsArrayKeys.self, forKey: .checkpointsArray)
        try nestedContainer.encode(self.checkpoints, forKey: .checkpoints)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, initialValue, step, finalValue, currentValue, checkpointsArray
    }
    
    enum CheckpointsArrayKeys: String, CodingKey {
        case checkpoints
    }
    
    init(initialValue: Int, step: Int = 1, finalValue: Int? = nil) {
        self.id = UUID().uuidString
        self.initialValue = initialValue
        self.currentValue = initialValue
        self.step = step
        self.finalValue = finalValue
        
        self.checkpoints = []
        
        self.isPlaceholder = false
    }
    
    init(overrideId id: String) {
        self.id = id
        self.initialValue = 0
        self.currentValue = 0
        self.step = 0
        self.finalValue = 0
        
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
            if checkpoint.shouldTriggerAction(forCounter: self) {
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
    final func add(checkpoints: [Checkpoint]) {
        for checkpoint in checkpoints {
            self.checkpoints?.append(checkpoint)
        }
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
    func next() -> CounterStatusAfterStep {
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
    
    /// Returns a list of active checkpoints for this counter
    final func getCheckpoints(includingNotActive all: Bool = false) -> [Checkpoint] {
        guard let unwrappedCheckpoints = self.checkpoints else { return [] }
        
        if all {
            return unwrappedCheckpoints
        }
        
        return unwrappedCheckpoints.filter { ch -> Bool in ch.active }
    }
    
    /// Removes the specified checkpoint from the checkpoints array
    /// - Parameters:
    ///   - checkpoint: checkpoint to be removed
    ///   - checkpoints: list where to remove the checkpoint from
    static func removing(checkpoint: Checkpoint, from checkpoints: [Checkpoint]) -> [Checkpoint] {
        var mutableCollection = checkpoints
        
        if let index = mutableCollection.firstIndex(where: { $0 == checkpoint }) {
            mutableCollection.remove(at: index)
            return mutableCollection
        }
        
        return mutableCollection
    }
}


// MARK: - Hashable extension
extension CounterCore: Hashable {
    static func == (lhs: CounterCore, rhs: CounterCore) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}


// MARK: - CustomstringConvertible extension
extension CounterCore: CustomStringConvertible {
    var description: String {
        return self.id
    }
}
