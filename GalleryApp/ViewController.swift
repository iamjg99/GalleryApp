//
//  ViewController.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nextBtn: UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func pressNext(_ sender: Any) {
        if LocalStorage.shared.isUserIsLoggedIn {
            print("LOGGED IN")
            guard let ListController = UIStoryboard(name: "ImageListView", bundle: nil).instantiateViewController(withIdentifier: "ImageListViewController") as?  ImageListViewController else {fatalError()}
            navigationController?.pushViewController(ListController, animated: false)
        } else{
            print("NOT LOGGED IN")
            guard let loginController = UIStoryboard(name: "LoginView", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {fatalError()}
            navigationController?.pushViewController(loginController, animated: false)
        }
    }
}

