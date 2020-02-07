//
//  PlaySoundAction.swift
//  Counters
//
//  Created by Stefano Andriolo on 07/02/2020.
//  Copyright © 2020 Stefano Andriolo. All rights reserved.
//

import Foundation
import AVFoundation

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
}

extension PlaySoundAction: CustomStringConvertible {
    var description: String {
        return "PlaySoundAction"
    }
}
