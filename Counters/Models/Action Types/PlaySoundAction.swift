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
        
        var ext: String? = "m4a"
        if let dotIdx = path.lastIndex(of: "."),
            dotIdx == path.index(path.endIndex, offsetBy: -4) {
            ext = nil
        }
        
        let pathObject = Bundle.main.path(forResource: path, ofType: ext)!
        self.url = URL(fileURLWithPath: pathObject)
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
}

extension PlaySoundAction: CustomStringConvertible {
    var description: String {
        return PlaySoundAction.staticActionType.rawValue
    }
}
