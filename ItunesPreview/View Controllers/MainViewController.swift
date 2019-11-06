//
//  ViewController.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import SwifterSwift
import AVFoundation
import AVKit
import SDWebImage

class MainViewController: UIViewController {
    
    // MARK: View Components
    let tableView = UITableView()
    let searchController = UISearchController()
    var searchBar = UISearchBar()
    lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    
    // MARK: - Handlers
    let tableHandler = TableHandler()
    
    // MARK: - File and Directory
    let fileManager = FileManager.default
    let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
////    static var downloadLocation: URL {
////        let fileManager = FileManager.default
////        let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
////        let dirURL = docURL.appendingPathComponent("Downloads")
////        if fileManager.fileExists(atPath: dirURL.path) {
////            return dirURL
////        }
////
////        do {
////            try fileManager.createDirectory(at: dirURL, withIntermediateDirectories: true, attributes: nil)
////            return dirURL
////        } catch let error {
////            print ("\(error) when create Downloads directory")
////        }
////        return docURL

////    }
    /**
     2019-11-04 10:32:36.054606-0600 ItunesPreview[2551:235951] [plugin] AddInstanceForFactory: No factory registered for id <CFUUID 0x600003cc5460> F8BB1C28-BAE8-11D6-9C31-00039315CD46
     2019-11-04 10:32:48.453553-0600 ItunesPreview[2551:235951]  AudioObjectSetPropertyData: no object with given ID 0
     2019-11-04 10:32:48.453778-0600 ItunesPreview[2551:235951] AudioSessionSimulatorClientManager.cpp:83:SimulatorUpdateHALForPrimaySession_Priv: Failed to set processVolumeScalar on device. Error: 560947818
     2019-11-04 10:32:48.474417-0600 ItunesPreview[2551:236363]  AudioDeviceStop: no device with given ID
     2019-11-04 10:32:48.475255-0600 ItunesPreview[2551:236363] [aqme] AQMEIO.cpp:320:_FindIOUnit: error -66680 finding/initializing AQDefaultDevice
     2019-11-04 10:32:48.477153-0600 ItunesPreview[2551:236363] CA_UISoundClient.cpp:110:CA_UISoundClientBase: * * * NULL AQIONode object
     2019-11-04 10:32:48.477723-0600 ItunesPreview[2551:236363] CA_UISoundClient.cpp:772:UISoundNewRenderer: Can't make UISound Renderer
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
}

// MARK: - Table Handler Delegate
extension MainViewController: TableHandlerDelegate {
    
    func playMusicFromFile(_ fileName: String) {
        guard let url = docURL?.appendingPathComponent("\(fileName)") else {
            print ("File to get path from \(fileName)")
            return
        }

////        let url = MainViewController.downloadLocation.appendingPathComponent(fileName)
////
////        if !fileManager.fileExists(atPath: url.path) {
////            print ("File not found at \(url.path)")
////            return
////        }
        
        let playerViewController = AVPlayerViewController()
        present(playerViewController, animated: true, completion: nil)
        let player = AVPlayer(url: url)
        playerViewController.player = player
        player.play()
        
    }
    
    func presentTrackView(_ track: Track) {
        let trackViewController = TrackViewController.init()
        trackViewController.track = track
        present(trackViewController, animated: true, completion: nil)
    }
    
}

// MARK: - Search Bar Delegate
extension MainViewController: SearchBarDelegate {
    
    // if tap gesture recognizer presents then 1 tap doesn't select cell. Have to hold
    func addTapDismissKeyboard() {
        view.addGestureRecognizer(tapRecognizer)
    }
    
    func removeTapDismissKeyboard() {
        view.removeGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        if searchBar.isFirstResponder { searchBar.resignFirstResponder() }
    }
    
}

// MARK: - View setup
extension MainViewController {
    
    private func setup() {
        addTableView()
        addButtons()
    }
    
    // MARK: - TableView
    private func addTableView() {
        view.addSubview(tableView)
        tableView.addToViewWithConstraints(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 0, bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: -50, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 0, trailing: view.safeAreaLayoutGuide.trailingAnchor, trailingConstant: 0)
        tableHandler.cellIdentifier = "trackCell"
        tableHandler.tableView = tableView
        tableHandler.delegate = self
        tableHandler.searchBarDelegate = self
        tableView.configure(delegate: tableHandler, dataSoure: tableHandler, cellIdentifier: "trackCell", cellClass: TrackCell.self, background: .white)
        searchBar = tableView.addSearchBar(delegate: tableHandler)
    }
    
    // MARK: - Buttons
    private func addButtons() {
        let delButton = UIButton()
        delButton.setTitleForAllStates("Delete Data")
        delButton.setTitleColorForAllStates(.blue)
        delButton.tag = 1000
        delButton.addTarget(self, action: #selector(btnClicked), for: .touchUpInside)
        
        let stackView = UIStackView.init(arrangedSubviews: [delButton], axis: .horizontal, spacing: 10, alignment: .fill, distribution: .fillEqually)
        
        view.addSubview(stackView)
        stackView.addToViewWithConstraints(top: tableView.bottomAnchor, topConstant: 10, bottom: view.safeAreaLayoutGuide.bottomAnchor, bottomConstant: -10, leading: view.safeAreaLayoutGuide.leadingAnchor, leadingConstant: 40, trailing: view.safeAreaLayoutGuide.trailingAnchor, trailingConstant: -40)
    }
    
    @objc func btnClicked(_ sender: UIButton) {
        if sender.tag == 1000 {
            print ("Remove SD Image Cache")
            SDImageCache.shared.clearMemory()
            SDImageCache.shared.clearDisk(onCompletion: nil)
        }
    }

}

