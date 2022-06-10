//
//  TabBarView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

struct TabBarView: View {
    private weak var servicesManager: ServicesManager!
    
    init(servicesManager: ServicesManager) {
        self.servicesManager = servicesManager
    }
    var body: some View {
        TabView {
            VocalsViewBuilder.createModule(servicesManager.recordsService)
                .tabItem {
                    Label("Vocal", systemImage: "waveform")
                        .foregroundColor(.gray)
                }
            TextsView()
                .tabItem {
                    Label("Text", systemImage: "message")
                        .foregroundColor(.gray)
                }
        }
    }
}
