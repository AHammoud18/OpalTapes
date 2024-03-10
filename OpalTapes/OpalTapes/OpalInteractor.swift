//
//  OpalInteractor.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import Foundation
import AVKit
import AVFoundation


final class FetchTrack: NetworkRequest, ObservableObject {

    init(){
        let url = URL(string: "https://8ryrb4e4he.execute-api.us-east-1.amazonaws.com/default/createPresignedURL?gd7lHEDAJx7Bo6JpCkXcO8nbJuTDFnTR8d6aMflJ")!
        performRequest(url: url)
    }

    func performRequest(url: URL) {
        var methodURL: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("gd7lHEDAJx7Bo6JpCkXcO8nbJuTDFnTR8d6aMflJ", forHTTPHeaderField: "x-api-key")
            return request
        }
        
        let task = URLSession.shared.dataTask(with: methodURL) { data, response, error in
            if let error = error {
                assertionFailure("Error fetching URL: \(error)")
            }
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                assertionFailure("Response Failure: \(String(describing: response))")
                return
            }
            
            guard let body = String(data: data!, encoding: .utf8) else {
                print("No data found in response")
                return
            }
            print(body)
            
        }
        task.resume()
        
    }
    
}

class AudioPlayer: AVAudioSession, ObservableObject, AudioPlayerSetup {
    
    let url: URL
    public var player: AVAudioPlayer
    
    required init(url: URL, player: AVAudioPlayer) {
        self.url = url
        self.player = player
        
    }
    
    
    func initalizePlayer() async {
        // Launch Audio Session On App Launch
        let session = AVAudioSession()
        guard let session = try? session.setActive(true) else {
            print("Error starting audio session")
            return
        }
        let item = AVPlayerItem(asset: AVAsset(url: url))
        let player = AVPlayer(playerItem: item)
        
        player.play()
        
        ///Two Methods to setup the next song? *Look into AVQueuePlayer*
        
        //player.replaceCurrentItem(with: )
        //AVQueuePlayer(playerItem: )
        
    }
    
    
}
