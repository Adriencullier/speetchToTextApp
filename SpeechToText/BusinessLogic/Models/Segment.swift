//
//  Segment.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 24/06/2022.
//

import Foundation

struct Segment {
    let id = UUID()
    let segment: String
    let timeStramp: TimeInterval
    let confidence: Float
    
    var confPercent: Int {
        Int(confidence * 1000)
    }
}
