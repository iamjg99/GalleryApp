//
//  UIImageView+Ext.swift
//  GalleryApp
//
//  Created by Jatin on 26/11/23.
//

import UIKit

extension UIImageView {
    
    func circularView() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2.0
        layer.masksToBounds = true
    }
}
