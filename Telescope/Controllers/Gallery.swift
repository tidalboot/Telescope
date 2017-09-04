
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.

import Foundation
import UIKit
import SDWebImage

//Going for Gallery rather than something like "GalleryController" as I think the inheritance from UIViewController provides this information itself
class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate {
    
    // MARK: - Constant Strings 🎻
    // If the app were to grow there could be an argument to move these out to a seperate class to make localisation easier; For now they're fine
    private let findingImages = "Finding your images! \n🕵️🕵️‍♀️"
    private let noImages = "Sorry, we couldn't find any images for you\n😭"
    private let whatAreYouLookingFor = "What are you looking for today?\n🦄"
    
    // MARK: - Local Properties 💻
    private var gallery: UICollectionView!
    private var helperLabel: UILabel!
    private var records = [TelescopeRecord]()
    
    // MARK: - Collection View Delegate Methods 📦
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let recordToUse = records[indexPath.row]
        
        let galleryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItem", for: indexPath) as! GalleryItem
        
        //GalleryItem Image
        galleryItem.imageView = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: galleryItem.frame.size.width,
            height: galleryItem.frame.size.height
            )
        )
        
        if let highQualityImageAvailable = recordToUse.Images.Original,
            let highQualityURL = URL(string: highQualityImageAvailable) {
            //IMPORTANT:
            //Here we make use of SDWebImage to both download our image in the background, but most importantly cache the image once downloaded
                galleryItem.imageView.sd_setImage(with: highQualityURL, placeholderImage: nil)
        }
        //-----
        
        //GalleryItem Label
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
        //-----
        
        
        return galleryItem
    }
    
    // MARK: - UIView Delegate Methods 👑
    //Whilst we could move a lot of this out to builder methods or elsewhere since it's only being used it feels like a waste; Better to keep it here for now
    override func viewDidLoad() {
        
        view.backgroundColor = .white
        
        //Helper Label
        helperLabel = UILabel(frame: CGRect(
            x: view.frame.size.width * 0.1,
            y: (view.frame.size.height * 0.4) - 125,
            width: view.frame.size.width * 0.8,
            height: 250
            )
        )
        helperLabel.numberOfLines = 0
        helperLabel.textColor = .darkGray
        helperLabel.textAlignment = .center
        helperLabel.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(helperLabel)
        //-----
        
        
        //Search Bar
        let searchBar = UISearchBar(frame: CGRect(
            x: 0,
            y: 20,
            width: view.frame.size.width,
            height: 50)
        )
        searchBar.delegate = self
        view.addSubview(searchBar)
        //-----
        
        
        //Collection View Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.size.width,
            height: view.frame.size.width * 0.65
        )
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 0
        //-----
        
        
        //Gallery Collection View
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
        //-----
        
        
        view.addSubview(gallery)
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Search Bar Delegate Methods 🔎
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
            self.helperLabel.transitionText(withString: self.whatAreYouLookingFor)
        }
        
        return true
    }
    
    // MARK: - Custom Methods 🔮
    private func showNewImages() {
        helperLabel.text = ""
        gallery.reloadData()
        gallery.setContentOffset(.zero, animated: false)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.gallery.alpha = 1
        })
    }
    
    private func getRecords(withSearchQuery searchQuery: String = "") {
        
        helperLabel.transitionText(withString: findingImages) {
            UIView.animate(withDuration: 0.3, animations: {
                self.gallery.alpha = 0
            }) { (_) in
                Lense().requestRecords(withCompletionHandler: { (recordsReturned) in
                    DispatchQueue.main.async {
                        if (recordsReturned.isEmpty) {
                            self.helperLabel.transitionText(withString: self.noImages)
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
