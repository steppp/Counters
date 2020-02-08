//
//  Checkpoint.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

class Checkpoint: Codable {
    
    // TODO: return a warning if a exactlyEqualTo trigger is set targeting a value greater than the counter's final value (if set)
    
    private var id: String
    
    var action: CheckpointAction
    var triggerType: TriggerType
    
    // TODO: check that the target value is coherent with counter's parameters
    var targetValue: Int
    
    private(set) var active: Bool
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.action.description) }
    
    required init(from decoder: Decoder) throws {
        return
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.triggerType, forKey: .triggerType)
        try container.encode(self.targetValue, forKey: .targetValue)
        
        var nestedContainer = container.nestedContainer(keyedBy: ActionKeys.self, forKey: .actionInfo)
        
        if let a = self.action as? PlaySoundAction {
            try nestedContainer.encode(a, forKey: .action)
        }
        
        if let a = self.action as? RunShortcutAction {
            try nestedContainer.encode(a, forKey: .action)
        }
        
        if let a = self.action as? IncrementCounterAction {
            try nestedContainer.encode(a, forKey: .action)
        }
        
        if let a = self.action as? DeleteCounterAction {
            try nestedContainer.encode(a, forKey: .action)
        }
        
        // TODO
//        if let a = self.action as? ShowAlertAction {
//            try nestedContainer.encode(a, forKey: .action)
//        }
    }
    
    enum CodingKeys: String, CodingKey {
        case targetValue, triggerType, actionInfo
    }
    
    enum ActionKeys: String, CodingKey {
        case action
    }
    
    init(triggerWhen type: TriggerType, value: Int, executeAction action: CheckpointAction) {
        self.action = action
        self.triggerType = type
        self.targetValue = value
        
        self.active = true
        
        self.id = UUID().uuidString
    }
    
    final func shouldTriggerAction(forCounter counter: CounterCore) -> Bool {
        guard active else {
            return false
        }
        
        switch self.triggerType {
        case .exactlyEqualTo:
            return counter.currentValue == self.targetValue
        case .multipleOf:
            return (counter.currentValue % self.targetValue) == 0
        case .greaterThan:
            return counter.currentValue > self.targetValue
        case .lowerThan:
            return counter.currentValue < self.targetValue
        }
    }
    
    final func toggleActive() -> Bool {
        self.active.toggle()
        
        return self.active
    }
    
    static let example = Checkpoint(triggerWhen: .exactlyEqualTo, value: 999,
                                    executeAction: PlaySoundAction(target: Counter.exampleCircularCounter, playSoundAtPath: "nil"))
}

extension Checkpoint: CustomStringConvertible {
    var description: String {
        return "Checkpoint action is \(self.action)"
    }
}

extension Checkpoint: Hashable {
    static func == (lhs: Checkpoint, rhs: Checkpoint) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

enum TriggerType: String, Equatable, CaseIterable, Codable {
    case exactlyEqualTo, multipleOf, greaterThan, lowerThan
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.rawValue) }
}
