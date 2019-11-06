//
//  TrackCell.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

protocol CellDelegate {
    func downloadTapped(_ cell: TrackCell)
    func playTapped(_ cell: TrackCell)
}

class TrackCell: UITableViewCell {
    
    // MARK: - View Components
    let artworkImage = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    let albumLabel = UILabel()
    let priceLabel = UILabel()
    let progressLabel = UILabel()
    let downloadButton = UIButton()
    
    // MARK: - Delegate
    var cellDelegate: CellDelegate?
    
    var downloaded = false
    
    // MARK: - Track for cell
    var track: Track? {
        didSet {
            if let track = track {
                titleLabel.text = track.trackName
                artistLabel.text = track.artistName
                albumLabel.text = track.collectionName
                priceLabel.text = String(format: "%.2f", track.trackPrice)
                if let url: URL = track.artworkUrl60 {
                    artworkImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                        if let error = error { print (error.localizedDescription) }
                    }
                } else if let url: URL = track.artworkUrl100 {
                    artworkImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                        if let error = error { print (error.localizedDescription) }
                    }
                }
                downloaded = track.downloaded
            }
        }
    }
    
    // MARK: - Configure dynamic view components
    func config(download: Download?) {
        if downloaded {
            downloadButton.setTitleForAllStates("Play")
        } else {
            downloadButton.setTitleForAllStates("Download")
        }
        
        var hideDownloadControl = true
        
        if download != nil {
            hideDownloadControl = false
        }
        
        progressLabel.isHidden = hideDownloadControl
        
//        print ("config for cell at \(self.track?.trackName) with progressLabel hidden \(!downloaded) and downloaded \(downloaded)")
    }
    
    // MARK: - Set up initial cell content view
    func setup() {
        contentView.addSubviews([titleLabel, artistLabel, downloadButton, progressLabel, artworkImage])
        
        titleLabel.configure(font: .monospacedDigitSystemFont(ofSize: 18, weight: .medium), textColor: .black, alignment: .left)
        artistLabel.configure(font: .italicSystemFont(ofSize: 14), textColor: .darkGray, alignment: .left)
        albumLabel.configure(font: .monospacedSystemFont(ofSize: 14, weight: .light), textColor: .gray, alignment: .right)
        priceLabel.configure(font: .monospacedSystemFont(ofSize: 14, weight: .regular), textColor: .gray, alignment: .right)
        progressLabel.configure(font: .monospacedDigitSystemFont(ofSize: 12, weight: .regular), textColor: .darkGray, alignment: .right)
        artworkImage.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: nil)
        
        artworkImage.addToViewWithSize(yAnchor: artworkImage.topAnchor, by: 5, to: contentView.topAnchor, xAnchor: artworkImage.leadingAnchor, by: 5, to: contentView.leadingAnchor, size: 60)
        
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        artistLabel.translatesAutoresizingMaskIntoConstraints = false
//        downloadButton.translatesAutoresizingMaskIntoConstraints = false
//        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.addConstraintsWithKnownSize(yAnchor: titleLabel.topAnchor, by: 5, to: contentView.topAnchor, xAnchor: titleLabel.leadingAnchor, by: 10, to: artworkImage.trailingAnchor)
        
        artistLabel.addConstraintsWithKnownSize(yAnchor: artistLabel.topAnchor, by: 0, to: titleLabel.bottomAnchor, xAnchor: artistLabel.leadingAnchor, by: 10, to: artworkImage.trailingAnchor)
        
        downloadButton.configure(title: "Download", titleColor: .blue, tag: 2000, font: .monospacedSystemFont(ofSize: 14, weight: .light), background: .white)
        downloadButton.addConstraintsWithSize(yAnchor: downloadButton.topAnchor, by: 5, to: artistLabel.topAnchor, xAnchor: downloadButton.trailingAnchor, by: -5, to: contentView.trailingAnchor, height: 20, width: 80)
        downloadButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        progressLabel.addConstraintsWithKnownSize(yAnchor: progressLabel.topAnchor, by: 0, to: downloadButton.bottomAnchor, xAnchor: progressLabel.trailingAnchor, by: -5, to: contentView.trailingAnchor)
        progressLabel.isHidden = true
    }
    
    // MARK: - Cell button action
    @objc func buttonPressed(_ sender: UIButton) {
        if sender.tag == 2000 {
            if let title = sender.titleLabel?.text {
                title == "Download" ? cellDelegate?.downloadTapped(self) : cellDelegate?.playTapped(self)
            }
        }
    }
    
    // MARK: - Cell init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}
