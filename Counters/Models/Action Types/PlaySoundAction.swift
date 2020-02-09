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
    var path: String
    
    init(target: CounterCore, playSoundAtPath path: String) {
        self.counter = target
        self.path = path
        
        self.url = PlaySoundAction.buildUrl(fromPath: path)
        self.createAndPreparePlayer()
    }
    
    static func buildUrl(fromPath path: String) -> URL {
        var ext: String? = "m4a"
        if let dotIdx = path.lastIndex(of: "."),
            dotIdx == path.index(path.endIndex, offsetBy: -4) {
            ext = nil
        }
        
        let pathObject = Bundle.main.path(forResource: path, ofType: ext)!
        return URL(fileURLWithPath: pathObject)
    }
    
    func createAndPreparePlayer() {
        do {
            self.soundAlert = try AVAudioPlayer(contentsOf: self.url)
            self.soundAlert?.prepareToPlay()
        } catch {
            debugPrint("Could not create the AVAudioPlayer instance: \(error)")
        }
    }
    
    func performAction() -> CounterStatusAfterStep {
        if self.soundAlert == nil {
            // fix for the AVAudioPlayer instance not created when instanciating the class from disk
            self.createAndPreparePlayer()
        }
        
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
        
        let path = try values.decode(String.self, forKey: .path)
        self.path = path
        self.url = PlaySoundAction.buildUrl(fromPath: path)
        
        self.counter = Counter.placeholder
        
        self.createAndPreparePlayer()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.path, forKey: .path)
    }
    
    enum CodingKeys: String, CodingKey {
        case path
    }
}

extension PlaySoundAction: CustomStringConvertible {
    var description: String {
        return PlaySoundAction.staticActionType.rawValue
    }
}
