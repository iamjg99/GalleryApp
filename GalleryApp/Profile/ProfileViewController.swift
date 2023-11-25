//
//  ProfileViewController.swift
//  GalleryApp
//
//  Created by Jatin on 26/11/23.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstName.text = LocalStorage.shared.getFirstname
        lastName.text = LocalStorage.shared.getLastname
        profileImage.circularView()
        
        if let savedFileName = UserDefaults.standard.string(forKey: "savedImageFileName"),
           let loadedImage = LocalStorage.shared.loadImageFromDocumentsDirectory(fileName: savedFileName) {
            profileImage.image = loadedImage
            }
    }
    
    
    @IBAction func tapToLogout(_ sender: Any) {
        LocalStorage.shared.setFirstname("")
        LocalStorage.shared.setLastname("")
        LocalStorage.shared.setUserIsLoggedIn(false)
        LocalStorage.shared.saveImageDataToDocumentsDirectory(data: Data(), fileName: "")
        guard let loginController = UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {fatalError()}
        navigationController?.pushViewController(loginController, animated: false)
    }
}
