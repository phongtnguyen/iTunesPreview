//
//  Constants.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/5/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation

struct Constants {
//    static let songList = ["A Billion Year", "Bake a Cake", "Furaregaigirl", "A Bee and Circus", "Ru-Rararu-Ra-Rurararu-Ra-", "Eyes Mismatched in Colour", "Sorewa Chiisana Hikarinoyouna", "Anonymous", "Summer", "Birthday Song", "Mikazuki", "Parallel Line"]
    static let songList: [String] = {
        var storedMp3 = [String]()
        let mp3FileURLs = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
        guard let urls = mp3FileURLs else { return storedMp3 }
        for url in urls {
            let fileNameWithExtension = url.lastPathComponent
            if let fileName = fileNameWithExtension.components(separatedBy: ".").first {
                storedMp3.append(fileName)
            }
        }
        return storedMp3
    }()
}
