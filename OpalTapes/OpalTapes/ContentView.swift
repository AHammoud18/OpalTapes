//
//  ContentView.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        Text("ooga")
    }

    
}

#Preview {
    MainView()
        .modelContainer(for: Item.self, inMemory: true)
}
