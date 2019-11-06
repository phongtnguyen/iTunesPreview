//
//  QueryHandler.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import Alamofire

class QueryHandler {
    
    var errorMessage = ""
    var tracks = [Track]()
    
    typealias QueryResult = ([Track]?, String) -> Void
    
    // MARK: - Perform query to get JSON data
    func query(searchString: String, completion: @escaping QueryResult) {
        // URL Component conforms to RFC 3986. Safer with proper percent encoding
        guard let queryURL = constructQueryURL(searchString) else {
            print ("Fail to construct url with search term: \(searchString)")
            return
        }
        
        let defaultQueue = DispatchQueue.init(label: "com.phong.ItunesPreview.QueryHandler", qos: .userInitiated)
        
        Alamofire.request(queryURL).responseJSON(queue: defaultQueue) { [weak self] (response) in
            if let error = response.error {
                self?.errorMessage += "Query Handler Alamo request \(error.localizedDescription)"
            } else if
                let data = response.data,
                let response = response.response,
                response.statusCode == 200 {
                self?.updateSearchResults(data)
                DispatchQueue.main.async {
                    completion(self?.tracks, self?.errorMessage ?? "")
                }
                return
            } else {
                self?.errorMessage += "Receive data is \(response.data) with status code \(response.response?.statusCode ?? -1)"
            }

            DispatchQueue.main.async {
                completion(nil, self?.errorMessage ?? "")
            }
        }
    }
    
    // MARK: - Decode JSON data and update data source
    func updateSearchResults(_ data: Data) {
        tracks.removeAll()
        do {
            let decodedData = try JSONDecoder().decode(SearchResult.self, from: data)
            var index = 0
            for track in decodedData.results {
                tracks.append(Track(artistName: track.artistName, trackName: track.trackName, previewUrl: track.previewUrl, index: index, collection: track.collectionName, artistURL: track.artistViewUrl, collectionURL: track.collectionViewUrl, trackURL: track.trackViewUrl, artworkURL60: track.artworkUrl60, artworkURL100: track.artworkUrl100, collectionPrice: track.collectionPrice, trackPrice: track.trackPrice, releaseDate: track.releaseDate, genre: track.primaryGenreName, country: track.country, trackTimeMillis: track.trackTimeMillis))
//                print (track)
                index += 1
            }
        } catch let error {
            errorMessage += "\(error.localizedDescription) when decoding JSON"
        }
    }
    
    // MARK: - Construct URL
    private func constructQueryURL(_ searchTerm: String) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "itunes.apple.com"
        urlComponents.path = "/search"
        
        let queryParams: [String: String] = [
            "media": "music",
            "entity": "song",
            "term": searchTerm
        ]
        urlComponents.setQueryItems(with: queryParams)
        print ("Query URL =>", urlComponents.url?.absoluteString ?? "No URL")
        return urlComponents.url
    }
}

// MARK: - URLComponents extension
extension URLComponents {
    mutating func setQueryItems(with param: [String: String]) {
        self.queryItems = param.map({ URLQueryItem(name: $0.key, value: $0.value) })
    }
}
