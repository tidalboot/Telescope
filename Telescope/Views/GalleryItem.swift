
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.

import Foundation
import UIKit

class GalleryItem: UICollectionViewCell {
    // MARK: - Local Properties 💻
    private var _imageView: UIImageView!
    private var _titleLabel: UILabel!
    
    
    // MARK: - Global Properties 🌎
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
            
            //Here we add a gradient overlay effect to the image so that the title will always be readable, irrelevant of the image colour
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
    
    // MARK: - UICollectionViewCell Methods 👑
    override func prepareForReuse() {
        super.prepareForReuse()
        _imageView?.removeFromSuperview()
        _titleLabel.removeFromSuperview()
        _titleLabel = nil
        _imageView = nil
    }
}
