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
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(String.self, forKey: .id)
        self.triggerType = try values.decode(TriggerType.self, forKey: .triggerType)
        self.targetValue = try values.decode(Int.self, forKey: .targetValue)
        self.active = try values.decode(Bool.self, forKey: .active)
        
        let actionType = try values.decode(ActionType.self, forKey: .actionType)
        
        switch actionType {
        case .playSoundAction:
            self.action = try values.decode(PlaySoundAction.self, forKey: .action)
        
        case .runShortcutAction:
            self.action = try values.decode(RunShortcutAction.self, forKey: .action)
        
        case .incrementCounterAction:
            self.action = try values.decode(IncrementCounterAction.self, forKey: .action)
        
        case .deleteCounterAction:
            self.action = try values.decode(DeleteCounterAction.self, forKey: .action)
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.triggerType, forKey: .triggerType)
        try container.encode(self.targetValue, forKey: .targetValue)
        try container.encode(self.active, forKey: .active)
        
        if let a = self.action as? PlaySoundAction {
            try container.encode(a, forKey: .action)
            try container.encode(ActionType.playSoundAction, forKey: .actionType)
        }
        
        if let a = self.action as? RunShortcutAction {
            try container.encode(a, forKey: .action)
            try container.encode(ActionType.runShortcutAction, forKey: .actionType)
        }
        
        if let a = self.action as? IncrementCounterAction {
            try container.encode(a, forKey: .action)
            try container.encode(ActionType.incrementCounterAction, forKey: .actionType)
        }
        
        if let a = self.action as? DeleteCounterAction {
            try container.encode(a, forKey: .action)
            try container.encode(ActionType.deleteCounterAction, forKey: .actionType)
        }
        
        // TODO
//        if let a = self.action as? ShowAlertAction {
//            try nestedContainer.encode(a, forKey: .action)
//        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, targetValue, triggerType, action, active, actionType
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
