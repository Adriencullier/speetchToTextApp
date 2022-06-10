//
//  AudioManager.swift
//  SpeechToText
//
//  Created by Adrien Cullier on 09/06/2022.
//

import AVFoundation

final class AudioManager {
    static var audioRecorder : AVAudioRecorder! {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = path.appendingPathComponent("CO-Voice : \(Date()).m4a")
        return try? AVAudioRecorder(url: fileName,
                                    settings: [
                                        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                                        AVSampleRateKey: 12000,
                                        AVNumberOfChannelsKey: 1,
                                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                                    ])
    }
    var audioPlayer : AVAudioPlayer!
    
    static func startRecording() {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    static func stopRecording(completion: (Record) -> Void) {
        audioRecorder.stop()
        completion(Record(url: audioRecorder.url,
                          title: Date().description))
    }
}
