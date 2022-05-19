//
//  AlbumsViewModel.swift
//  Albums
//
//  Created by Malleswari on 17/05/22.
//

import UIKit

class AlbumsViewModel: NSObject {
    let albumsURL = "https://jsonplaceholder.typicode.com/albums"
    
    var apiService: APIServiceProtocol = APIService.shared
    var networkManager =  NetworkManager.shared
    var dataManager = AlbumsDataManager.shared
    
    var albums: [Album] = [Album]()
    
    func getAlbums(completion:@escaping ()->()) {
        NetworkManager.isReachable { _ in
            Task {
                await self.fetchAlbumsFromAPI()
                completion()
            }
        }
        
        NetworkManager.isUnreachable { _ in
            self.fetchOfflineAlbums()
            completion()
        }
    }
    
    func fetchAlbumsFromAPI() async {
        do {
            albums = try await apiService.getObjects(from: albumsURL)
            sortAlbums()
            saveAlbumsIntoLocal()
        } catch {
            print("Unable to get albums")
        }
    }
    
    func fetchOfflineAlbums() {
        if let offlineAlbums = dataManager.getAlbums() {
            albums = offlineAlbums
            sortAlbums()
        }
    }
    
    private func sortAlbums() {
        albums = albums.sorted { $0.title < $1.title }
    }
    
    private func saveAlbumsIntoLocal() {
        dataManager.deleteAlbums()
        dataManager.save(albums: albums)
    }
}
