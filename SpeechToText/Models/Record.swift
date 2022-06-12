//
//  Record.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

struct Segment {
    let segment: String
    let timeStramp: TimeInterval
    let confidence: Float
}

final class Record {
    let id = UUID()
    let url : URL
    let title : String
    var segments: [Segment] = []
    var finalTranscription: String = ""
    
    var segmentWithTime: String {
        var segmentWithTime = ""
        segments.forEach { seg in
            segmentWithTime += seg.segment
            + " "
            + "("
            + String(format: "%.1f", seg.timeStramp)
            + ")"
            + "/"
        }
        return segmentWithTime
    }
    
    init(url: URL,
         title: String,
         completion: @escaping (Record) -> Void) {
        self.url = url
        self.title = title
        SpeechRecognizerManager.shared.transcribe(from: url) { transcription, segments in
            self.finalTranscription = transcription
            self.segments = segments
            completion(self)
        }
    }
}
