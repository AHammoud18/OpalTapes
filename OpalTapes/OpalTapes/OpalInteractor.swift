//
//  OpalInteractor.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//
// Business Logic of the App

import Foundation
import AVFoundation
import UIKit
import SwiftUI


class FetchTrack: NetworkRequest, ObservableObject {

    var urlResponse: URL?
    
    var networkFetchDone: (() -> Void)?
    
    var audioPlayer = AudioPlayer()
    
    //#MARK: Network Request Method
    func performRequest(url: URL) {
        
        var methodURL: URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("gd7lHEDAJx7Bo6JpCkXcO8nbJuTDFnTR8d6aMflJ", forHTTPHeaderField: "x-api-key")
            return request
        }
        
        let task = URLSession.shared.dataTask(with: methodURL) { data, response, error in
            DispatchQueue.global().asyncAndWait {
                if let error = error {
                    assertionFailure("Error fetching URL: \(error)")
                }
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    assertionFailure("Response Failure: \(String(describing: response))")
                    return
                }
                
                if let data = data {
                    // String response of the temp-signed media file in s3 bucket (URL has percent format)
                    let stringData = String(data: data, encoding: .utf8)!.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                    
                    self.urlResponse = URL(string: stringData)
                    self.networkFetchDone?()
                    DispatchQueue.global().sync {
                        self.setupAudioPlayer()
                    }
                    //audioPlayer.initalizePlayer(url: url!)
                }
            }
        }
        
        task.resume()

    }
    func setupAudioPlayer(){
        guard let url = self.urlResponse else {
            assertionFailure("no url returned!")
            return
        }
        audioPlayer.initalizePlayer(url: url)
    }
    
}
//#MARK: AudioPlayer Class
class AudioPlayer: ObservableObject, AudioPlayerSetup{
    
    let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    var timeObserver: Any?
    var audioData = DataManager.data
    var songDidLoad = false
    
    init(timeObserver: Any? = nil) {
            self.timeObserver = timeObserver
    }
    
    //#MARK: Setup Audio Player With First Network Request
    func initalizePlayer(url: URL) {
        Task {
            // Launch Audio Session On App Launch
            let session = AVAudioSession()
            guard let _ = try? session.setActive(true) else {
                print("Error starting audio session")
                return
            }
            let song = AVPlayerItem(url: url)
            audioData.player = AVPlayer(playerItem: song)
            
            guard let _ = audioData.player else {
                assertionFailure("Audio Player Not Created!")
                return
            }
            
            ///Two Methods to setup the next song? *Look into AVQueuePlayer*
            
            //player.replaceCurrentItem(with: )
            //AVQueuePlayer(playerItem: )
            
            //#MARK: Setup Observer For Player
            NotificationCenter.default.addObserver(self, selector: #selector(songDidComplete), name: AVPlayerItem.didPlayToEndTimeNotification, object: audioData.player?.currentItem)
            
            timeObserver = audioData.player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
                
            }
            // setup audio session to play in the background
            do {
                try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try? AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print(error.localizedDescription)
            }
            
            // Observer to handle song interruptions
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(songInterrupted),
                                                   name: AVAudioSession.interruptionNotification,
                                                   object: AVAudioSession.sharedInstance()
            )
            

            
            
            audioData.playerReady?()
            await audioData.nextSong()
            
            // If observer needs to be removed
            
            /*
             if let timeObserver = timeObserver {
             player?.removeTimeObserver(timeObserver)
             self.timeObserver = nil
             }
             */
        }
    }
    
    @objc func songInterrupted() {
        //#MARK: When the song has been interrupted by another source
        audioData.isPlaying = false
        audioData.player?.pause()
    }
    
    @objc func songDidComplete() {
        //#MARK: Logic Handled Here When Song Ends
        print("songCompleted")
    }
    
}

class DataManager: ObservableObject, AudioData {
    
    static let data = DataManager()
    @Published public var track = Track()
    @Published var player: AVPlayer?
    @Published var songLoaded: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isFavorited: Bool = false
    var playerReady: (() -> Void)?

    
    func getMetadata(player: AVPlayer?) async {
        //#MARK: Fetch Metadata info from track
            do {
                if let playerItem = player?.currentItem {
                    /// .load() runs asynchronously, MainActor to apply UI updates on main thread
                    let metadata = try await playerItem.asset.load(.metadata)
                    
                    for item in metadata {
                        switch item.commonKey {
                        case .commonKeyTitle:
                            if let value = try await item.load(.stringValue) {
                                await MainActor.run {
                                    self.track.title = value
                                }
                            }
                            
                        case .commonKeyArtist:
                            if let value = try await item.load(.stringValue) {
                                await MainActor.run {
                                    self.track.artist = value
                                }
                            }
                        
                        case .commonKeyAlbumName:
                            if let value = try await item.load(.stringValue) {
                                await MainActor.run {
                                    self.track.album = value
                                }
                            }
                            
                            
                        case .commonKeyArtwork:
                            if let value = try await item.load(.dataValue) {
                                await MainActor.run {
                                    let image = UIImage(data: value)
                                    self.track.art = image
                                }
                            }
                            
                        default:
                            continue
                        }
                    }
                }
            }
            catch {
                assertionFailure(error.localizedDescription)
            }
        self.songLoaded = true
    }
    
    func nextSong() async {
        self.songLoaded = false
        await getMetadata(player: self.player)
    }
    
    func setPlayback(_: ()) {
        self.isPlaying ? self.player?.play() : self.player?.pause()
    }
    
    func favoriteSong() {
        //
    }
    
    func prevSong() {
        //
    }
    
    func repeatSong() {
        //
    }
    
}
