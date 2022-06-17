//
//  VocalsViewModel.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Combine
import Foundation

final class VocalsViewModel: ObservableObject {
    @Published var storedRecordings: [AudioWithTranscription] = []
    
    var cancellable = Set<AnyCancellable>()
    
    private weak var recordsService: RecordsService!
    
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        self.observeService()
    }
    
    func recordDidPressed() {
        recordsService.startRecording()
    }
    
    func stopRecordDidPressed() {
        recordsService.stopRecording()
    }
    
    func playRecord(_ rec: AudioWithTranscription,
                    completion: @escaping (TimeInterval) -> Void) {
        recordsService.playRecord(record: rec) { time in
            completion(time)
        }
    }
    
    private func observeService() {
        self.recordsService.$vocals
            .sink { recordings in
                self.storedRecordings = recordings
            }
            .store(in: &cancellable)
    }
}
