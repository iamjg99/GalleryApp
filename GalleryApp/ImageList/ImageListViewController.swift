//
//  ImageListViewController.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit
import Alamofire
import AlamofireImage
import CoreData

class ImageListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var imageUrls: [String] = []
    var coreDataImages: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if InternetConnectivity.isConnectedToInternet() {
            fetchRandomImages()
        } else {
            fetchImagesFromCoreData()
        }
        coreDataImages = fetchImagesFromCoreData()
    }
    
    @IBAction func logOut(_ sender: Any) {
        LocalStorage.shared.setUserIsLoggedIn(false)
        guard let loginController = UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {fatalError()}
        navigationController?.pushViewController(loginController, animated: false)
    }
    
    func fetchRandomImages() {
        let accessKey = "XJVRNjaRgAwWk2HZR-wQ_qF7hFo-r4vSEXjmFx7OqvM"
        let url = "https://api.unsplash.com/photos/random?count=25"
        
        AF.request(url, method: .get, headers: ["Authorization": "Client-ID \(accessKey)"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let jsonArray = value as? [[String: Any]] {
                        self.imageUrls = jsonArray.compactMap { $0["urls"] as? [String: Any] } .compactMap { $0["regular"] as? String }
                        for imageData in jsonArray {
                            if let imageURLString = imageData["urls"] as? [String: Any],
                               let imageURL = imageURLString["regular"] as? String {
                                self.saveImageToCoreData(imageURL: imageURL)
                            }
                        }
                        
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    // Handle the error here
                    print(error)
                }
            }
    }
    
    func saveImageToCoreData(imageURL: String) {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }

            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Images", in: managedContext)!
            let imageObject = NSManagedObject(entity: entity, insertInto: managedContext)

            AF.request(imageURL).responseImage { response in
                if case .success(let image) = response.result {
                    if let imageData = image.jpegData(compressionQuality: 1.0) {
                        imageObject.setValue(imageData, forKey: "imageData")

                        do {
                            try managedContext.save()
                        } catch let error as NSError {
                            print("Could not save. \(error), \(error.userInfo)")
                        }
                    }
                }
            }
        }
    

    func fetchImagesFromCoreData() -> [NSManagedObject] {
        let managedContext = CoreDataStack.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Images")

            do {
                let images = try managedContext.fetch(fetchRequest)
                self.coreDataImages = try managedContext.fetch(fetchRequest)
                return images
            } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
                return []
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if InternetConnectivity.isConnectedToInternet() {
            return imageUrls.count
        } else {
            return coreDataImages.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListViewCell", for: indexPath) as! ListViewCell
        cell.loader.isHidden = false
        cell.loader.startAnimating()
        
        if InternetConnectivity.isConnectedToInternet() {
            if let imageURL = URL(string: imageUrls[indexPath.item]) {
                cell.imageView.af.setImage(withURL: imageURL, placeholderImage: UIImage(named: "placeholder"), completion:  { _ in
                    cell.loader.stopAnimating()
                    cell.loader.isHidden = true
                })
            }
        } else {
            if let imageData = coreDataImages[indexPath.item].value(forKey: "imageData") as? Data {
                if let image = UIImage(data: imageData) {
                    cell.loader.stopAnimating()
                    cell.loader.isHidden = true
                    cell.imageView.image = image
                }
            }
        }
        return cell
    }
}


