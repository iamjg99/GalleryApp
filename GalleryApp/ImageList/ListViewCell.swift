//
//  ProductCell.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    func configure(with product: Product) {
           label.text = product.name
           priceLabel.text = "$\(product.price)"
        imageView.image = product.image
       }
}
