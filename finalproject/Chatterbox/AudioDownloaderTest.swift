//
//  AudioDownloaderTest.swift
//  Chatterbox
//
//  Created by Nivita Patri on 5/1/23.
//

import Foundation
import AWSS3

class AudioDownloaderTest {
    let transferUtility = AWSS3TransferUtility.default()

    func downloadAudioFromS3ToLocal(fileName: String, localFilePath: String) {
        let expression = AWSS3TransferUtilityDownloadExpression()
        let downloadingFileURL = URL(fileURLWithPath: localFilePath)
        transferUtility.download(to: downloadingFileURL, bucket: "chattabox", key: fileName, expression: expression) { (task, url, data, error) in
            if let error = error {
                print("Error downloading audio file from S3: \(error.localizedDescription)")
            } else {
                print("Audio file downloaded from S3 to local file path: \(downloadingFileURL.absoluteString)")
            }
        }
    }
}
