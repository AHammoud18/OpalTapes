//
//  ContentView.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import SwiftUI
import SwiftData
import AVKit

struct MainView: View {
    @StateObject private var viewData = OpalViewData.viewData
    @StateObject private var audioPlayerData = OpalViewData.viewData.audioManager
    @State private var artist: String?
    var body: some View {
        GeometryReader { geo in
            //let width = geo.frame(in: .global).width
            //let height = geo.frame(in: .global).height
            VStack {
                trackInfo()
                    .scaleEffect(CGSize(width: 0.8, height: 0.8))
                    .scenePadding()
                trackControls()
            }.onAppear {
                audioPlayerData.playerReady = {
                    // Handle some local UI updates if the player is ready
                    print("Ready to play")
                }
            }
        }
    }
    
    func trackInfo() -> some View {
        VStack{
            Image(uiImage: audioPlayerData.track.art ?? UIImage(systemName: "bonjour")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            Text(audioPlayerData.track.title)
            Text(audioPlayerData.track.artist)
            Text(audioPlayerData.track.album)
        }
    }
    
    func trackControls() -> some View {
        let controls = ["play.fill", "pause.fill", "repeat", "infinity", "heart", "heart.fill"]
        let status = audioPlayerData.isPlaying
        return HStack {
            playerButton(
                buttonType: self.audioPlayerData.isPlaying ? controls[1] : controls[0],
                command: self.audioPlayerData.isPlaying ? self.audioPlayerData.playSong() : self.audioPlayerData.pauseSong()
            ).buttonSetup()
        }
    }
    
    //@Environment(\.modelContext) private var modelContext
    //@Query private var items: [Item]

}


struct playbackControls : UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let playerView = AVPlayerViewController()
        let audioPlayer = DataManager.data
        playerView.player = audioPlayer.player
        playerView.showsPlaybackControls = true
        return playerView
        //
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //
    }
}



#Preview {
    MainView()
        //.modelContainer(for: Item.self, inMemory: true)
}
