//
//  TranscriptionView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 24/06/2022.
//

import SwiftUI
import Foundation

struct TranscriptionView: View {
    let title: String
    let text: String
    let confidenceLevel: ConfidenceLevel
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text(text)
                    .font(.system(size: 18))
                    .frame(maxWidth: .infinity)
                    .padding(24)
                    .background(.blue)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
            }
            HStack {
                Spacer()
                Text(confidenceLevel.confidenceStr)
                    .font(.system(size: 13))
                    .padding(8)
                    .background(confidenceLevel.color)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 8)
                    )
            }
            
            Spacer()
        }
        .frame(width: 400)
        .padding(.horizontal)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.automatic)
    }
}
