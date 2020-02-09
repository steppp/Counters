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
    
    var requiresBiometricAuthorization = true
    var isHapticFeedbackEnabled = true
    
    static let defaultSoundName = "sound1"
    let availableSounds: [String] = [ PreferencesManager.defaultSoundName, "sound2", ]
    
    final func toggleHapticFeedback() {
        self.isHapticFeedbackEnabled.toggle()
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
    
    final func savePreferences(usingDataManager dataManager: DataManager) {
        dataManager.savePreferences()
    }
    
    final func loadPreferences(usingDataManager dataManager: DataManager) {
        dataManager.loadPreferences()
    }
}
