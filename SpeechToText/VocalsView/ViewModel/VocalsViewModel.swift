//
//  VocalsViewModel.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Combine
import SwiftUI

final class VocalsViewModel: ObservableObject {
    @Published var storedRecordings: [AudioWithTranscription] = []
    @Published var recordIsProcessing: Bool = false
    
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
    
    func getProgressbarValue(durationTot: CGFloat,
                            currentTime: CGFloat) -> CGFloat {
        return (250 * currentTime) / durationTot 
    }
    
    private func observeService() {
        self.recordsService.$vocals
            .sink { [weak self] recordings in
                self?.storedRecordings = recordings
            }
            .store(in: &cancellable)
        
        self.recordsService.$recordIsProcessing
            .sink { [weak self] isProcessing in
                self?.recordIsProcessing = isProcessing
            }
            .store(in: &cancellable)
    }
}
