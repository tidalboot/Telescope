//
//  Gallery.swift
//  Telescope
//
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import Foundation
import UIKit

class GalleryItem: UICollectionViewCell {
    
}

//Going for Gallery rather than something like "GalleryController" as I think the inheritance from UIViewController provides this information itself
class Gallery: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var gallery: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let galleryItem = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryItem", for: indexPath) as! GalleryItem
        
        let itemImage = UIImageView(frame: CGRect(
            x: 0,
            y: 0,
            width: galleryItem.frame.size.width,
            height: galleryItem.frame.size.height
            )
        )
        itemImage.backgroundColor = .blue
        galleryItem.addSubview(itemImage)
        
        let backgroundGradient = CAGradientLayer()
        backgroundGradient.frame = itemImage.frame
        backgroundGradient.locations = [0.0, 0.7]
        let fadedLightGray = UIColor.init(colorLiteralRed: 177.0 / 255.0, green: 177.0 / 255.0, blue: 177.0 / 255.0, alpha: 0.25)
        let fadedBlack = UIColor.init(colorLiteralRed: 0.0 / 255.0, green: 0.0 / 255.0, blue: 0.0 / 255.0, alpha: 0.75)
        backgroundGradient.colors = [fadedLightGray.cgColor, fadedBlack.cgColor]
        itemImage.layer.insertSublayer(backgroundGradient, at: 1)
        
        return galleryItem
    }
    
    override func viewDidLoad() {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(
            width: view.frame.size.width * 0.5,
            height: view.frame.size.width * 0.5
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
    }
    
}
