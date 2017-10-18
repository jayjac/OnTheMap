//
//  SoundPlayer.swift
//  OnTheMap
//
//  Created by Jean-Yves Jacaria on 17/10/2017.
//  Copyright © 2017 Jean-Yves Jacaria. All rights reserved.
//

import Foundation
import AVFoundation


struct SoundPlayer {
    private static let audioFilePath = Bundle.main.path(forResource: "pop_drip", ofType: "wav")
    private static var player: AVAudioPlayer?
    
    private init() {}
    
    static func beep() {
        guard let path = audioFilePath else { return }
        let url = URL(fileURLWithPath: path)
        if player == nil {
            do {
                player = try AVAudioPlayer(contentsOf: url)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        player?.play()
    }
    
}
