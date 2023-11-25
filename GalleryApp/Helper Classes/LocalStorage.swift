//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import UIKit

struct LocalStorage {
    
    private init() {}
    
    // MARK: - Properties
    static var shared = LocalStorage()
    
    private var userDefaults: UserDefaults {
        return UserDefaults.standard
    }
    
    var isUserIsLoggedIn: Bool {
        return userDefaults.bool(forKey: "loggedIn")
    }
    
    func setUserIsLoggedIn(_ isLoggedIn: Bool) {
        userDefaults.setValue(isLoggedIn, forKey: "loggedIn")
    }

    var getFirstname: String? {
        return userDefaults.string(forKey: "firstName")
    }
    
    var getLastname: String? {
        return userDefaults.string(forKey: "lastName")
    }
    
    func setFirstname(_ firstName: String) {
        userDefaults.setValue(firstName, forKey: "firstName")
    }
    
    func setLastname(_ lastName: String) {
        userDefaults.setValue(lastName, forKey: "lastName")
    }

    func saveImageDataToDocumentsDirectory(data: Data, fileName: String) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
    
    func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        return UIImage(contentsOfFile: fileURL.path)
    }
}
