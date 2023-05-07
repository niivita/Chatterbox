//
//  AudioDownloader.swift
//  Chatterbox
//
////  Created by Nivita Patri on 4/30/23.
////
//import Foundation
//import AWSS3
//
//class AudioDownloader {
//    static let shared = AudioDownloader()
//    let transferUtility = AWSS3TransferUtility.default()
//
//    func downloadAudioFromS3(fileName: String, completion: @escaping (URL?) -> Void) {
//        let expression = AWSS3TransferUtilityDownloadExpression()
//        let downloadingFileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName) //downloads it to a temporary directory
//        transferUtility.download(to: downloadingFileURL, bucket: "chattabox", key: fileName, expression: expression) { (task, url, data, error) in
//            if let error = error {
//                print("Error downloading audio file from S3: \(error.localizedDescription)")
//                completion(nil)
//            } else {
//                print("Audio file downloaded from S3: \(downloadingFileURL.absoluteString)")
//                completion(downloadingFileURL)
//            }
//        }
//    }
//}
