//
//  SpeechRecognizerManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 12/06/2022.
//

import Foundation
import Speech

/// Protocol and extension used to hide AudioWithTranscriptionManager singleton
protocol SpeechRecognizerAccessProtocol {}
extension SpeechRecognizerAccessProtocol {
    var speechRecognizerManager: SpeechRecognizerManager {
        return SpeechRecognizerManager.shared
    }
}

final class SpeechRecognizerManager {
    static fileprivate let shared: SpeechRecognizerManager = SpeechRecognizerManager()
        
    /// Set SFSpeechRecognizer locale to France
    private let recognizer = SFSpeechRecognizer.init(
        locale: Locale.init(identifier: "FR")
    )
    
    
    /// Used to get transcription from audio file
    /// - Parameters:
    ///   - url: url of stored audio
    ///   - completion: Result<Transcription, Error>
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
                if let result = result,
                   result.isFinal {
                    completion(.success(
                        Transcription(
                            bestTranscription: result.bestTranscription.formattedString,
                            segments: result.bestTranscription.segments.map({ seg in
                                return Segment(segment: seg.substring,
                                               timeStramp: seg.timestamp,
                                               confidence: seg.confidence)
                            }))
                    ))
                }
            })
        }
    }
}
