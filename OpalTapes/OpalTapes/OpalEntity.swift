//
//  OpalEntity.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation
import AVFoundation
import UIKit


protocol NetworkRequest {
    func performRequest(url: String)
}

protocol AudioPlayerSetup {
    init (url: String, player: AVAudioPlayer)
    func initalizePlayer()
}

struct Track {
    let artist: String
    let album: String
    let art: UIImage
    let duration: Double
}

