//
//  CountersManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

/// Class that manages all the counters of the application
class CountersManager: ObservableObject {
    static let shared = CountersManager()
    static let sharedExample = CountersManager(false)
    
    @Published private(set) var counters: [CounterCore]
    
    /// Adds the counters in the `counters` array to the counters array if they are not already inside a the array
    /// - Parameter counters: array of counters to be added
    /// - Returns: array of counters containing the duplicate counters
    final func add(counters: [CounterCore]) -> [CounterCore] {
        var duplicates: [CounterCore] = []
        
        for counter in counters {
            guard !self.counters.contains(counter) else {
                duplicates.append(counter)
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
        guard let index = self.counters.firstIndex(of: counter) else {
            return false
        }
        
        self.counters.remove(at: index)
        return true
    }
    
    private static let exampleArray: [CounterCore] = [
        CounterCore(initialValue: 10),
        CounterCore(initialValue: 27, step: -9, finalValue: -20),
        CounterCore(initialValue: 3, step: 2, finalValue: 9)
    ]
    
    init() {
        self.counters = [CounterCore]()
    }
    
    init(_: Bool) {
        self.counters = CountersManager.exampleArray
    }
}
