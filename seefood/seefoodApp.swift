//
//  seefoodApp.swift
//  seefood
//
//  Created by David Wang on 1/23/25.
//

import SwiftUI

@main
struct seefoodApp: App {
    @State private var modelData = ModelData()

    var body: some Scene {
        WindowGroup {
            ContentView()
            .environment(modelData)
        }
    }
}
