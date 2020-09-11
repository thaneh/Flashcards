//
//  FlashcardsApp.swift
//  Flashcards
//
//  Created by Thane Heninger on 8/28/20.
//

import SwiftUI

@main
struct FlashcardsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
