//
//  Counter.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import SwiftUI

class Counter: CounterCore {
    var tintColor: UIColor
    var visualizationMode: CounterVisualizationMode
    
    init(tintColor: UIColor, visualizationMode: CounterVisualizationMode, initialValue: Int) {
        self.tintColor = tintColor
        self.visualizationMode = visualizationMode
        
        super.init(initialValue: initialValue)
    }
}

enum CounterVisualizationMode: String {
    case circleProgress, linearProgress, basic
}
