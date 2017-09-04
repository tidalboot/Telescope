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

class GalleryItem: UICollectionViewCell {
    private var _imageView: UIImageView!
    private var _titleLabel: UILabel!
    
    
    var titleLabel: UILabel {
        get {
            return _titleLabel
        } set {
            _titleLabel = _titleLabel ?? newValue
            contentView.addSubview(_titleLabel)
        }
    }
    
    var imageView: UIImageView {
        get {
            return _imageView
        } set {
            _imageView = _imageView ?? newValue
            _imageView.contentMode = .scaleAspectFill
            _imageView.clipsToBounds = true
            
            let backgroundGradient = CAGradientLayer()
            backgroundGradient.frame = _imageView.frame
            backgroundGradient.locations = [0.0, 0.75]
            let fadedLightGray = UIColor.init(colorLiteralRed: 177.0 / 255.0, green: 177.0 / 255.0, blue: 177.0 / 255.0, alpha: 0.05)
            let fadedBlack = UIColor.init(colorLiteralRed: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.75)
            backgroundGradient.colors = [fadedLightGray.cgColor, fadedBlack.cgColor]
            _imageView.layer.insertSublayer(backgroundGradient, at: 1)
            
            contentView.addSubview(_imageView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        _imageView?.removeFromSuperview()
        _titleLabel.removeFromSuperview()
        _titleLabel = nil
        _imageView = nil
    }
}

//Going for Gallery rather than something like "GalleryController" as I think the inheritance from UIViewController provides this information itself
class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var gallery: UICollectionView!
    private var records = [TelescopeRecord]()
    
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
        
        if let imageURL = URL(string: recordToUse.Images.Medium) {
            galleryItem.imageView.sd_setImage(with: imageURL, placeholderImage: nil)
        }
        
        galleryItem.titleLabel = UILabel(frame: CGRect(
            x: 10,
            y: galleryItem.frame.size.height * 0.7,
            width: galleryItem.frame.size.width - 20,
            height: galleryItem.frame.size.height * 0.3
            )
        )
        galleryItem.titleLabel.text = recordToUse.Title
        galleryItem.titleLabel.textColor = .white
        galleryItem.titleLabel.numberOfLines = 2
        
        return galleryItem
    }
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.size.width,
            height: view.frame.size.width * 0.65
        )
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        gallery = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        gallery.contentInset = .zero
        gallery.delegate = self
        gallery.dataSource = self
        gallery.register(GalleryItem.self, forCellWithReuseIdentifier: "galleryItem")
        gallery.backgroundColor = .white
        
        view.addSubview(gallery)
        
        getRecords()
    }
    
    private func getRecords() {
        Lense().requestRecords { (recordsReturned) in
            DispatchQueue.main.async {
                self.records = recordsReturned
                self.gallery.reloadData()
            }
        }
    }
    
}
