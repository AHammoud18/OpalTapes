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
    static let viewData = OpalViewData()
    
    init(audioManager: DataManager = DataManager.data) {
        self.audioManager = audioManager
    }
    
}
