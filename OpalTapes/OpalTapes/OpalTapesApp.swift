//
//  OpalTapesApp.swift
//  OpalTapes
//
//  Created by Ali Hammoud on 3/9/24.
//

import SwiftUI
import SwiftData

@main
struct OpalTapesApp: App {
    var MainModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView().onAppear {
                let url = URL(string: "https://8ryrb4e4he.execute-api.us-east-1.amazonaws.com/default/createPresignedURL?gd7lHEDAJx7Bo6JpCkXcO8nbJuTDFnTR8d6aMflJ")!
                let requestTrack = FetchTrack()
                requestTrack.networkFetchDone = {
                    print("Finished Request")
                }
                requestTrack.performRequest(url: url )
            }
        }
        .modelContainer(MainModelContainer)
    }
}
