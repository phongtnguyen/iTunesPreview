//
//  DownloadHandler.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/4/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import Alamofire

protocol DownloadHandlerProtocol {
    func showDownloadProgress(for cell: TrackCell, with progress: String)
}

class DownloadHandler {
    
    // MARK: - Dispacth Queue
    let downloadQueue = DispatchQueue.init(label: "com.phong.ItunesPreview.DownloadHandler.download", qos: .default, attributes: .concurrent)
    let progressQueue = DispatchQueue.init(label: "com.phong.ItunesPreview.DownloadHandler.progress", qos: .background, attributes: .concurrent)
    
    var activeDownloads = [URL: Download]()
    var delegate: DownloadHandlerProtocol?
    
    // MARK: - Perform download from URL
    func download(for cell: TrackCell, _ track: Track, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
        guard let previewURL: URL = track.previewUrl else { print ("Valid url not found"); return }
        let destination: DownloadRequest.DownloadFileDestination = getFilePath(previewURL.lastPathComponent)
        
        let download = Download(track)
        activeDownloads[previewURL] = download
        download.request = Alamofire.download(previewURL, to: destination)
            .downloadProgress(queue: progressQueue, closure: { [weak self] (progress) in
//                print ("Download progress \(progress.fractionCompleted)")
                let progressString = String(Int(progress.fractionCompleted * 100))
                DispatchQueue.main.async {
                    self?.delegate?.showDownloadProgress(for: cell, with: progressString)
                }
        })
            .responseData(queue: downloadQueue) { [weak self] (response) in // only to set downloaded to  true
                self?.activeDownloads[previewURL] = nil
                completion(response.error, response.response)
        }
//        print ("Type of \(type(of: download))")
    }
    
    // MARK: Download directory and options
    private func getFilePath(_ fileName: String) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { (destionation, option) in
            let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//            let docURL = MainViewController.downloadLocation
            let fileURL = docURL.appendingPathComponent(fileName)
//            print ("Download location for \(fileName) is \(fileURL)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
}
