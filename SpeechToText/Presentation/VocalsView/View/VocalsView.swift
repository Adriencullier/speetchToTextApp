//
//  VocalsView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

struct VocalsView: View {
    @ObservedObject var viewModel: VocalsViewModel
    
    @State private var isRecording = false
    @State private var recordTime: TimeInterval = 0
    @State private var query: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
                    TextField("", text: $query)
                        .foregroundColor(.black)
                        .padding(16)
                        .background(Color.white)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 8)
                        )
                        .padding()
                    ZStack {
                        List {
                            if viewModel.storedRecordings.isEmpty,
                               viewModel.recordIsProcessing {
                                EmptyRow()
                            } else {
                                ForEach(viewModel.storedRecordings, id: \.id) { rec in
                                    VStack(alignment: .center, spacing: 0) {
                                        NavigationLink(destination: {
                                            TranscriptionView(title: "Audio Transcription",
                                                              text: rec.finalTranscription,
                                                              confidenceLevel: viewModel.getConfidenceLevel(record: rec))
                                        }) {
                                            AudioRow(viewModel: viewModel,
                                                     query: $query,
                                                     record: rec)
                                        }
                                        if viewModel.recordIsProcessing,
                                           viewModel.storedRecordings.last?.title == rec.title {
                                            EmptyRow()
                                        }
                                    }
                                }
                            }
                        }
                        .disabled(self.isRecording)
                        if self.isRecording {
                            Text(String(self.recordTime.minuteAndSecondToString()))
                                .font(.title)
                        }
                    }
                    Spacer()
                    HStack(spacing: 32) {
                        Button {
                            viewModel.recordDidPressed { currenTime in
                                self.recordTime = currenTime ?? 0
                            }
                            self.isRecording = true
                        } label: {
                            Image(systemName: "record.circle")
                                .resizable()
                        }
                        .foregroundColor(
                            .red.opacity(self.isRecording ? 0.5: 1)
                        )
                        .frame(width: 48, height: 48)
                        .disabled(self.isRecording)
                        
                        Button {
                            viewModel.stopRecordDidPressed()
                            self.isRecording = false
                        } label: {
                            Image(systemName: "stop.circle")
                                .resizable()
                        }
                        .foregroundColor(
                            .blue.opacity(!self.isRecording ? 0.5: 1)
                        )
                        .frame(width: 48, height: 48)
                        .disabled(!self.isRecording)
                    }
                }
            }
            .navigationTitle("Read My Voice")
            .navigationBarTitleDisplayMode(.automatic)
            .ignoresSafeArea(.keyboard, edges: .all)
        }
    }
}

struct EmptyRow: View {
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text("")
                    .frame(width: K.titleSize.width,
                           height: K.titleSize.height)
                    .background(Color.gray)
                Spacer()
                Button {} label: {
                    Image(systemName: "play.circle")
                        .resizable()
                }
                .foregroundColor(.green)
                .frame(width: K.playButtonSize.width,
                       height: K.playButtonSize.height)
                .overlay(Color.gray)
            }
            HStack(alignment: .center, spacing: 0) {
                Text("")
                    .frame(width: K.timeSize.width,
                           height: K.timeSize.height)
                    .background(Color.gray)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.black.opacity(0.08)).frame(width: 250,
                                                                    height: 8)
                }
                Text("")
                    .frame(width: K.timeSize.width,
                           height: K.timeSize.height)
                    .background(Color.gray)
            }
        }.frame(alignment: .center)
            .padding(.vertical)
    }
}
