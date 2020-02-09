//
//  CheckpointAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

protocol CheckpointAction: CustomStringConvertible, Codable {
    var counter: CounterCore { get set }
    func performAction() -> CounterStatusAfterStep
    
    func counterIsPlaceholder(_ counter: CounterCore) -> Bool
    
    var actionType: ActionType { get }
    static var staticActionType: ActionType { get }
}

enum ActionType: String, Equatable, CaseIterable, Codable {
    
    case playSoundAction, incrementCounterAction, deleteCounterAction, runShortcutAction
    
    var localizedName: LocalizedStringKey { LocalizedStringKey(stringLiteral: self.rawValue) }
}
