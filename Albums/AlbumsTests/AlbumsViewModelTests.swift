//
//  AlbumsViewModelTests.swift
//  AlbumsTests
//
//  Created by Malleswari on 18/05/22.
//

import XCTest
import CoreData

@testable import Albums

struct MockAPIService: APIServiceProtocol {
    func getObjects<T>(from urlString: String) async throws -> T where T : Decodable {
        var albums = [Album]()
        
        albums.append(Album(userId: 1, id: 1, title: "Album1"))
        albums.append(Album(userId: 2, id: 2, title: "Album2"))
        albums.append(Album(userId: 2, id: 2, title: "Album3"))
        
        do {
            let data = try JSONEncoder().encode(albums)
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                return objects
            } catch {
                throw APIError.decodingError
            }
        } catch let e {
            print(e)
            throw APIError.invalidData
        }
    }
}

class AlbumsViewModelTests: XCTestCase {
    var viewModel = AlbumsViewModel()
    
    lazy var mockPersistantContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "Albums")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    override func setUpWithError() throws {
        viewModel.apiService = MockAPIService()
        viewModel.networkManager = NetworkManager()
        viewModel.dataManager = AlbumsDataManager(persistentContainer: mockPersistantContainer)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetAlbumsFromAPI() async {
        await viewModel.fetchAlbumsFromAPI()
        XCTAssertEqual(self.viewModel.albums.count, 3)
    }
    
    func testGetOfflineAlbums() async {
        await viewModel.fetchAlbumsFromAPI()
        viewModel.fetchOfflineAlbums()
        XCTAssertEqual(self.viewModel.albums.count, 3)
    }
    
    func testSortAlbums() async {
        await viewModel.fetchAlbumsFromAPI()
        do {
            var albums: [Album] = try await viewModel.apiService.getObjects(from: "")
            albums = albums.sorted { $0.title < $1.title }
            XCTAssertEqual(viewModel.albums, albums)
        } catch {
            XCTAssertFalse(false)
        }
    }

}
