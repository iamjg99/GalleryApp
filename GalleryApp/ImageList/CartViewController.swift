//
//  CartViewController.swift
//  GalleryApp
//
//  Created by Jatin on 02/12/23.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    
    var product: Product!
    var quantity: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idLabel.text = "ID: \(product.id)"
        nameLabel.text = "Name: \(product.name)"
        priceLabel.text = "Price: $\(product.price)"
        updateQuantityLabel()
        
        // Customize the UI as needed
    }
    
    func updateQuantityLabel() {
        quantityLabel.text = "Quantity: \(quantity)"
    }
    
    @IBAction func plusButtonTapped(_ sender: UIButton) {
        quantity += 1
        updateQuantityLabel()
    }
    
    @IBAction func minusButtonTapped(_ sender: UIButton) {
        if quantity > 1 {
            quantity -= 1
            updateQuantityLabel()
        }
    }
}
