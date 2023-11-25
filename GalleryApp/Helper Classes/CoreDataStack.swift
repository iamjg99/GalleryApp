//
//  CoreDataStack.swift
//  GalleryApp
//
//  Created by Jatin on 26/11/23.
//

import Foundation
import CoreData

class CoreDataStack {
    private init() {
        
    }
    
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Data Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
            }
        }
    }
}
