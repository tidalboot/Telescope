//
//  TransitionText.swift
//  Telescope
//
//  Created by Nick Jones on 04/09/2017.
//  Copyright © 2017 NickJones. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    func transitionText(withString string: String, andCompletionHandler completion: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (_) in
            self.text = string
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 1
            }, completion: { (_) in
                if (completion != nil) {
                    completion!()
                }
            })
        }
    }
}
