//
//  CoreDataManagerService.swift
//  Albums
//
//  Created by Malleswari on 18/05/22.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataManagerService {
    var persistentContainer: NSPersistentContainer! { get set }
    
    func getMainContext() -> NSManagedObjectContext?
    func getBackgroundContext() -> NSManagedObjectContext?
    
    init()
    init(container: NSPersistentContainer?)
}

extension CoreDataManagerService {
    init(container: NSPersistentContainer?) {        
        self.init()
        self.persistentContainer = container
    }
    
    func getMainContext() -> NSManagedObjectContext? {
        return self.persistentContainer.viewContext
    }
    
    func getBackgroundContext() -> NSManagedObjectContext? {
        return self.persistentContainer?.newBackgroundContext()
    }
}
