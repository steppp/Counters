//
//  PreferencesManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 05/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI
import AudioToolbox

class PreferencesManager {
    static let shared = PreferencesManager()
    
    private(set) var isHapticFeedbackEnabled = true
    private(set) var isAudioEnabled = false
    
    static let defaultSoundName = "default"
    let availableSounds: [String] = [
        PreferencesManager.defaultSoundName, "sound1", "sound2", "sound3"
    ]
    
    final func toggleHapticFeedback() {
        self.isHapticFeedbackEnabled.toggle()
    }
    
    final func toggleAudio() {
        self.isAudioEnabled.toggle()
    }
    
    final func startHapticFeedbackIfEnabled(forStatus status: CounterStatusAfterStep) {
        if self.isHapticFeedbackEnabled {
            var soundType: UInt32
            
            switch status {
            case .success(let checkpointsWithStatuses):
                if let _ = checkpointsWithStatuses {
                    soundType = kSystemSoundID_Vibrate
                } else {
                    soundType = 1520
                }
            case .overflow(let oInf):
                if oInf == .alreadyAtEdgeValue {
                    soundType = 1521
                } else {
                    soundType = 1519
                }
            default:
                soundType = 1520
            }
            
            AudioServicesPlaySystemSound(soundType)
        }
    }
}
