//
//  StorageService.swift
//  Albums
//
//  Created by Malleswari on 18/05/22.
//

import Foundation
import CoreData
import UIKit

struct AlbumsDataManager: CoreDataManagerService {
    
    var persistentContainer: NSPersistentContainer!
    
    static let shared = AlbumsDataManager(container:
                                            (UIApplication.shared.delegate as! AppDelegate).persistentContainer)
    
    func save(albums: [Album])  {
        for album in albums {
            save(album: album)
        }
    }
    
    func save(album: Album) {
        guard let context = getBackgroundContext() else { return }
        
        let entityDesc = NSEntityDescription.entity(forEntityName: "Album", in: context)
        guard let entity = entityDesc else { return }
        
        let albumObj = NSManagedObject(entity: entity, insertInto: context)
        albumObj.setValue(album.userId, forKeyPath: "userId")
        albumObj.setValue(album.id, forKeyPath: "id")
        albumObj.setValue(album.title, forKeyPath: "title")
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Unable not save Album \(error), \(error.userInfo)")
        }
    }
    
    func getAlbums() -> [Album]? {
        var albums: [Album]?
        guard let context = getBackgroundContext() else { return nil }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        
        do {
            let results = try context.fetch(fetchRequest) as! [NSManagedObject]
            albums = [Album]()
            for object in results {
                if let userId = object.value(forKey: "userId") as? Int,
                   let id = object.value(forKey: "id") as? Int,
                   let title = object.value(forKey: "title") as? String  {
                    let album = Album(userId: userId,
                                      id: id,
                                      title: title)
                    albums?.append(album)
                } else {
                    print("Error retrieving the album")
                }
            }
        } catch let error as NSError {
            print("Retrieving user failed. \(error): \(error.userInfo)")
            return nil
        }
        return albums
    }
    
    func deleteAlbums() {
        guard let context = getBackgroundContext() else { return }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Album")
        let deleteAllRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteAllRequest)
        } catch let error as NSError {
            print("Unable to delete albums \(error), \(error.userInfo)")
        }
    }
}
