//
//  LoginViewController.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit
import GoogleSignIn

class LoginViewController: UIViewController {
    
    @IBOutlet weak var googleBtn: UIButton?
    var googleSignIn = GIDSignIn.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func loginWithGoogle(_ sender: Any) {
        googleLogin()
    }
    
    
    func googleLogin() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewContoller = window.rootViewController
        else{
            print("There is no root view controller");
            return;
        }
        
        googleSignIn.signIn(withPresenting: rootViewContoller){
            [weak self] authentication, error in
            if let error = error {
                print("Google Sign-In failed: \(error.localizedDescription)")
                return;
            } else {
                guard let ListController = UIStoryboard(name: "ImageListView", bundle: nil).instantiateViewController(withIdentifier: "ImageListViewController") as?  ImageListViewController else {fatalError()}
                self?.navigationController?.pushViewController(ListController, animated: false)
                LocalStorage.shared.setUserIsLoggedIn(true)
            }
            
            guard let googleUser = authentication?.user,
                  let userId = googleUser.userID,
                  let idToken = googleUser.idToken
            else{
                print("Error: ID token missing!");
                return;
            }
        }
    }
}

