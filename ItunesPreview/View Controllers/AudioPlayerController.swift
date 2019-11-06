//
//  AudioPlayerController.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/5/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import AVFoundation
import FuzzyMatchingSwift
import MediaPlayer

class AudioPlayerController {
    
    var player: AVAudioPlayer?
    var artwork: UIImage?
    
    init(_ track: Track) {
        let closestMatched = Constants.songList.sortedByFuzzyMatchPattern(track.trackName)
        if let first = closestMatched.first, let _ = first.fuzzyMatchPattern(track.trackName) {
//            print (track.trackName, "is in song list")
            if let path = Bundle.main.path(forResource: first, ofType: "mp3") {
                let url = URL.init(fileURLWithPath: path)
                getSongArtwork(from: url)
                prepareSongAndSession(from: url)
            }
        }

//        getItunesMusic()
    }
    
    private func getItunesMusic() {
        print (
            """
            Itunes Music
            –––––––––––––
            """)
        let mediaItems = MPMediaQuery.songs()
        guard let items = mediaItems.items else { print ("No item in library"); return }
        for item in items {
            print (item.title ?? "No title")
        }
    }
    
    private func getSongArtwork(from url: URL) {
        let playerItem = AVPlayerItem(url: url)
        let metadataList = playerItem.asset.metadata
        
        for item in metadataList {
            if item.commonKey?.rawValue == "artwork" {
                if
                    let data = item.dataValue,
                    let image = UIImage(data: data) {
                    artwork = image
                }
            }
        }
    }
    
    private func prepareSongAndSession(from url: URL) {
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playback)
            } catch let sessionError {
                print (sessionError.localizedDescription)
            }
        } catch let playerError {
            print (playerError.localizedDescription)
        }
    }
    
}
