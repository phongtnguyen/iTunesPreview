//
//  ViewExtension.swift
//  ItunesPreview
//
//  Created by Phong Nguyen on 11/3/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {

    func configure<T: UITableViewCell>(delegate: UITableViewDelegate, dataSoure: UITableViewDataSource, cellIdentifier: String, cellClass: T.Type, background: UIColor) {
        self.delegate = delegate
        self.dataSource = dataSoure
        self.register(cellClass, forCellReuseIdentifier: cellIdentifier)
        self.backgroundColor = background
    }
    
    func addSearchController(updater: UISearchResultsUpdating) -> UISearchController {
        let ctrl = UISearchController(searchResultsController: nil)
        ctrl.searchBar.sizeToFit()
        ctrl.searchBar.autocapitalizationType = .none
        ctrl.hidesNavigationBarDuringPresentation = false
        ctrl.searchResultsUpdater = updater
        tableHeaderView = ctrl.searchBar
        return ctrl
    }
    
    func addSearchBar(delegate: UISearchBarDelegate) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.autocapitalizationType = .none
        searchBar.autocorrectionType = .no
        searchBar.sizeToFit()
        tableHeaderView = searchBar
        searchBar.delegate = delegate
        return searchBar
    }

}

extension UIView {
    
    func addToViewWithConstraints(top: NSLayoutYAxisAnchor, topConstant: CGFloat, bottom: NSLayoutYAxisAnchor, bottomConstant: CGFloat, leading: NSLayoutXAxisAnchor, leadingConstant: CGFloat, trailing: NSLayoutXAxisAnchor, trailingConstant: CGFloat) {
//        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
        trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant).isActive = true
    }
    
    func addToViewWithSize(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor, size: CGFloat) {
//        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
        heightAnchor.constraint(equalToConstant: size).isActive = true
        widthAnchor.constraint(equalToConstant: size).isActive = true
    }
    
    func addConstraintsWithKnownSize(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor) {
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
    }
    
    func addConstraintsWithSize(yAnchor: NSLayoutYAxisAnchor, by yConstant: CGFloat, to viewYAnchor: NSLayoutYAxisAnchor, xAnchor: NSLayoutXAxisAnchor, by xConstant: CGFloat, to viewXAnchor: NSLayoutXAxisAnchor, height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        yAnchor.constraint(equalTo: viewYAnchor, constant: yConstant).isActive = true
        xAnchor.constraint(equalTo: viewXAnchor, constant: xConstant).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addToViewWithKnownHeight(view: UIView, top: NSLayoutYAxisAnchor, topConstant: CGFloat, bottom: NSLayoutYAxisAnchor, bottomConstant: CGFloat, leading: NSLayoutXAxisAnchor, leadingConstant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: top, constant: topConstant).isActive = true
        bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant).isActive = true
        leadingAnchor.constraint(equalTo: leading, constant: leadingConstant).isActive = true
    }
    
    func addRelativeToView() { //require to be added to view hierarchy first
        
    }
    
    func animateViewWithSpringEffect(duration: TimeInterval, delay: TimeInterval, springSize: CGFloat) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn,    animations: {
            self.transform = CGAffineTransform(scaleX: springSize, y: springSize)
        }) { [weak self] (_) in
            UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self?.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
}

extension UILabel {
    func configure(font: UIFont, textColor: UIColor, alignment: NSTextAlignment) {
        self.font = font
        self.textColor = textColor
        self.textAlignment = alignment
    }
}

extension UIImageView {
    func configure(contentMode: ContentMode, borderWidth: CGFloat, borderColor: CGColor?) {
        self.clipsToBounds = true
        self.contentMode = contentMode
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}

extension UIButton {
    func configure(title: String, titleColor: UIColor, tag: Int, font: UIFont, background: UIColor?) {
        setTitleForAllStates(title)
        setTitleColorForAllStates(titleColor)
        self.tag = tag
        titleLabel?.font = font
        backgroundColor = background
    }
    
    func configure(image: UIImage, tintColor: UIColor, contentMode: ContentMode, tag: Int) {
        self.setImage(image, for: .normal) // if for all states then no image effect
        self.tintColor = tintColor
        self.contentMode = contentMode
        self.tag = tag
    }
}
