//
//  AudioManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 09/06/2022.
//

import AVFoundation

protocol PlayAndRecordAudioAccessProtocol {}
extension PlayAndRecordAudioAccessProtocol {
    var playAndRecordAudioManager: AudioWithTranscriptionManager {
        return AudioWithTranscriptionManager.shared
    }
}

final class AudioWithTranscriptionManager: NSObject, SpeechRecognizerAccessProtocol {
    
    static let shared = AudioWithTranscriptionManager()
    
    private var timer: Timer?
    
    private var audioRecorder : AVAudioRecorder!
    private var audioPlayer : AVAudioPlayer!
    
    var isRecording: Bool {
        self.audioRecorder.isRecording
    }
    
    override init() {
        super.init()
        self.initializeAudioSession()
    }
    
    private func initializeAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord)
        } catch {
            print("fail to set session category")
        }
        
        do {
            try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
        } catch {
            print("fail to override Output AudioPort")
        }
    }
    
    func playRecord(record: AudioWithTranscription,
                    completion: @escaping (TimeInterval) -> Void) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf : record.url)
            self.audioPlayer.delegate =  self
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.000001,
                                              repeats: true) { [weak self] _ in
                guard let `self` = self else { return }
                completion(self.audioPlayer.currentTime)
            }
        } catch {
            print("Playing failed")
        }
    }
    
    func startRecording() {
        do {
            self.audioRecorder = try AVAudioRecorder(url: self.getFileName(),
                                                     settings: [
                                                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                                        AVSampleRateKey: 44100,
                                                        AVNumberOfChannelsKey: 1,
                                                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                                     ])
        } catch {
            print("failed to record")
        }
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }
    
    func stopRecording(completion: @escaping (AudioWithTranscription) -> Void) {
        guard let audioRecorder = audioRecorder,
              self.isRecording else { return }
        let time = audioRecorder.currentTime
        speechRecognizerManager.transcribe(from: audioRecorder.url) { trans, segs in
            completion(
                AudioWithTranscription(url: audioRecorder.url,
                                       title: Date().description,
                                       totalDuration: time,
                                       finalTranscription: trans,
                                       finalTranscriptionSegments: segs)
            )
        }
        audioRecorder.stop()
    }
    
    private func getFileName() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory,
                                            in: .userDomainMask)[0]
        return path.appendingPathComponent("Audio with transcription: \(Date()).m4a")
    }
}

extension AudioWithTranscriptionManager: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer,
                                     successfully flag: Bool) {
        self.timer?.invalidate()
    }
}
