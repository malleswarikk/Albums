//
//  NetworkManager.swift
//  Albums
//
//  Created by Malleswari on 17/05/22.
//

import UIKit

protocol APIServiceProtocol {
    func getObjects<T: Decodable>(from urlString: String) async throws -> [T]
}

enum APIError: Error {
    case invalidURL
    case invalidReponseStatus
    case invalidData
    case dataTaskError
    case decodingError
    case unknownError
}


class APIService: APIServiceProtocol {
    static let shared = APIService()
    
    func getObjects<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw APIError.invalidReponseStatus
            }
            do {
                let objects = try JSONDecoder().decode(T.self, from: data)
                return objects
            } catch {
                throw APIError.decodingError
            }
        } catch {
            throw APIError.dataTaskError
        }        
    }
}
