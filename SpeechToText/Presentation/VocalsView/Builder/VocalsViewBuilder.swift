//
//  VocalsViewBuilder.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

final class VocalsViewBuilder {
    static func createModule(_ recordsService: RecordsService) -> some View {
        let viewModel = VocalsViewModel(recordsService: recordsService)
        return VocalsView(viewModel: viewModel)
    }
}
