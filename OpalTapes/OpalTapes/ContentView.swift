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
    @State private var playbackStatus: Bool = false

    var body: some View {
        GeometryReader { geo in
            let width = geo.frame(in: .global).width
            let height = geo.frame(in: .global).height
            let global = geo.frame(in: .global)
            ZStack {
                VStack {
                    // song info
                    viewData.trackInfo(geo: geo)
                        .scaleEffect(CGSize(width: 0.8, height: 0.8))
                        .padding(EdgeInsets(top: CGFloat(20), leading: .zero, bottom: CGFloat(80), trailing: .zero))
                        .frame(height: height/1.5)
                    // playback will show here
                    Divider()
                        .scaleEffect(CGSize(width: 20, height: 20))
                        .hidden()
                    
                    // track controls
                    viewData.trackControls(geo: geo)
                        .scaleEffect(CGSize(width: 2, height: 2))
                        .padding()
                }.position(x: global.midX, y: global.midY*0.8)
                
                //.background(Color.purple)
                .onAppear {
                    audioPlayerData.playerReady = {
                        // Handle some local UI updates if the player is ready
                        print("Ready to play")
                    }
                }
                
                if self.audioPlayerData.songLoaded {
                    viewData.tapeInfo(geo: geo)
                        .transition(viewData.showAlbumCard())
                        .position(x: width/2, y: height/1)
                        .ignoresSafeArea()
                        .hidden()
                }
            }
        }.background {
            Image(uiImage: audioPlayerData.track.art ?? UIImage(named: "alula")!)
                .resizable()
                .blur(radius: 80)
                .ignoresSafeArea()
                .saturation(0.5)
                .scaledToFill()
                
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
