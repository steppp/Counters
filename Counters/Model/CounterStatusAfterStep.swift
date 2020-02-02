//
//  CounterStatusAfterStep.swift
//  Counters
//
//  Created by Stefano Andriolo on 02/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation

enum CounterStatusAfterStep {
    case success([(Checkpoint, CounterStatusAfterStep)]?), overflow(OverflowInfo), deleted, unmodified
    
    enum OverflowInfo {
        case alreadyAtEdgeValue, shouldExceedEdgeValue
    }
}

extension CounterStatusAfterStep: Equatable {
    static func == (lhs: CounterStatusAfterStep, rhs: CounterStatusAfterStep) -> Bool {
        switch (lhs, rhs) {
        case (.overflow(let o1), .overflow(let o2)):
            return o1 == o2
        case (.success(_), .success(_)):
            fallthrough
        case (.deleted, .deleted):
            fallthrough
        case (.unmodified, .unmodified):
            return true
        default:
            return false
        }
    }
}

extension CounterStatusAfterStep: CustomStringConvertible {
    var description: String {
        switch self {
        case .success(let checkpointsWithStatus):
            if let unwrappedValue = checkpointsWithStatus {
                return "Success: triggered checkpoints are \(unwrappedValue.map({val in "\(val.0) with status \(val.1)"}))"
            } else {
                return "Success, no checkpoints triggered"
            }
        case .overflow(let overflowInfo):
            return "Overflow: \(overflowInfo)"
        case .unmodified:
            return "Unmodified"
        case .deleted:
            return "Deleted"
        }
    }
}
