//
//  RecordsService.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

final class RecordsService: ObservableObject, PlayAndRecordAudioAccessProtocol {
    @Published private(set) var records: [AudioWithTranscription] = []
    @Published private(set) var recordIsProcessing: Bool = false
    
    init() {
        // Aims to start the app with empty fileManager
        self.resetFileManager()
    }
    
    /// Play record
    /// - Parameters:
    ///   - record: AudioWithTranscription
    ///   - completion: Playing time (TimeInterval)
    func playRecord(record: AudioWithTranscription,
                    completion: @escaping (TimeInterval?) -> Void) {
        playAndRecordAudioManager.playRecord(record: record) { currentTime in
            completion(currentTime)
        }
    }
    
    /// Start recording
    /// - Parameters:
    ///   - completion: Playing time (TimeInterval)
    func startRecording(completion: @escaping (TimeInterval?) -> Void) {
        if !self.playAndRecordAudioManager.isRecording {
            playAndRecordAudioManager.startRecording { currentTime in
                    completion(currentTime)
            }
        }
    }
    
    /// Stop recording
    func stopRecording() {
        if self.playAndRecordAudioManager.isRecording {
            self.recordIsProcessing = true
            playAndRecordAudioManager.stopRecording { result in
                switch result {
                case .success(let audioTrans):
                    self.records.append(audioTrans)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.recordIsProcessing = false
            }
        }
    }
    
    /// Remove all the file manager items
    private func resetFileManager() {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
        try? FileManager.default.removeItem(at: path)
    }
}
