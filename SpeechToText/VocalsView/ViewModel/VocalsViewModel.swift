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
    
    func getConfidenceLevel(record: AudioWithTranscription) -> ConfidenceLevel {
        let medConf = (record.finalTranscriptionSegments.reduce(0) { _, seg in
            Int(seg.confidence)
        } * 10) / record.finalTranscriptionSegments.count
        print(medConf)
        switch medConf {
        case 80...: return .good
        case ...60: return .bad
        default: return .medium
        }
    }
    
    private weak var recordsService: RecordsService!
    
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
    
    func playRecord(_ rec: AudioWithTranscription,
                    completion: @escaping (TimeInterval?) -> Void) {
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
