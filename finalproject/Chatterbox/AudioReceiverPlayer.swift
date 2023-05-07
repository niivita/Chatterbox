//
//  AudioReceiverPlayer.swift
//  Chatterbox
//
//  Created by Nivita Patri on 4/30/23.
//

import Foundation
import AVFoundation

class AudioReceiverPlayer: NSObject, AVAudioPlayerDelegate {

    var player: AVAudioPlayer?
   
    func downloadAudioAndPlay() {
        let fileName = "lampi_recording.wav"
        AWSManager.downloadAudioFromS3(fileName: fileName, completion: { [weak self] url in
            if let localURL = url {
                print("Download successful beginning to play from dA&P")
                print(self)
                self?.playAudio(withFileName: fileName)
            } else {
                print("Error downloading audio")
            }
        })
    }
    
    
    
    func playAudio(withFileName fileName: String) {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default)
            if session.category == AVAudioSession.Category.playback && session.isOtherAudioPlaying == false {
                do {
                    try session.setActive(true)
                    print("Session activated successfully")
                } catch {
                    print("Error activating session: \(error.localizedDescription)")
                }
            } else {
                print("Session is not active or other audio is already playing")
            }
        } catch let error {
            print("Error setting category to AVAudioSessionCategoryPlayback: \(error.localizedDescription)")
        }
        
        if let player = self.player, player.isPlaying {
            player.stop()
            self.player = nil
        }

        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: could not get document directory URL")
            return
        }

        let fileURL = directoryURL.appendingPathComponent(fileName)
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("File exists at path: \(fileURL.path)")
            } else {
                print("File does not exist at path: \(fileURL.path)")
            }

            // Reuse the same AVAudioPlayer instance
                    if let player = self.player, player.url == fileURL {
                        print("Updating existing player with new file")
                        player.prepareToPlay()
                    } else {
                        print("Creating new player")
                        self.player = try AVAudioPlayer(contentsOf: fileURL)
                        self.player?.delegate = self // Set the delegate
                    }
                    print("attempting to play")
                    self.player?.play()
                    print("played")
                } catch let error {
                    print("Error playing audio: \(error)")
                }
            }


    
}
