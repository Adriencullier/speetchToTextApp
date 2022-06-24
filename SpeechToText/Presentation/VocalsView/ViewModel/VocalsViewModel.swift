//
//  VocalsViewModel.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 10/06/2022.
//

import Combine
import SwiftUI

final class VocalsViewModel: ObservableObject {
    
    private weak var recordsService: RecordsService!
    
    @Published private(set) var storedRecordings: [AudioWithTranscription] = []
    @Published private(set) var recordIsProcessing: Bool = false
    
    var cancellable = Set<AnyCancellable>()
    
    init(recordsService: RecordsService) {
        self.recordsService = recordsService
        self.observeService()
    }
    
    func recordDidPressed(completion: @escaping (TimeInterval?) -> Void) {
        recordsService.startRecording { currentTime in
            completion(currentTime)
        }
    }
    
    func stopRecordDidPressed() {
        recordsService.stopRecording()
    }
    
    func playDidPressed(_ rec: AudioWithTranscription,
                    completion: @escaping (TimeInterval?) -> Void) {
        recordsService.playRecord(record: rec) { time in
            completion(time)
        }
    }
    
    func getProgressbarValue(durationTot: CGFloat,
                            currentTime: CGFloat) -> CGFloat {
        return (250 * currentTime) / durationTot 
    }
    
    func getConfidenceLevel(record: AudioWithTranscription) -> ConfidenceLevel {
        let medConf = (record.finalTranscriptionSegments.reduce(0) { _, seg in
            Int(seg.confPercent)
        }) / record.finalTranscriptionSegments.count

        switch medConf {
        case 80...: return .good
        case ...60: return .bad
        default: return .medium
        }
    }
    
    private func observeService() {
        self.recordsService.$records
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
