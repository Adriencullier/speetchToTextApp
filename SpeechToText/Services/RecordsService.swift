//
//  RecordsService.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Foundation

final class RecordsService: ObservableObject {
    @Published private(set) var vocals: [Record] = []
    
    init() {
        self.resetFileManager()
    }
    
    func startRecording() {
        AudioManager.startRecording()
    }
    
    func stopRecording() {
        AudioManager.stopRecording { recording in
            self.vocals.append(recording)
        }
    }
    
    private func resetFileManager() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        try! FileManager.default.removeItem(at: path)
    }
}
