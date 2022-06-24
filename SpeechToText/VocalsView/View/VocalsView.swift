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
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center, spacing: 0) {
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
        }
    }
}

struct AudioRow: View {
    @ObservedObject var viewModel: VocalsViewModel
    
    @State var currentTime: TimeInterval = 0
    @State var progressBarValue: CGFloat = 0
    
    let record: AudioWithTranscription
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack(alignment: .center, spacing: 0) {
                Text(record.title)
                    .frame(width: K.titleSize.width,
                           height: K.titleSize.height)
                Spacer()
                    Image(systemName: "play.circle")
                        .resizable()
                        .highPriorityGesture(
                            TapGesture()
                                .onEnded({ _ in
                                    self.viewModel.playRecord(record) { currentTime in
                                        self.progressBarValue = viewModel.getProgressbarValue(
                                            durationTot: record.totalDuration,
                                            currentTime: currentTime ?? 0
                                        )
                                        self.currentTime = currentTime ?? 0
                                    }
                                    if self.currentTime == self.record.totalDuration {
                                        self.currentTime = 0
                                        self.progressBarValue = 0
                                    }
                                })
                        )
                .foregroundColor(.green)
                .frame(width: K.playButtonSize.width,
                       height: K.playButtonSize.height)
            }
            HStack(alignment: .center, spacing: 0) {
                Text(self.currentTime.minuteAndSecondToString())
                    .frame(width: K.timeSize.width,
                           height: K.timeSize.height)
                ZStack(alignment: .leading) {
                    Capsule().fill(Color.black.opacity(0.08)).frame(width: 250,
                                                                    height: 8)
                    Capsule().fill(Color.blue).frame(width: progressBarValue,
                                                     height: 8)
                    
                    ForEach(record.finalTranscriptionSegments.filter({ seg in
                        seg.segment == "voiture"
                    }), id: \.id) { seg in
                        Circle().foregroundColor(.red).frame(width: 10,
                                                             height: 10)
                        .offset(x: viewModel.getProgressbarValue(
                            durationTot: record.totalDuration,
                            currentTime: seg.timeStramp
                        ))
                    }
                }
                Text(record.totalDuration.minuteAndSecondToString())
                    .frame(width: K.timeSize.width,
                           height: K.timeSize.height)
            }
        }.frame(alignment: .center)
            .padding(.vertical)
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

struct TranscriptionView: View {
    let title: String
    let text: String
    let confidenceLevel: ConfidenceLevel
    var confidenceStr: String {
        return confidenceLevel.smiley
        + " "
        + "Niveau de confiance"
        + " "
        + confidenceLevel.description
        + " "
        + confidenceLevel.smiley
    }
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                Text(text)
                    .padding(.top)
                Spacer()
            }
            HStack {
                Spacer()
                Text(confidenceStr)
                    .foregroundColor(confidenceLevel.color)
            }
            Spacer()
        }
        .frame(width: 400)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.automatic)
    }
}

enum ConfidenceLevel {
    case good
    case medium
    case bad
    
    var description: String {
        switch self {
        case .good:
            return "Bon"
        case .medium:
            return "Moyen"
        case .bad:
            return "Mauvais"
        }
    }
    
    var smiley: String {
        switch self {
        case .good:
            return "🤩"
        case .medium:
            return "🤔"
        case .bad:
            return "🤬"
        }
    }
    
    var color: Color {
        switch self {
        case .good:
            return .green
        case .medium:
            return .orange
        case .bad:
            return .red
        }
    }
}
