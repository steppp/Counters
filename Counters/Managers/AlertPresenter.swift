//
//  AlertPresenter.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import UIKit

class AlertPresenter {
    
    var defaultViewController = UIViewController()
    
    /// Contains a list of identifiers and boolean values that signal if an alert is shown
    var presentingAlert: [String : Bool] = [:]
    
    // TODO: This would be the approach using UIKit, understand what to actually do since we are using SwiftUI
    final func present(alert: UIAlertController, on viewController: UIViewController?) {
        var vc = defaultViewController
        
        if let unwrappedVC = viewController {
            vc = unwrappedVC
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    final func register(alertWithId id: String) {
        self.presentingAlert[id] = false
    }
}
