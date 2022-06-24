//
//  TabBarView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

struct HomeView: View {
    private weak var servicesManager: ServicesManager!
    
    init(servicesManager: ServicesManager) {
        self.servicesManager = servicesManager
    }
    var body: some View {
            VocalsViewBuilder.createModule(servicesManager.recordsService)
    }
}
