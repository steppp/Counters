//
//  Counter.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

class Counter: CounterCore {
    var name: String
    var tintColor: Color
    var visualizationMode: CounterCellVisualizationMode
    
    init(name: String, tintColor: Color, visualizationMode: CounterCellVisualizationMode, initialValue: Int) {
        self.name = name
        self.tintColor = tintColor
        self.visualizationMode = visualizationMode
        
        super.init(initialValue: initialValue)
    }
    
    init(name: String, initialValue: Int, step: Int = 1, finalValue: Int? = nil) {
        self.name = name
        self.tintColor = AppearanceManager.shared.defaultCounterCellColor
        self.visualizationMode = AppearanceManager.shared.defaultCounterCellVisualizationMode
        
        super.init(initialValue: initialValue, step: step, finalValue: finalValue)
    }
    
    convenience init(name: String, counter: CounterCore) {
        self.init(name: name, initialValue: counter.initialValue, step: counter.step, finalValue: counter.finalValue)
    }
    
    init(name: String, core: CounterCore, tintColor: Color = AppearanceManager.shared.defaultCounterCellColor, visualizationMode: CounterCellVisualizationMode = AppearanceManager.shared.defaultCounterCellVisualizationMode) {
        self.name = name
        self.tintColor = tintColor
        self.visualizationMode = visualizationMode
        
        super.init(initialValue: core.initialValue, step: core.step, finalValue: core.finalValue)
    }
    
    static let exampleLinearCounter = Counter(name: "Linear Pink", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: Color(.systemPink), visualizationMode: .linearProgress)
    
    static let exampleCircularCounter = Counter(name: "Circular Blue", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: Color(.systemBlue), visualizationMode: .circularProgress)
    
    static let exampleCompactCounter = Counter(name: "Compact Green", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: Color(.systemGreen), visualizationMode: .compact)
}
