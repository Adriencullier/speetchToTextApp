//
//  VocalsView.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import SwiftUI

struct VocalsView: View {
    @ObservedObject var viewModel: VocalsViewModel
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.2)
                .edgesIgnoringSafeArea(.top)
            VStack(alignment: .center, spacing: 0) {
                Text("Vocal View")
                    .padding()
                List {
                    if viewModel.storedRecordings.isEmpty,
                       viewModel.recordIsProcessing {
                        EmptyRow()
                    } else {
                        ForEach(viewModel.storedRecordings, id: \.id) { rec in
                            VStack(alignment: .center, spacing: 0) {
                                AudioRow(viewModel: viewModel,
                                         record: rec)
                                if viewModel.recordIsProcessing,
                                   viewModel.storedRecordings.last?.title == rec.title {
                                    EmptyRow()
                                }
                            }
                        }
                    }
                }
                Spacer()
                HStack(spacing: 32) {
                    Button {
                        viewModel.recordDidPressed()
                    } label: {
                        Image(systemName: "record.circle")
                            .resizable()
                    }
                    .foregroundColor(.red)
                    .frame(width: 48, height: 48)
                    
                    Button {
                        viewModel.stopRecordDidPressed()
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
                Button {
                    self.viewModel.playRecord(record) { currentTime in
                        self.progressBarValue = viewModel.getProgressbarValue(
                            durationTot: record.totalDuration,
                            currentTime: currentTime
                        )
                        self.currentTime = currentTime
                    }
                    if self.currentTime == self.record.totalDuration {
                        self.currentTime = 0
                        self.progressBarValue = 0
                    }
                } label: {
                    Image(systemName: "play.circle")
                        .resizable()
                }
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
