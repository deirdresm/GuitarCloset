//
//  GuitarClosetApp.swift
//  Shared
//
//  Created by Deirdre Saoirse Moen on 2/7/22.
//

import SwiftUI

@main
struct GuitarClosetApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
