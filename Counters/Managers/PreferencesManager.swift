//
//  PreferencesManager.swift
//  Counters
//
//  Created by Stefano Andriolo on 05/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import SwiftUI

class PreferencesManager {
    static let shared = PreferencesManager()
    
    private(set) var isHapticFeedbackEnabled = true
    private(set) var isAudioEnabled = false
    
    final func toggleHapticFeedback() {
        self.isHapticFeedbackEnabled.toggle()
    }
    
    final func toggleAudio() {
        self.isAudioEnabled.toggle()
    }
}
