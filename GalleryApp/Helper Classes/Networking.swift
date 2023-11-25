//
//  Networking.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import Foundation
import UIKit
import Alamofire

class YourViewController: UIViewController {

    func fetchRandomImage() {
        let accessKey = "XJVRNjaRgAwWk2HZR-wQ_qF7hFo-r4vSEXjmFx7OqvM"
        let url = "https://api.unsplash.com/photos/random"

        AF.request(url, method: .get, headers: ["Authorization": "Client-ID \(accessKey)"])
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    // Handle the success response here
                    print(value)
                case .failure(let error):
                    // Handle the error here
                    print(error)
                }
            }
    }

    // ...
}
