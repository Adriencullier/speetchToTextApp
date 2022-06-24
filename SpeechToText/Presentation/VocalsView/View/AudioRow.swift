//
//  AudioRow.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 24/06/2022.
//

import Foundation
import SwiftUI

struct AudioRow: View {
    @ObservedObject var viewModel: VocalsViewModel
    
    @State var currentTime: TimeInterval = 0
    @State var progressBarValue: CGFloat = 0
    
    @Binding var query: String
    
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
                                    self.viewModel.playDidPressed(record) { currentTime in
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
                        self.query.lowercased().contains(seg.segment)
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
        }
        .frame(alignment: .center)
        .padding(.vertical)
    }
}
