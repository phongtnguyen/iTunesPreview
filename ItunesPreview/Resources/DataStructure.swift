//
//  DataStructure.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class Download {
    var isDownloading = false
    var progress: Double = 0
    var resumeData: Data?
    var request: DownloadRequest?
    var track: Track
    
    init(_ track: Track) {
        self.track = track
    }
}

struct SearchResult: Codable {
    let resultCount: Int
    let results: [TrackInfo]
}

struct TrackInfo: Codable {
    let artistName: String
    let trackName: String
    let previewUrl: String
    let collectionName: String
    let artistViewUrl: String
    let collectionViewUrl: String
    let trackViewUrl: String
    let artworkUrl60: String
    let artworkUrl100: String
    let collectionPrice: Float
    let trackPrice: Float
    let releaseDate: String
    let primaryGenreName: String
    let country: String
    let trackTimeMillis: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        artistName = try container.decodeIfPresent(String.self, forKey: .artistName) ?? "NO ARTIST INFO"
        trackName = try container.decodeIfPresent(String.self, forKey: .trackName) ?? "NO TRACK INFO"
        previewUrl = try container.decodeIfPresent(String.self, forKey: .previewUrl) ?? ""
        collectionName = try container.decodeIfPresent(String.self, forKey: .collectionName) ?? ""
        artistViewUrl = try container.decodeIfPresent(String.self, forKey: .artistViewUrl) ?? ""
        collectionViewUrl = try container.decodeIfPresent(String.self, forKey: .collectionViewUrl) ?? ""
        trackViewUrl = try container.decodeIfPresent(String.self, forKey: .trackViewUrl) ?? ""
        artworkUrl60 = try container.decodeIfPresent(String.self, forKey: .artworkUrl60) ?? ""
        artworkUrl100 = try container.decodeIfPresent(String.self, forKey: .artworkUrl100) ?? ""
        collectionPrice = try container.decodeIfPresent(Float.self, forKey: .collectionPrice) ?? -1.0
        trackPrice = try container.decodeIfPresent(Float.self, forKey: .trackPrice) ?? -1.0
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate) ?? ""
        primaryGenreName = try container.decodeIfPresent(String.self, forKey: .primaryGenreName) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        trackTimeMillis = try container.decodeIfPresent(Int.self, forKey: .trackTimeMillis) ?? 0
    }
}

class Track {
    var index: Int
    let artistName: String
    let trackName: String
    var previewUrl: URL?
    let collectionName: String
    let artistViewUrl: URL?
    let collectionViewUrl: URL?
    let trackViewUrl: URL?
    let artworkUrl60: URL?
    let artworkUrl100: URL?
    let collectionPrice: Float
    let trackPrice: Float
    let releaseDate: String
    let primaryGenreName: String
    let country: String
    let trackTimeMillis: Int
    
    var downloaded = false
    
    init(artistName: String, trackName: String, previewUrl: String, index: Int, collection: String, artistURL: String, collectionURL: String, trackURL: String, artworkURL60: String, artworkURL100: String, collectionPrice: Float, trackPrice: Float, releaseDate: String, genre: String, country: String, trackTimeMillis: Int) {
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = URL(string: previewUrl)
        self.index = index
        self.collectionName = collection
        self.artistViewUrl = URL(string: artistURL)
        self.collectionViewUrl = URL(string: collectionURL)
        self.trackViewUrl = URL(string: trackURL)
        self.artworkUrl60 = URL(string: artworkURL60)
        self.artworkUrl100 = URL(string: artworkURL100)
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.releaseDate = DateFormatter.formatDateFromString(releaseDate)
        self.primaryGenreName = genre
        self.country = country
        self.trackTimeMillis = trackTimeMillis
    }
}
