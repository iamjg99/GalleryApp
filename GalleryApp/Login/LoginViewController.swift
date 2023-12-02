//
//  LoginViewController.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit
import GoogleSignIn
import Alamofire

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
    
    func downloadImageWithAlamofire(url: URL, completion: @escaping (Data?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                completion(data)
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            }
        }
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
                guard let ListController = UIStoryboard(name: "ImageListView", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as?  ProductViewController else {fatalError()}
                self?.navigationController?.pushViewController(ListController, animated: false)
                LocalStorage.shared.setUserIsLoggedIn(true)
            }
            
            guard let googleUser = authentication?.user,
                  let firstName = googleUser.profile?.givenName,
                  let lastName = googleUser.profile?.familyName,
                  let profileImage = googleUser.profile?.imageURL(withDimension: 320)
            else{
                print("Error: ID token missing!");
                return;
            }
            LocalStorage.shared.setFirstname(firstName)
            LocalStorage.shared.setLastname(lastName)
            self?.downloadImageWithAlamofire(url: profileImage) { data in
                guard let imageData = data else { return }
                
                let fileName = "downloadedImage.jpg"
                LocalStorage.shared.saveImageDataToDocumentsDirectory(data: imageData, fileName: fileName)
                
                // Save the file path to UserDefaults
                UserDefaults.standard.set(fileName, forKey: "savedImageFileName")
            }
        }
    }
}
