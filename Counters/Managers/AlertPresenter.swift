//
//  AlertPresenter.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import UIKit

class AlertPresenter {
    
    private var defaultViewController = UIViewController()
    
    /// Contains a list of identifiers and boolean values that signal if an alert is shown
    private var presentingAlert: [String : Bool] = [:]
    
    // TODO: This would be the approach using UIKit, understand what to actually do since we are using SwiftUI
    final func present(alert: UIAlertController, on viewController: UIViewController?) {
        var vc = defaultViewController
        
        if let unwrappedVC = viewController {
            vc = unwrappedVC
        }
        
        vc.present(alert, animated: true, completion: nil)
    }
    
    /// Registers an alert in a dictionary using a String that uniquely identifies that alert through the entire application
    /// - Parameter id: identifier for the alert to be identified in the dictionary
    final func register(alertWithId id: String) throws {
        if self.presentingAlert.contains(where: { el -> Bool in return el.key == id }) {
            throw KeyAlreadyExists()
        }
        
        self.presentingAlert[id] = false
    }
}

struct KeyAlreadyExists: Error { }
