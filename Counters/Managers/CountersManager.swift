//
//  CountersManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI

/// Class that manages all the counters of the application
class CountersManager: ObservableObject {
    static let shared = CountersManager()
    static let sharedExample = CountersManager(false)
    
    @Published private(set) var counters: [Counter]
    
    /// Adds the counters in the `counters` array to the counters array if they are not already inside a the array
    /// - Parameter counters: array of counters to be added
    /// - Returns: array of counters containing the duplicate counters
    final func add(counters: [CounterCore]) -> [CounterCore] {
        var duplicates: [CounterCore] = []
        var counter: Counter
        
        for value in counters {
            if let c = value as? Counter {
                counter = c
            } else {
                counter = Counter(name: "NoNameCounter", counter: value)
            }
            
            guard !self.counters.contains(counter) else {
                duplicates.append(value)
                continue
            }
            
            self.counters.append(counter)
        }
        
        return duplicates
    }
    
    /// Deletes the specified counter from the array
    /// - Parameter counter: the counter to remove
    /// - Returns: true if the counter has been removed, false if the array didn't contain the specified counter
    final func delete(counter: CounterCore) -> Bool {
        guard let index = self.counters.firstIndex(where: { el -> Bool in
            el == counter
        }) else {
            return false
        }
        
        self.counters.remove(at: index)
        return true
    }
    
    /// Tells if a counter is contained in the counters array
    /// - Parameter counter: counter to be checked against the array
    final func contains(counter: CounterCore) -> Bool {
        guard let _ = self.counters.firstIndex(where: { el -> Bool in
            el == counter
        }) else {
            return false
        }
        
        return true
    }
    
    public static let exampleArray: [Counter] = [
        Counter(name: "Example1", core: CounterCore(initialValue: 5), tintColor: Color(.systemPink)),
        
        Counter(name: "Example2", initialValue: 3, step: 2, finalValue: 9),
        
        Counter(name: "Example3", core: CounterCore(initialValue: 27, step: -9, finalValue: -20), visualizationMode: .circularProgress),
        
        Counter(name: "Example4", tintColor: Color(.systemGreen), visualizationMode: .circularProgress, initialValue: 34)
    ]
    
    init() {
        self.counters = [Counter]()
    }
    
    init(_: Bool) {
        self.counters = CountersManager.exampleArray
    }
}
