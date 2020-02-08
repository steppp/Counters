//
//  RunShorcutAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 08/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import UIKit

class RunShortcutAction: CheckpointAction {
    var counter: CounterCore
    
    let baseUrlScheme = "shortcust"
    let baseUrlHost = "run-shortcut"
    var url: URL?
    
    init(counter: CounterCore, shortcutName: String, shortcutInput: String?) {
        self.counter = counter
        
        var params = [URLQueryItem(name: "name", value: shortcutName)]
        
        if let inputString = shortcutInput {
            let inputParam = URLQueryItem(name: "input", value: "text")
            let inputText = URLQueryItem(name: "text", value: inputString)
            
            params.append(inputParam)
            params.append(inputText)
        }

        var components = URLComponents()
        components.scheme = self.baseUrlScheme
        components.host = self.baseUrlHost
        
        components.queryItems = params
        
        self.url = components.url
    }
    
    func performAction() -> CounterStatusAfterStep {
        if let unwrappedUrl = self.url {
            self.launchShortcut(withUrl: unwrappedUrl)
            return .success(nil)
        }
        
        debugPrint("URL was nil")
        return .unmodified
    }
    
    private final func launchShortcut(withUrl url: URL) {
        UIApplication.shared.open(url, options: [:]) { res in
            debugPrint("RunShorctutAction result: \(res)")
        }
    }
    
    var actionType: ActionType { RunShortcutAction.staticActionType }
    
    static var staticActionType: ActionType { .runShortcutAction }
    
}

extension RunShortcutAction: CustomStringConvertible {
    var description: String {
        return RunShortcutAction.staticActionType.rawValue
    }
}
