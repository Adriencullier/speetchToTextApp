//
//  AudioManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 09/06/2022.
//

import AVFoundation

final class AudioManager {
    static let shared = AudioManager()
    var audioRecorder : AVAudioRecorder!
    var audioPlayer : AVAudioPlayer!
    
    init() {
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
    
    func playRecord(record: Record) {
        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf : record.url)
            self.audioPlayer.prepareToPlay()
            self.audioPlayer.play()
        } catch {
            print("Playing failed")
        }
    }
    
    func startRecording() {
        do {
            self.audioRecorder = try AVAudioRecorder(url: self.getFileName(),
                                                     settings: [
                                                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                                        AVSampleRateKey: 12000,
                                                        AVNumberOfChannelsKey: 1,
                                                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                                     ])
            
            
        } catch {
            print("failed to record")
        }
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
    }
    
    func stopRecording(completion: (Record) -> Void) {
        guard let audioRecorder = audioRecorder, audioRecorder.isRecording else { return }
        audioRecorder.stop()
        completion(Record(url: audioRecorder.url,
                          title: Date().description))
    }
    
    private func getFileName() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return path.appendingPathComponent("CO-Voice : \(Date()).m4a")
    }
}
