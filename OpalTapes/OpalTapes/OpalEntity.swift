//
//  OpalEntity.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation
import AVFoundation
import UIKit

// Create skeleton of data setup for app (classes, structs, etc.)


protocol NetworkRequest {
    func performRequest(url: URL)
}

protocol AudioPlayerSetup {
    init (url: URL, player: AVAudioPlayer)
    func initalizePlayer() async
}

struct Track {
    let artist: String
    let album: String
    let art: UIImage
    let duration: Double
}

