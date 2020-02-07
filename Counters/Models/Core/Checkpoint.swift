//
//  Checkpoint.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI

class Checkpoint {
    
    // TODO: return a warning if a exactlyEqualTo trigger is set targeting a value greater than the counter's final value (if set)
    
    private var id: String
    
    private(set) var action: CheckpointAction
    private(set) var triggerType: TriggerType
    private(set) var targetValue: Int
    
    private(set) var active: Bool
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.action.description) }
    
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
        if lhs.id == rhs.id &&
            lhs.action.description == rhs.action.description &&
            lhs.triggerType == rhs.triggerType &&
            lhs.targetValue == rhs.targetValue {
            
            if let lhsInc = lhs.action as? IncrementCounterAction,
                let rhsInc = rhs.action as? IncrementCounterAction {
                    return lhsInc.counter == rhsInc.counter
            }
            
            if let lhsAlert = lhs.action as? ShowAlertAction,
                let rhsAlert = rhs.action as? ShowAlertAction {
                return lhsAlert.counter == rhsAlert.counter && lhsAlert.alertToPresent == rhsAlert.alertToPresent
            }
        }
        
        return false
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.action.counter)
        hasher.combine(self.action.description)
        hasher.combine(self.triggerType)
        hasher.combine(self.targetValue)
        hasher.combine(self.id)
    }
}

enum TriggerType: String, Equatable, CaseIterable {
    case exactlyEqualTo, multipleOf, greaterThan, lowerThan
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.rawValue) }
}
