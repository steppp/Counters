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
    var tintColor: TintColorId
    var visualizationMode: CounterCellVisualizationMode
    
    init(name: String, tintColor: TintColorId, visualizationMode: CounterCellVisualizationMode, initialValue: Int) {
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
    
    init(name: String, core: CounterCore, tintColor: TintColorId = AppearanceManager.shared.defaultCounterCellColor, visualizationMode: CounterCellVisualizationMode = AppearanceManager.shared.defaultCounterCellVisualizationMode) {
        self.name = name
        self.tintColor = tintColor
        self.visualizationMode = visualizationMode
        
        super.init(initialValue: core.initialValue, step: core.step, finalValue: core.finalValue)
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CounterCodingKeys.self)
        self.name = try values.decode(String.self, forKey: .name)
        self.tintColor = try values.decode(TintColorId.self, forKey: .tintColor)
        self.visualizationMode = try values.decode(CounterCellVisualizationMode.self, forKey: .visualizationMode)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CounterCodingKeys.self)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.tintColor, forKey: .tintColor)
        try container.encode(self.visualizationMode, forKey: .visualizationMode)
        
        try super.encode(to: encoder)
    }
    
    enum CounterCodingKeys: String, CodingKey {
        case name, tintColor, visualizationMode
    }
    
    static func isPlaceholder(counter: Counter) -> Bool {
        return counter == placeholder
    }
    
    static let placeholder = Counter(name: "com.stefanoandriolo.counters.placeholderCounter", initialValue: 0)
    
    static let exampleLinearCounter = Counter(name: "Linear Pink", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: .systemPink, visualizationMode: .linearProgress)
    
    static let exampleCircularCounter = Counter(name: "Circular Blue", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: .systemBlue, visualizationMode: .circularProgress)
    
    static let exampleCircularCounterNegative = Counter(name: "Circular Blue Negative", core: CounterCore(initialValue: 5, step: -4, finalValue: 21), tintColor: .systemBlue, visualizationMode: .circularProgress)
    
    static let exampleCompactCounter = Counter(name: "Compact Green", core: CounterCore(initialValue: 5, step: 4, finalValue: 21), tintColor: .systemGreen, visualizationMode: .compact)
}

extension Counter {
    static func == (lhs: Counter, rhs: Counter) -> Bool {
        return lhs.name == rhs.name &&
            lhs.tintColor == rhs.tintColor &&
            lhs.visualizationMode == rhs.visualizationMode &&
            lhs.id == rhs.id
    }
}
