//
//  CountersManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

/// Class that manages all the counters of the application
class CountersManager {
    var counters: Set<CounterCore>
    
    init(counters: Set<CounterCore> = Set()) {
        self.counters = counters
    }
    
    final func add(counters: [CounterCore]) {
        self.counters = Set(counters)
    }
    
    final func delete(counter: CounterCore) -> Bool {
        if let _ = self.counters.remove(counter) {
            return true
        }
        
        return false
    }
}
