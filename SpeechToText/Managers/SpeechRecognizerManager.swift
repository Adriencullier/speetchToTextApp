//
//  SpeechRecognizerManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 12/06/2022.
//

import Foundation
import Speech

protocol SpeechRecognizerAccessProtocol {}
extension SpeechRecognizerAccessProtocol {
    var speechRecognizerManager: SpeechRecognizerManager {
        return SpeechRecognizerManager.shared
    }
}

final class SpeechRecognizerManager {
    static let shared: SpeechRecognizerManager = SpeechRecognizerManager()
    
    init() {}
    
    private let recognizer = SFSpeechRecognizer.init(locale: Locale.init(identifier: "FR"))
    
    func transcribe(from url: URL,
                    completion: @escaping (Result<Transcription, Error>) -> Void) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            guard authStatus == .authorized else {
                print("Authorisation denied")
                return
            }
            self.recognizer?.recognitionTask(with: SFSpeechURLRecognitionRequest(url: url), resultHandler: { result, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                if let result = result, result.isFinal {
                    completion(.success(
                        Transcription(
                            bestTranscription: result.bestTranscription.formattedString,
                            segments: result.bestTranscription.segments.map({ seg in
                                return Segment(segment: seg.substring,
                                               timeStramp: seg.timestamp,
                                               confidence: seg.confidence * 100)
                            }))
                    ))
                }
            })
        }
    }
}

struct Transcription {
    var bestTranscription: String
    var segments: [Segment]
}
