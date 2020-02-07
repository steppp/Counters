//
//  ShowAlertAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import UIKit
import SwiftUI

class ShowAlertAction: CheckpointAction {
    var counter: CounterCore
    var alertPresenter: AlertPresenter
    var alertToPresent: UIAlertController
    
    init(counter: CounterCore, alertPresenter: AlertPresenter, alert: UIAlertController) {
        self.counter = counter
        self.alertPresenter = alertPresenter
        self.alertToPresent = alert
    }
    
    func performAction() -> CounterStatusAfterStep {
        self.alertPresenter.present(alert: self.alertToPresent, on: nil)
        return .unmodified
    }
    
    var actionType: ActionType = ShowAlertAction.staticActionType
    static var staticActionType: ActionType = .showAlertAction
    
    static var actionDescription: String = "showAlertAction"
    
    static var localizedActionType: LocalizedStringKey {
        return LocalizedStringKey(stringLiteral: ShowAlertAction.actionDescription)
    }
}

extension ShowAlertAction: CustomStringConvertible {
    var description: String {
        return ShowAlertAction.actionDescription
    }
}

extension ShowAlertAction {
    static func == (lhs: ShowAlertAction, rhs: ShowAlertAction) -> Bool {
        return lhs.counter == rhs.counter &&
            lhs.description == rhs.description &&
            lhs.alertToPresent == rhs.alertToPresent
    }
}
