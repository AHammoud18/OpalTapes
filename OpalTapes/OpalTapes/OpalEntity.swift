//
//  OpalEntity.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation
import AVFoundation
import UIKit
import SwiftUI

// Create skeleton of data setup for app (classes, structs, etc.)


protocol NetworkRequest {
    func performRequest(url: URL)
}

protocol AudioPlayerSetup {
    func initalizePlayer(url: URL)
    func nextSong() async
    func prevSong()
    func favoriteSong()
    func playSong()
    func pauseSong()
    func getMetadata(player: AVPlayer?) async
}

struct Track {
    var artist: String
    var album: String
    var title: String
    var art: UIImage?
    var duration: Double
    
    init(artist: String = "", album: String = "", title: String = "", art: UIImage? = nil, duration: Double = 0.0) {
        self.artist = artist
        self.album = album
        self.title = title
        self.art = art
        self.duration = duration
    }
}

