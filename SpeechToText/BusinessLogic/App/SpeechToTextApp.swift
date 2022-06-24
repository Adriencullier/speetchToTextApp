//
//  SpeechToTextApp.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 09/06/2022.
//

import SwiftUI

@main
struct SpeechToTextApp: App {
    let servicesManager = ServicesManager()

    init() {}
    
    var body: some Scene {
        WindowGroup {
            HomeView(servicesManager: servicesManager)
        }
    }
}
