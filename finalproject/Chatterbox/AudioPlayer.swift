//
//  AudioPlayer.swift
//  Chatterbox
//
//  Created by Nivita Patri on 4/12/23.
//

import Foundation
import AVFoundation

class AudioPlayer{
    var audioPlayer: AVAudioPlayer?
    var filename: URL{
        return getDocumentsDirectory().appendingPathComponent("phone_recording.wav")
    }
    func playbackAudio(){
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            print("Error setting category to AVAudioSessionCategoryPlayback: \(error.localizedDescription)")
        }
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: filename)
            audioPlayer?.play()
        } catch{
            print("Error, could not replay audio.")
        }
    }
    
    func getDocumentsDirectory() -> URL {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            return paths[0]
        }

}
