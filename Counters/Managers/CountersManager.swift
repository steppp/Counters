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
    
    private var savedInBackground = false
    
    func initFromDisk(usingManager dataManager: DataManager) {
        var countersArray = [Counter]()
        dataManager.retrieveData(counters: &countersArray)
        
        self.counters = countersArray
    }
    
    func saveToDisk(usingManager dataManager: DataManager) {
        dataManager.saveData(counters: self.counters)
    }
    
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
        
        // TODO: - WRITE CHANGES TO DISK
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
    
    /// Return the counter that has the specified name contained in the counters list
    /// - Parameter counterName: name of the counter to be searched
    final func getCounter(forName counterName: String) -> Counter? {
        return self.counters.first(where: { $0.name == counterName })
    }
    
    final func getCountersNames(excludingCounter counter: Counter? = nil) -> [String] {
        debugPrint(counter?.name ?? "No name")
        var counters = self.counters
        if let cnt = counter {
            counters = counters.filter({ $0.name != cnt.name })
        }
        
        return counters.map{( $0.name )}
    }
    
    final func getCounter(withId id: String) -> Counter {
        return self.counters.first(where: { $0.id == id })!
    }
    
    private static let exampleCounter3 = Counter(name: "Example3", core: CounterCore(initialValue: 27, step: -9, finalValue: -20), visualizationMode: .circularProgress)
    private static var exampleCounter4: Counter {
        let ch4 = Checkpoint(triggerWhen: TriggerType.multipleOf, value: 3, executeAction: IncrementCounterAction(target: CountersManager.exampleCounter3))
        let ex4 = Counter(name: "Example4", tintColor: .systemGreen, visualizationMode: .circularProgress, initialValue: 34)
        ex4.add(checkpoints: [ch4])
        
        return ex4
    }
    
    public static let exampleArray: [Counter] = [
        CountersManager.exampleCounter3,
        CountersManager.exampleCounter4
    ]
    
    init() {
        self.counters = [Counter]()
    }
    
    init(_: Bool) {
        self.counters = CountersManager.exampleArray
    }
}

extension CountersManager {
    func registerSaveObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(saveData(notification:)), name: UIApplication.willTerminateNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(saveData(notification:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resetSaveStatus(notification:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func backgroundSaveData(notification: NSNotification) {
        self.saveData(notification: notification)
        self.savedInBackground = true
    }
    
    @objc func resetSaveStatus(notification: NSNotification) {
        self.savedInBackground = false
    }
    
    @objc func saveData(notification: NSNotification) {
        if !self.savedInBackground {
            let counters = CountersManager.shared.counters
            debugPrint(counters)
            CountersManager.shared.saveToDisk(usingManager: DataManager.shared)
        }
    }
}
