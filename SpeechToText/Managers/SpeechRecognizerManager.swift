//
//  SpeechRecognizerManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 12/06/2022.
//

import Foundation
import Speech

final class SpeechRecognizerManager {
    static let shared: SpeechRecognizerManager = SpeechRecognizerManager()
    
    init() {}
    
    private let recognizer = SFSpeechRecognizer.init(locale: Locale.init(identifier: "FR"))
    
    func transcribe(from url: URL,
                    completion: @escaping (String, [Segment]) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                print("Authorisation denied")
                return
            }
            self.recognizer?.recognitionTask(with: SFSpeechURLRecognitionRequest(url: url), resultHandler: { result, error in
                if let error = error {
                    print(error)
                    return
                }
                if let result = result, result.isFinal {
                    completion(result.bestTranscription.formattedString,
                               result.bestTranscription.segments.map({ seg in
                        return Segment(segment: seg.substring,
                                       timeStramp: seg.timestamp,
                                       confidence: seg.confidence * 100)
                    }))
                }
            })
        }
    }
}
