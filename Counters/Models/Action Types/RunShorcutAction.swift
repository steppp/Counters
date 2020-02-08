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
    var shortcutName: String
    var shortcutInput: String?
    
    private let baseUrlScheme = "shortcuts"
    private let baseUrlHost = "run-shortcut"
    private var url: URL?
    
    init(counter: CounterCore, shortcutName: String, shortcutInput: String?) {
        self.counter = counter
        self.shortcutName = shortcutName
        self.shortcutInput = shortcutInput
        
        var params = [URLQueryItem(name: "name", value: shortcutName)]
        
        if let inputString = shortcutInput, !inputString.isEmpty {
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
        debugPrint(url.absoluteString)
        
        UIApplication.shared.open(url, options: [:]) { res in
            debugPrint("RunShorctutAction result: \(res)")
        }
    }
    
    var actionType: ActionType { RunShortcutAction.staticActionType }
    
    static var staticActionType: ActionType { .runShortcutAction }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.shortcutName = try values.decode(String.self, forKey: .shortcutName)
        self.shortcutInput = try values.decodeIfPresent(String.self, forKey: .shortcutName)
        self.url = try values.decodeIfPresent(URL.self, forKey: .url)
        self.counter = Counter.placeholder
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.shortcutName, forKey: .shortcutName)
        try container.encodeIfPresent(self.shortcutInput, forKey: .shortcutInput)
        try container.encodeIfPresent(self.url, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case shortcutName, shortcutInput, url   //, counter = "counterName"
    }
}

extension RunShortcutAction: CustomStringConvertible {
    var description: String {
        return RunShortcutAction.staticActionType.rawValue
    }
}
