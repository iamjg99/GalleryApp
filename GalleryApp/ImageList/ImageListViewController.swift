//
//  ProductViewController.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class ProductViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var profileBtn: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var imageUrls: [String] = []
    var coreDataImages: [NSManagedObject] = []
    var products: [Product] = [
        Product(id: "1", name: "Apparel 1", price: 29.99, image: UIImage(systemName: "folder.fill") ?? UIImage()),
        Product(id: "2", name: "Apparel 2", price: 39.99, image: UIImage(systemName: "folder") ?? UIImage()),
            // Add more products as needed
        ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func openProfile(_ sender: Any) {
        guard let profileController = UIStoryboard(name: "ProfileView", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {fatalError()}
        navigationController?.pushViewController(profileController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
           return products.count
       }

       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
               fatalError("Cell not configured properly")
           }

           let product = products[indexPath.item]
           cell.configure(with: product)
           cell.isUserInteractionEnabled = true
           return cell
       }

       // MARK: - UICollectionViewDelegate

       func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           let selectedProduct = products[indexPath.item]
           print("hi", indexPath.row, indexPath.section)
           showProductDetails(for: selectedProduct)
       }

    func showProductDetails(for product: Product) {
            let storyboard = UIStoryboard(name: "CartViewCell", bundle: nil) // Change "Main" to your storyboard name if different
            if let productDetailsVC = storyboard.instantiateViewController(withIdentifier: "CartViewController") as? CartViewController {
                productDetailsVC.product = product
                navigationController?.pushViewController(productDetailsVC, animated: true)
            }
        }
}



struct Product {
    var id: String
    var name: String
    var price: Double
    var image: UIImage
    // Add more properties as needed
}

class ShoppingCart {
    static let shared = ShoppingCart()

    private init() {}

    var products: [CartItem] = []

    func addProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.product.id == product.id }) {
            // Product already exists in the cart, update quantity
            products[index].quantity += 1
        } else {
            // Product doesn't exist in the cart, add it
            products.append(CartItem(product: product, quantity: 1))
        }
    }

    func removeProduct(_ product: Product) {
        if let index = products.firstIndex(where: { $0.product.id == product.id }) {
            // Decrement quantity or remove if quantity is 1
            if products[index].quantity > 1 {
                products[index].quantity -= 1
            } else {
                products.remove(at: index)
            }
        }
    }
}

struct CartItem {
    var product: Product
    var quantity: Int
}
