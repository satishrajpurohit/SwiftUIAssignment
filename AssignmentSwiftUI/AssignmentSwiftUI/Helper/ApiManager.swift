//
//  ApiManager.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import Foundation

class NetworkManager {
    
    // Fetches data from a given URL and calls the completion handler when done.
    // - Parameters:
    //   - url: The URL to fetch data from.
    //   - completion: A closure that is called with the fetched data or nil if an error occurs.
    func fetchData(from url: URL, completion: @escaping (Data?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}

class DataDecoder {
    
    // Decodes a given Data object to a specified type that conforms to the Codable protocol.
    // - Parameters:
    //   - data: The data to be decoded.
    //   - type: The type of the object to decode to (inferred by T).
    // - Returns: A decoded object of type T, or nil if decoding fails.
    func decode<T: Codable>(_ data: Data, to type: T.Type) -> T? {
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            print("Decoding error: \(error)")
            return nil
        }
    }
}

/// A struct to hold all the constants related to API endpoints.
struct APIConstants {
    static let catImagesURL = "https://api.thecatapi.com/v1/images/search?limit=5"
    static let catBreedsURL = "https://api.thecatapi.com/v1/breeds"
}
