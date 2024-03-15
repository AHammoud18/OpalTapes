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
    
    func trackInfo(geo: GeometryProxy) -> some View {
        let geo = geo.frame(in: .global)
        return VStack{
                    ZStack {
                        Image(uiImage: audioManager.track.art ?? UIImage(named: "alula")!)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            //.padding(EdgeInsets(top: .zero, leading: .zero, bottom: 40, trailing: .zero))
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(CGSize(width: 3, height: 3))
                            .colorMultiply(audioManager.songLoaded ? .clear : .cyan)
                            .foregroundStyle(Color.red)
                    }
                    .position(x: geo.midX, y: geo.minY*3)
                    .overlay {
                        ZStack {
                            VStack {
                                //Text("Test Title")
                                Text(audioManager.track.title ?? "")
                                    .frame(minWidth: geo.width, alignment: .leading)
                                    .foregroundStyle(.white)
                                    .font(.largeTitle)
                                    .overlay {
                                        //Text("Test Artist")
                                        Text(audioManager.track.artist ?? "")
                                            .foregroundStyle(.white)
                                            .frame(minWidth: geo.width, alignment: .leading)
                                            .font(.title2)
                                            .offset(y: 80)
                                    }
                            }
                        }.position(x: geo.midX, y: geo.height/1.8)
                    }
        }
        
    }
    
    func trackControls(geo: GeometryProxy) -> some View {
        let controls = ["play.fill", "pause.fill", "repeat", "infinity", "heart", "heart.fill"]
        return HStack(spacing: 100) {
            Button {
                self.playbackStatus()
            } label: {
                Image(systemName: self.audioManager.isPlaying ? controls[1] : controls[0])
                    .foregroundStyle(self.audioManager.isPlaying ? .gray : .white)
                    //.resizable()
            }
            // favorite
            Button {
                self.favoriteSong()
            } label: {
                ZStack {
                    if self.audioManager.isFavorited {
                        Image(systemName: controls[5])
                            .shadow(radius: 2)
                            .transition(favAnimation())
                            .foregroundStyle(.pink)
                    }
                    Image(systemName: self.audioManager.isFavorited ? controls[5] : controls[4])
                        .foregroundStyle(self.audioManager.isFavorited ? .pink : .white)
                }
                    //.resizable()
            }
        }
    }
    
    // #MARK: Album / Tape View
    func tapeInfo(geo: GeometryProxy) -> some View {
        let width = geo.frame(in: .global).width
        let height = geo.frame(in: .global).height
        let bottomAnchor = geo.frame(in: .global).maxY
        return ZStack {
            // View Background
            RoundedRectangle(cornerRadius: 12)
                .overlay {
                    VStack {
                        // placeholder for tape model
                        RoundedRectangle(cornerRadius: 24)
                            .foregroundStyle(.indigo)
                        // album info
                        Text("Placeholder Album Name")
                            .bold()
                            .colorInvert()
                        Divider().hidden()
                        // song list from album
                        ScrollView(.vertical) {
                            VStack {
                                // range will be replaced with list of songs from album
                                // configure aws for separate album rather than one
                                ForEach((0..<20), id: \.self) { index in
                                    Text("Song \(index+1)")
                                        .colorInvert()
                                    Divider()
                                }
                            }
                        }.padding()
                    }
                }.foregroundStyle(.white)
        }.frame(width: width, height: height/1.4)
    }
    
    // #MARK: Control Methods
    func playbackStatus() {
        self.audioManager.isPlaying.toggle()
        switch self.audioManager.isPlaying {
        case true:
            if let _ = self.audioManager.player {
                self.audioManager.player?.play()
            }
        case false:
            if let _ = self.audioManager.player {
                self.audioManager.player?.pause()
            }
        }
    }
    
    func favoriteSong() {
        self.audioManager.isFavorited.toggle()
    }
    
    // #MARK: Animations
    
    func favAnimation() -> AnyTransition {
        .scale(scale: CGFloat(1.2)).combined(with: .offset(y: -10)).combined(with: .opacity)
    }
    
    func showAlbumCard() -> AnyTransition {
        .scale(scale: CGFloat(1.2)).combined(with: .offset(y: -10)).combined(with: .opacity)
       // .push(from: .bottom).combined(with: .opacity)
    }
    
}

#Preview {
    MainView()
}
