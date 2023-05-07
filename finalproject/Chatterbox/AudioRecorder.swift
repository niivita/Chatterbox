//
//  AudioRecorder.swift
//  Chatterbox
//
//  Created by Nivita Patri on 4/12/23.
//

import Foundation
import AVFoundation

class AudioRecorder{
    var recorder: AVAudioRecorder?
    
    
    /* Recording funcitonalities */
    
    func startRecording(){
        let audioSession = AVAudioSession.sharedInstance()
        do{
            try audioSession.setCategory(.record, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            let settings = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ] as [String : Any]
            recorder = try AVAudioRecorder(url: getDocumentsDirectory().appendingPathComponent("phone_recording.wav"), settings: settings)
            recorder?.record()
        } catch{
            print("error starting recording")
        }
    }
    
    func stopRecording(){
        recorder?.stop()
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

