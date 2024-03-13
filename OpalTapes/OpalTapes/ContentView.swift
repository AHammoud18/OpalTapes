//
//  ContentView.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @StateObject private var audioData = OpalViewData().audioManager
    @State private var artist: String?
    var body: some View {
        ZStack{
            Text(audioData.track.artist)
            Text(audioData.track.album)
            Text(audioData.track.title)
            Image(uiImage: audioData.track.art ?? UIImage(systemName: "bonjour")!)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    //@Environment(\.modelContext) private var modelContext
    //@Query private var items: [Item]

}

#Preview {
    MainView()
        //.modelContainer(for: Item.self, inMemory: true)
}
