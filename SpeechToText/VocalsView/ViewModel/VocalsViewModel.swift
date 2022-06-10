//
//  VocalsViewModel.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Combine

final class VocalsViewModel: ObservableObject {
    @Published var storedRecordings: [Record] = []
    
    var cancellable = Set<AnyCancellable>()
    
    private weak var recordsService: RecordsService!
    
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        self.observeService()
    }
    
    func startDidPressed() {
        recordsService.startRecording()
    }
    
    func stopDidPressed() {
        recordsService.stopRecording()
    }
    
    private func observeService() {
        self.recordsService.$vocals
            .sink { recordings in
                self.storedRecordings = recordings
            }
            .store(in: &cancellable)
    }
}
