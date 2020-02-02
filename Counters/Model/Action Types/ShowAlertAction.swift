//
//  ShowAlertAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import UIKit

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
    
}

extension ShowAlertAction: CustomStringConvertible {
    var description: String {
        return "ShowAlertAction"
    }
}
