//
//  PlaySoundAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 07/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import AVFoundation
import SwiftUI

class PlaySoundAction: CheckpointAction {
    var counter: CounterCore    // this is not necessary (maybe)
    var soundAlert: AVAudioPlayer?
    var url: URL
    
    init(target: CounterCore, playSoundAtPath path: String) {
        self.counter = target
        
        let path = Bundle.main.path(forResource: path, ofType: nil)!
        self.url = URL(fileURLWithPath: path)
    }
    
    func performAction() -> CounterStatusAfterStep {
        do {
            self.soundAlert = try AVAudioPlayer(contentsOf: self.url)
            self.soundAlert?.play()
        } catch {
            debugPrint("Could not create the AVAudioPlayer instance")
        }
        
        return .unmodified
    }
    
    var actionType: ActionType = PlaySoundAction.staticActionType
    static var staticActionType: ActionType = .playSoundAction
    
    static var actionDescription: String = "playSoundAction"
    
    static var localizedActionType: LocalizedStringKey {
        return LocalizedStringKey(stringLiteral: PlaySoundAction.actionDescription)
    }
}

extension PlaySoundAction: CustomStringConvertible {
    var description: String {
        return PlaySoundAction.actionDescription
    }
}
