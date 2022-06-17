//
//  RecordsService.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

final class RecordsService: ObservableObject, PlayAndRecordAudioAccessProtocol {
    @Published private(set) var vocals: [AudioWithTranscription] = []
    @Published private(set) var recordIsProcessing: Bool = false
    
    init() {
        self.resetFileManager()
    }
    
    func playRecord(record: AudioWithTranscription, completion: @escaping (TimeInterval) -> Void) {
        playAndRecordAudioManager.playRecord(record: record) { currentTime in
            completion(currentTime)
        }
    }
    
    func startRecording() {
        playAndRecordAudioManager.startRecording()
    }
    
    func stopRecording() {
        if self.playAndRecordAudioManager.isRecording {
            self.recordIsProcessing = true
        }
        playAndRecordAudioManager.stopRecording { recording in
            self.vocals.append(recording)
            self.recordIsProcessing = false
        }
    }
    
    private func resetFileManager() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        try? FileManager.default.removeItem(at: path)
    }
}
