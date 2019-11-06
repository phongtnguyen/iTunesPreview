//
//  TableHandler.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit

protocol TableHandlerDelegate {
    func playMusicFromFile(_ fileName: String)
    func presentTrackView(_ track: Track)
}

protocol SearchBarDelegate {
    func addTapDismissKeyboard()
    func removeTapDismissKeyboard()
}

// MARK: - Table View Delegate
class TableHandler: NSObject, UITableViewDelegate {
    
    // MARK: - Tableview stuffs
    var dataSource = [Track]()
    var cellIdentifier = "cell"
    weak var tableView: UITableView?
    
    // MARK: - Delegate and handler
    let queryHandler = QueryHandler() // if queryHandler is local var then self is nil in Alamofire.request
    let downloadHandler = DownloadHandler()
    var delegate: TableHandlerDelegate?
    var searchBarDelegate: SearchBarDelegate?
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = dataSource[indexPath.row]
//        print (track.artistName)
        delegate?.presentTrackView(track)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

// MARK: - Table View Data Source
extension TableHandler: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? TrackCell
        let track = dataSource[indexPath.row]
        cell?.track = track
//        print ("track downloaded \(track.downloaded) and cell downloaded \(cell?.downloaded)")
        cell?.cellDelegate = self
        
        let download: Download? = track.previewUrl != nil ? downloadHandler.activeDownloads[track.previewUrl!] : nil
        cell?.config(download: download)
        
        if let progressIsNotShown = cell?.progressLabel.isHidden {
            if !progressIsNotShown {
                print ("progress is shown at \(indexPath.row)")
            }
        }
        
        return cell ?? TrackCell()
    }
    
}

// MARK: - Search Bar Delegate
extension TableHandler: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        
        queryHandler.query(searchString: searchText) { [weak self] (results, errorMessage) in
            if let tracks = results { // this is called on main thread
                self?.dataSource = tracks
                self?.tableView?.reloadData()
                self?.tableView?.setContentOffset(CGPoint.zero, animated: true)
            }
            
            if !errorMessage.isEmpty {
                print ("Search error => \(errorMessage)")
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBarDelegate?.addTapDismissKeyboard()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBarDelegate?.removeTapDismissKeyboard()
    }
}

// MARK: - Cell Delegate
extension TableHandler: CellDelegate {
    
    // MARK: - Download
    func downloadTapped(_ cell: TrackCell) {
        if let indexPath = tableView?.indexPath(for: cell) {
            let track = dataSource[indexPath.row]
            downloadHandler.delegate = self
            downloadHandler.download(for: cell, track) { [weak self] (error, response) in
                if error == nil, let response = response, response.statusCode == 200 {
                    self?.downloadFinished(at: indexPath.row, with: track)
                }
            }
        }
    }
    
    private func downloadFinished(at row: Int, with track: Track) {
        track.downloaded = true
        DispatchQueue.main.async {
            self.reload(row)
        }
    }
    
    private func reload(_ row: Int) {
        tableView?.reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    // MARK: - Play
    func playTapped(_ cell: TrackCell) {
        guard let track = cell.track, track.downloaded, let fileName = track.previewUrl?.lastPathComponent else {
            print ("Fail to play track for cell at \(tableView?.indexPath(for: cell))")
            return
        }
        delegate?.playMusicFromFile(fileName)
    }
    
}

// MARK: - Download Handler Protocol
extension TableHandler: DownloadHandlerProtocol {
    
    func showDownloadProgress(for cell: TrackCell, with progress: String) {
        cell.progressLabel.text = "\(progress)%"
        cell.progressLabel.isHidden = false
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        print ("Show download progress for cell at \(indexPath.row)")
        DispatchQueue.main.async {
            self.reload(indexPath.row)
        }
    }
    
}
