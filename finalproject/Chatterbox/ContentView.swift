//
//  ContentView.swift
//  Chatterbox
//
//  Created by Nivita Patri on 4/8/23.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    let audioRecorder = AudioRecorder()
    let audioPlayer = AudioPlayer()
    let awsManager = AWSManager()
    let audioReceiverPlayer = AudioReceiverPlayer()

    
    var body: some View {
        VStack {
            Button("Hear lamp's message!") {
                audioReceiverPlayer.downloadAudioAndPlay()
                print("playing...")
            }.font(.custom("Marker Felt", size: 24)).offset(y: 120).foregroundColor(.brown)

            Image("teddybear")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: .infinity)
                            .scaleEffect(0.45)
                            .padding(.top)
            
            Button("Start Recording"){
                audioRecorder.startRecording()
                print("recording started")
            }.padding().font(.custom("Marker Felt", size: 24)).offset(y: -100).foregroundColor(.brown)
            
            Button("Stop Recording"){
                audioRecorder.stopRecording()
                print("recording stopped")
                
            }.padding().font(.custom("Marker Felt", size: 24)).offset(y: -100).foregroundColor(.brown)
            
            Button("Replay your recording"){
                audioPlayer.playbackAudio()
                print("replaying...")
                
            }.padding().font(.custom("Marker Felt", size: 24)).offset(y: -100).foregroundColor(.brown)
            
            Button("Send memo") {
                let audioPlayer = AudioPlayer()
                let fileURL = audioPlayer.filename // access the filename property through the audioPlayer instance
                AWSManager.uploadAudioToS3(audioURL: fileURL, fileName: "phone_recording.wav")
                print("sending...")
            }.padding().font(.custom("Marker Felt", size: 24)).offset(y: -100).foregroundColor(.brown)
            
            
            
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
            
            
        }
    }
}

