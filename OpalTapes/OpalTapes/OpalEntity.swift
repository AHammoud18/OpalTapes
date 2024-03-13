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
}

protocol AudioData {
    func getMetadata(player: AVPlayer?) async
    func playSong()
    func pauseSong()
    func favoriteSong()
    func nextSong() async
    func prevSong()
    func repeatSong()
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

struct playerButton {
    
    var buttonType: String
    var command: ()
    
    init(buttonType: String, command: ()) {
        self.buttonType = buttonType
        self.command = command
    }
    
    func buttonSetup() -> some View {
        return Button {
            self.command
        }label: {
            Image(uiImage:UIImage(systemName: self.buttonType)!)
        }
    }
}

