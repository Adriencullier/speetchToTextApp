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
        #warning("clean init()")
        self.fetchFileManager()
//        self.resetFileManager()
    }
    
    func playRecord(record: Record) {
        PlayAndRecordAudioManager.shared.playRecord(record: record)
    }
    
    func startRecording() {
        PlayAndRecordAudioManager.shared.startRecording()
    }
    
    func stopRecording() {
        PlayAndRecordAudioManager.shared.stopRecording { recording in
            self.vocals.append(recording)
        }
    }
    
    private func resetFileManager() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        try? FileManager.default.removeItem(at: path)
    }
    
    private func fetchFileManager() {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let files = try? FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
        files?.forEach({ file in
            Record(url: file, title: "") { record in
                self.vocals.append(record)
            }
        })
    }
}
