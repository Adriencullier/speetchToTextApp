//
//  VocalsView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

struct VocalsView: View {
    @ObservedObject private var viewModel: VocalsViewModel
    
    init(viewModel: VocalsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.top)
            VStack {
                Text("Vocal View")
                    .padding()
                List {
                    ForEach(viewModel.storedRecordings, id: \.id) { rec in
                        HStack {
                            Text(rec.title)
                            Spacer()
                            Button {
                                AudioManager.shared.playRecord(record: rec)
                            } label: {
                                Image(systemName: "play.circle")
                                    .resizable()
                            }
                            .foregroundColor(.green)
                            .frame(width: 48, height: 48)
                        }
                    }
                }
                Spacer()
                HStack(spacing: 32) {
                    Button {
                        viewModel.startDidPressed()
                    } label: {
                        Image(systemName: "record.circle")
                            .resizable()
                    }
                    .foregroundColor(.red)
                    .frame(width: 48, height: 48)
                    
                    Button {
                        viewModel.stopDidPressed()
                        
                    } label: {
                        Image(systemName: "stop.circle")
                            .resizable()
                    }
                    .foregroundColor(.blue)
                    .frame(width: 48, height: 48)
                }
            }
        }
    }
}
