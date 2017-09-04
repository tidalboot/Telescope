//
//  Gallery.swift
//  Telescope
//
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

//Going for Gallery rather than something like "GalleryController" as I think the inheritance from UIViewController provides this information itself
class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    private let findingImages = "Finding your images! \n🕵️🕵️‍♀️"
    private let noImages = "Sorry, we couldn't find any images for you\n😭"
    private let whatAreYouLookingFor = "What are you looking for today?\n🦄"
    
    
    private var gallery: UICollectionView!
    private var records = [TelescopeRecord]()
    
    private var loadingLabel: UILabel!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let recordToUse = records[indexPath.row]
        
        let galleryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItem", for: indexPath) as! GalleryItem
        
        galleryItem.imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: galleryItem.frame.size.width,
            height: galleryItem.frame.size.height
            )
        )
        
        if let highQualityImageAvailable = recordToUse.Images.Original,
            let highQualityURL = URL(string: highQualityImageAvailable) {
                galleryItem.imageView.sd_setImage(with: highQualityURL, placeholderImage: nil)
        }
        
        galleryItem.titleLabel = UILabel(frame: CGRect(
            x: 10,
            y: galleryItem.frame.size.height * 0.7,
            width: galleryItem.frame.size.width,
            height: galleryItem.frame.size.height * 0.3
            )
        )
        galleryItem.titleLabel.text = "\(recordToUse.Title) by \(recordToUse.Author)\n\(recordToUse.DateTaken)\n\(recordToUse.ImageDimensions)"
        galleryItem.titleLabel.font = UIFont.systemFont(ofSize: 16, weight: UIFontWeightLight)
        galleryItem.titleLabel.textColor = .white
        galleryItem.titleLabel.numberOfLines = 3
        
        return galleryItem
    }
    
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        loadingLabel = UILabel(frame: CGRect(
            x: view.frame.size.width * 0.1,
            y: (view.frame.size.height * 0.4) - 125,
            width: view.frame.size.width * 0.8,
            height: 250
            )
        )
        loadingLabel.numberOfLines = 0
        loadingLabel.textColor = .darkGray
        loadingLabel.textAlignment = .center
        loadingLabel.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(loadingLabel)
        
        let searchBar = UISearchBar(frame: CGRect(
            x: 0,
            y: 20,
            width: view.frame.size.width,
            height: 50)
        )
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.size.width,
            height: view.frame.size.width * 0.65
        )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        let gallerySize = CGRect(
            x: 0,
            y: searchBar.frame.origin.y + searchBar.frame.size.height,
            width: view.frame.size.width,
            height: view.frame.size.height - (searchBar.frame.origin.y + searchBar.frame.size.height)
        )
        gallery = UICollectionView(frame: gallerySize, collectionViewLayout: layout)
        gallery.contentInset = .zero
        gallery.delegate = self
        gallery.dataSource = self
        gallery.register(GalleryItem.self, forCellWithReuseIdentifier: "galleryItem")
        gallery.backgroundColor = .white
        gallery.alpha = 0
        gallery.layoutMargins = .zero
        
        view.addSubview(gallery)
        
        searchBar.becomeFirstResponder()
    }

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        if let searchBarText = searchBar.text {
            getRecords(withSearchQuery: searchBarText)
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        UIView.animate(withDuration: 0.3, animations: {
            self.gallery.alpha = 0
        }) { (_) in
            self.loadingLabel.transitionText(withString: self.whatAreYouLookingFor)
        }
        
        return true
    }
    
    private func showNewImages() {
        self.loadingLabel.text = ""
        self.gallery.reloadData()
        self.gallery.setContentOffset(.zero, animated: false)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.gallery.alpha = 1
        })
    }
    
    private func getRecords(withSearchQuery searchQuery: String = "") {
        
        loadingLabel.transitionText(withString: findingImages) {
            UIView.animate(withDuration: 0.3, animations: {
                self.gallery.alpha = 0
            }) { (_) in
                Lense().requestRecords(withCompletionHandler: { (recordsReturned) in
                    DispatchQueue.main.async {
                        if (recordsReturned.isEmpty) {
                            self.loadingLabel.transitionText(withString: self.noImages)
                            return
                        } else {
                            self.records = recordsReturned
                            self.showNewImages()
                        }
                    }
                }, andSearchQuery: searchQuery)
            }
        }
    }
    
}
