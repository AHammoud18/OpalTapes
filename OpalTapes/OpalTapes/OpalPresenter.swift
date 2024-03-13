//
//  OpalPresenter.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation
import SwiftUI
import UIKit
import AVFoundation
import AVKit

class OpalViewData: ObservableObject {
    
    var audioManager: DataManager
    
    init(audioManager: DataManager = DataManager.data) {
        self.audioManager = audioManager
    }

}

protocol PlayerView {
    func playerButtons() -> any View
    func almbumArt(art: UIImage) -> any View
}
