//
//  LocalStorage.swift
//  GalleryApp
//
//  Created by Jatin on 25/11/23.
//

import Foundation

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
}
