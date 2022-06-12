//
//  Record.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

final class Record {
    let id = UUID()
    let url : URL
    let title : String
    var transcription: String = ""
    
    init(url: URL,
         title: String,
         completion: @escaping (Record) -> Void) {
        self.url = url
        self.title = title
        SpeechRecognizerManager.shared.transcribe(from: url) { transcription in
            self.transcription = transcription
            completion(self)
        }
    }
}
