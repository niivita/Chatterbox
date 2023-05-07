//
//  AWSManager.swift
//  Chatterbox
//
//  Created by Nivita Patri on 4/17/23.
//

import Foundation
import AWSS3


let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "AKIAUC7NAIENYR4HPU4X", secretKey: "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")

let S3BucketName = "chattabox"
let S3Region = AWSRegionType.USEast1
let S3BucketURLString = "https://s3-\(S3Region.rawValue).amazonaws.com/\(S3BucketName)"
let S3 = AWSS3TransferUtility.default()

class AWSManager {
    
    static func configureAWS() {
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
//    static func downloadAudioFromS3(fileName: String, completion: @escaping (URL?) -> Void) {
//        configureAWS()
//        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
//            print("Error: could not get document directory URL")
//            completion(nil)
//            return
//        }
//        let downloadingFileURL = directoryURL.appendingPathComponent(fileName)
//        let fileManager = FileManager.default
//        let expression = AWSS3TransferUtilityDownloadExpression()
//        // create a URL for the file to download to (temporary directory)
//        S3.download(to: downloadingFileURL, bucket: S3BucketName, key: fileName, expression: expression) { (task, url, data, error) in
//            if let error = error {
//                print("Error downloading audio file from S3: \(error.localizedDescription)")
//                completion(nil)
//            } else {
//                print("Audio file downloaded from S3: \(fileManager.fileExists(atPath: downloadingFileURL.path))")
//                completion(downloadingFileURL)
//            }
//        }
//        }
    
    static func downloadAudioFromS3(fileName: String, completion: @escaping (URL?) -> Void) {
        configureAWS()
        guard let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Error: could not get document directory URL")
            completion(nil)
            return
        }
        let downloadingFileURL = directoryURL.appendingPathComponent(fileName)
        let fileManager = FileManager.default
        
        // Get the metadata of the S3 object
        if let headRequest = AWSS3HeadObjectRequest() {
            headRequest.bucket = S3BucketName
            headRequest.key = fileName
            AWSS3.default().headObject(headRequest).continueWith { (task: AWSTask<AWSS3HeadObjectOutput>) -> Any? in
                if let error = task.error {
                    print("Error checking for newer version of audio file on S3: \(error.localizedDescription)")
                    completion(nil)
                } else if let headObjectResponse = task.result {
                    
                    /*Testing */
                    if let headObjectResponse = task.result {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let lastModifiedString = dateFormatter.string(from: headObjectResponse.lastModified!)
                        print("File was last modified on S3 at: \(lastModifiedString)")
                        // rest of your code...
                    }
                    
                    let s3LastModifiedDate = headObjectResponse.lastModified!
                    let localLastModifiedDate = try? fileManager.attributesOfItem(atPath: downloadingFileURL.path)[.modificationDate] as? Date
                    if localLastModifiedDate == nil || s3LastModifiedDate > localLastModifiedDate! {
                        // The S3 file is newer or the local file does not exist
                        let expression = AWSS3TransferUtilityDownloadExpression()
                        S3.download(to: downloadingFileURL, bucket: S3BucketName, key: fileName, expression: expression) { (task, url, data, error) in
                            if let error = error {
                                print("Error downloading audio file from S3: \(error.localizedDescription)")
                                completion(nil)
                            } else {
                                print("Audio file downloaded from S3: \(fileManager.fileExists(atPath: downloadingFileURL.path))")
                                completion(downloadingFileURL)
                            }
                        }
                    } else {
                        // The local file is already up to date
                        print("Local file is already up to date")
                        completion(downloadingFileURL)
                    }
                }
                return nil
            }
        }
    }


    
    static func uploadAudioToS3(audioURL: URL, fileName: String, aclCanonicalID: String? = nil) {
            let s3ObjectKey = fileName
            configureAWS()
            let uploadExpression = AWSS3TransferUtilityUploadExpression()
        if aclCanonicalID != nil {
                uploadExpression.setValue("95124b965975b9cff1cbdb2a67fa32ea195c1809b024c46898f30cb487f2595c", forRequestHeader: "x-amz-grant-read")
            } else {
                uploadExpression.setValue("public-read", forRequestHeader: "x-amz-acl")
            }
            
            S3.uploadFile(audioURL, bucket: S3BucketName, key: s3ObjectKey, contentType: "audio/wav", expression: uploadExpression, completionHandler: { (task, error) in
                if let error = error {
                    print("Upload failed with error: \(error.localizedDescription)")
                }
                if task.status == .completed {
                    print("Upload successful")
                }
            }).continueWith(block: { (task) -> Any? in
                if let error = task.error {
                    print("Upload failed with error: \(error.localizedDescription)")
                }
                if task.result != nil {
                    print("Upload successful")
                }
                return nil
            })
        }
}
