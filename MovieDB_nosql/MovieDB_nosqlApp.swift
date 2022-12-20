//
//  MovieDB_nosqlApp.swift
//  MovieDB_nosql
//
//  Created by Emmanuel Flores on 12/19/22.
//

import SwiftUI

@main
struct MovieDB_nosqlApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
