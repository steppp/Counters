//
//  DataManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 09/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    let countersDataUserDefaultsKey = "userDefaults.countersArray"
    
    final func saveData(counters: [Counter]) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(counters) {
            UserDefaults.standard.set(encoded, forKey: self.countersDataUserDefaultsKey)
            
            let dataString = String(data: encoded, encoding: .utf8)
            if let str = dataString {
                debugPrint(str)
            } else {
                debugPrint("Could not retrieve data string")
            }
        } else {
            debugPrint("Could not encode counters array")
        }
    }
    
    final func retrieveData(counters: inout [Counter]) {
        let decoder = JSONDecoder()
        
        if let decodedData = UserDefaults.standard.data(forKey: self.countersDataUserDefaultsKey) {
            if let decoded = try? decoder.decode([Counter].self, from: decodedData) {
                counters = decoded
            } else {
                debugPrint("Cannot convert decoded data to a counters array")
            }
        } else {
            debugPrint("Cannot read data from UserDefaults")
        }
    }
}
