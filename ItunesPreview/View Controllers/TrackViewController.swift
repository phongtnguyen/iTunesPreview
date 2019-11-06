//
//  TrackViewController.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/4/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import SwifterSwift
import SDWebImage
import AVFoundation
import Alamofire

class TrackViewController: UIViewController {
    
    // MARK: - View components
    let artworkImage = UIImageView()
    let artistAlbumLabel = UILabel()
    let trackLabel = UILabel()
    let priceLabel = UILabel()
    let releaseDateLabel = UILabel()
    let genreLabel = UILabel()
    let countryLabel = UILabel()
    let playButton = UIButton()
    let buyButton = UIButton()
    
    // if initialize AVAudioPlayer here, exc_bad_access when dismiss view
    var player: AVAudioPlayer?
//    var isPlaying = false
//    var hasBeenPaused = false
    var track: Track? {
        didSet {
            if let _ = track {
                updateTrackInfo()
            }
        }
    }
    var httpURLResponse: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    deinit {
//        print ("Track View Controller deinit")
    }

}

extension TrackViewController {
    
    private func setup() {
        setBlurBackground()
        
        // text size
        let headerTextSize: CGFloat = 18
        let bodyTextSize: CGFloat = 13
        
        // buttons
        let dismissButton = UIButton()
        
        // stack view
        let stackView = UIStackView(arrangedSubviews: [priceLabel, releaseDateLabel, genreLabel, countryLabel], axis: .vertical, spacing: 0, alignment: .fill, distribution: .fillEqually)
        
        // add to view
        view.addSubviews([dismissButton, playButton, buyButton, artworkImage, artistAlbumLabel, trackLabel, stackView])
        
        // MARK: Buttons
        // Dismiss button
        if let image = UIImage(named: "dismiss") {
            dismissButton.configure(image: image, tintColor: .gray, contentMode: .scaleToFill, tag: 2000)
        } else {
            dismissButton.configure(title: "Dismiss", titleColor: .gray, tag: 2000, font: .monospacedSystemFont(ofSize: 12, weight: .semibold), background: nil)
        }
        dismissButton.addConstraintsWithSize(yAnchor: dismissButton.topAnchor, by: 20, to: view.topAnchor, xAnchor: dismissButton.centerXAnchor, by: 0, to: view.centerXAnchor, height: 25, width: 40)
        dismissButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        
        // Play button
        if let image = UIImage(named: "play") {
            playButton.configure(image: image, tintColor: .black, contentMode: .scaleToFill, tag: 2100)
        } else {
            playButton.configure(title: "Play", titleColor: .black, tag: 2100, font: .monospacedSystemFont(ofSize: 20, weight: .semibold), background: nil)
        }
        playButton.addConstraintsWithSize(yAnchor: playButton.topAnchor, by: 10, to: artistAlbumLabel.bottomAnchor, xAnchor: playButton.centerXAnchor, by: 0, to: view.centerXAnchor, height: 35, width: 35)
        playButton.addTarget(self, action: #selector(playAction), for: .touchUpInside)
        
        // Buy button
        buyButton.configure(title: "Buy song", titleColor: .black, tag: 2200, font: .systemFont(ofSize: bodyTextSize), background: #colorLiteral(red: 1, green: 0.8019956946, blue: 0.2552993596, alpha: 1))
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = UIColor.black.cgColor
        buyButton.addConstraintsWithSize(yAnchor: buyButton.topAnchor, by: 10, to: artistAlbumLabel.bottomAnchor, xAnchor: buyButton.centerXAnchor, by: 0, to: view.centerXAnchor, height: 30, width: 130)
//        buyButton.isHidden = true
        buyButton.addTarget(self, action: #selector(buyAction), for: .touchUpInside)
        
        // MARK: Artwork Image
        artworkImage.addConstraintsWithSize(yAnchor: artworkImage.topAnchor, by: 20, to: dismissButton.bottomAnchor, xAnchor: artworkImage.centerXAnchor, by: 0, to: view.centerXAnchor, height: 250, width: 250)
        artworkImage.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: UIColor.black.cgColor)
        artworkImage.backgroundColor = nil
        
        // MARK: Labels
        trackLabel.configure(font: .monospacedSystemFont(ofSize: headerTextSize, weight: .semibold), textColor: .black, alignment: .center)
        trackLabel.addConstraintsWithKnownSize(yAnchor: trackLabel.topAnchor, by: 20, to: artworkImage.bottomAnchor, xAnchor: trackLabel.centerXAnchor, by: 0, to: view.centerXAnchor)
        
        artistAlbumLabel.configure(font: .monospacedSystemFont(ofSize: bodyTextSize, weight: .thin), textColor: .darkGray, alignment: .center)
        artistAlbumLabel.addConstraintsWithKnownSize(yAnchor: artistAlbumLabel.topAnchor, by: 0, to: trackLabel.bottomAnchor, xAnchor: artistAlbumLabel.centerXAnchor, by: 0, to: view.centerXAnchor)
        
        releaseDateLabel.configure(font: .monospacedSystemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        priceLabel.configure(font: .monospacedSystemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        genreLabel.configure(font: .monospacedSystemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        countryLabel.configure(font: .monospacedSystemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        
        stackView.addConstraintsWithSize(yAnchor: stackView.topAnchor, by: 30, to: playButton.bottomAnchor, xAnchor: stackView.centerXAnchor, by: 0, to: view.centerXAnchor, height: 70, width: 300)
        
//        trackLabel.text = "Track Name"
//        artistAlbumLabel.text = "Artist –– Album"
//        releaseDateLabel.text = "24 Aug 2091"
//        priceLabel.text = "$9.99"
//        genreLabel.text = "Ballad"
//        countryLabel.text = "Holy Roman Empire"
//        artworkImage.sd_setImage(with: URL(string: "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png"), completed: nil)
    }
    
    @objc private func dismissView(_ sender: UIButton) {
        if sender.tag == 2000 {
            self.dismiss(animated: true, completion: {
                // dismiss view completion handler
            })
        }
    }
    
    @objc private func playAction(_ sender: UIButton) {
        guard let player = player, sender.tag == 2100 else { return }
        if player.isPlaying {
            player.pause()
            sender.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player.play()
            sender.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
    
    @objc private func buyAction(_ sender: UIButton) {
        sender.animateViewWithSpringEffect(duration: 0.1, delay: 0, springSize: 0.975)
        guard let url = track?.trackViewUrl, sender.tag == 2200 else { return }
//        print ("Open \(url.absoluteString)")
        UIApplication.shared.open(url) // => URL only works on device because it will open iTunes
        
        // encoding error? => link automatically open in itunes
        // redirect url https://music.apple.com/us/album/moon-bouquet/1341019536?i=1341019925&ign-mpt=uo%3D4 => get this in response.response
        // stored url https://music.apple.com/us/album/moon-bouquet/1341019536?i=1341019925&uo=4
    }
    
    private func setBlurBackground() {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
    
    private func updateTrackInfo() {
        guard let track = track else { return }
        trackLabel.text = track.trackName
        artistAlbumLabel.text = "\(track.artistName) –– \(track.collectionName)"
        releaseDateLabel.text = track.releaseDate
        priceLabel.text = "$\(track.trackPrice)"
        genreLabel.text = track.primaryGenreName
        countryLabel.text = track.country
        
        let playerController = AudioPlayerController.init(track)
        player = playerController.player
        
        if player == nil {
            playButton.isHidden = true
//            buyButton.isHidden = false
            let buttonAttributedTitle = NSMutableAttributedString(string: "Buy song ", attributes: [.font: UIFont.systemFont(ofSize: 13)])
            let price = NSMutableAttributedString(string: "$\(track.trackPrice)", attributes: [.font: UIFont.boldSystemFont(ofSize: 13)])
            buttonAttributedTitle.append(price)
            buyButton.setAttributedTitle(buttonAttributedTitle, for: .normal)
            usePreviewArtwork(track)
            getTrackInfoFromURL(track.trackViewUrl)
        } else if let artwork = playerController.artwork {
            // use artwork from file in Bundle
            buyButton.isHidden = true
            artworkImage.image = artwork
        } else { // use preview artwork first then download high quality artwork
            buyButton.isHidden = true
            usePreviewArtwork(track)
            getTrackInfoFromURL(track.trackViewUrl)
        }
    }
    
    private func usePreviewArtwork(_ track: Track) {
        if let url = track.artworkUrl100 {
            artworkImage.sd_setImage(with: url, completed: nil)
        } else if let url = track.artworkUrl60 {
            artworkImage.sd_setImage(with: url, completed: nil)
        } else {
            artworkImage.sd_setImage(with: URL(string: "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png"), completed: nil)
        }
    }
    
    private func getTrackInfoFromURL(_ trackURL: URL?) { // URL is in HTML
        guard let url = trackURL else { return }
//        let url2 = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=sayuri")
        Alamofire.request(url).response(queue: DispatchQueue.global(qos: .userInteractive)) { [weak self] (response) in
            if let error = response.error {
                print ("\(error.localizedDescription) when getting data from trackViewURL for \(url.absoluteString)")
            }
            if
                let data = response.data,
                let response = response.response,
                response.statusCode == 200 {
                self?.httpURLResponse = response.url
                let parser = Parser()
                if let url = parser.parseHTMLFromDataForURL(data) {
                    DispatchQueue.main.async {
                        self?.artworkImage.sd_setImage(with: url) { (image, error, cacheType, url) in
//                            print ("Set artwork from trackPreviewURL")
                            if image == nil { print ("no image") }
                        }
                    }
                }
            }
            
        }
    }
}
