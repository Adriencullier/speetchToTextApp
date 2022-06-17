//
//  Record.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

struct Segment {
    let id = UUID()
    let segment: String
    let timeStramp: TimeInterval
    let confidence: Float
}

final class AudioWithTranscription {
    let id = UUID()
    /// Url of the recorded audio file
    let url : URL
    /// Title of the audio
    let title : String
    /// Total duration of the audio
    let totalDuration: TimeInterval
    /// Final transcription of the audio
    var finalTranscription: String
    /// Segments contained in finalTranscription
    var finalTranscriptionSegments: [Segment]
    
    init(url: URL,
         title: String,
         totalDuration: Double,
         finalTranscription: String,
         finalTranscriptionSegments: [Segment]) {
        self.url = url
        self.title = title
        self.totalDuration = totalDuration
        self.finalTranscription = finalTranscription
        self.finalTranscriptionSegments = finalTranscriptionSegments
    }
}
