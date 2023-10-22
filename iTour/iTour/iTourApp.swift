//
//  iTourApp.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//


// Model container always runs on main Actor so it is safe to use for any UI thread
//

import SwiftUI
import SwiftData

@main
struct iTourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Destination.self) // NSPersistence and iCloud Container
    }
}
