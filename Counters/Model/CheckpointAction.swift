//
//  CheckpointAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

protocol CheckpointAction: CustomStringConvertible {
    var counter: CounterCore { get set }
    func performAction() -> CounterStatusAfterStep
}
