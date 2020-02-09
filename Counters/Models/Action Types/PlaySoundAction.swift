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
        
        self.createAndPreparePlayer()
    }
    
    func createAndPreparePlayer() {
        do {
            self.soundAlert = try AVAudioPlayer(contentsOf: self.url)
            self.soundAlert?.prepareToPlay()
        } catch {
            debugPrint("Could not create the AVAudioPlayer instance")
        }
    }
    
    func performAction() -> CounterStatusAfterStep {
        self.soundAlert?.pause()
        self.soundAlert?.currentTime = 0
        self.soundAlert?.play()
        
        return .unmodified
    }
    
    internal func counterIsPlaceholder(_ counter: CounterCore) -> Bool {
        return false
    }
    
    var actionType: ActionType = PlaySoundAction.staticActionType
    static var staticActionType: ActionType = .playSoundAction
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try values.decode(URL.self, forKey: .url)
        self.counter = Counter.placeholder
        
        self.createAndPreparePlayer()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.url, forKey: .url)
    }
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}

extension PlaySoundAction: CustomStringConvertible {
    var description: String {
        return PlaySoundAction.staticActionType.rawValue
    }
}
