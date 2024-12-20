//
//  AssignmentViewModel.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import Foundation

// MARK: - AssignmentViewModel
/// The view model for managing and fetching cat-related data such as images and breeds.
class AssignmentViewModel: ObservableObject {
    @Published var catImages: [CatImage] = []
    @Published var catBreeds: [CatBreed] = []
    
    private let networkManager = NetworkManager()
    private let dataDecoder = DataDecoder()
    
    // MARK: - Fetch Cat Images
    /// Fetches cat images from the API and updates the `catImages` property
    func fetchCatImages() {
        guard let url = URL(string: APIConstants.catImagesURL) else { return }
        networkManager.fetchData(from: url) { data in
            if let data = data {
                if let decodedImages: [CatImage] = self.dataDecoder.decode(data, to: [CatImage].self) {
                    DispatchQueue.main.async {
                        self.catImages = decodedImages
                    }
                }
            }
        }
    }
    
    // MARK: - Fetch Cat Breeds
    /// Fetches cat breeds from the API and updates the `catBreeds` property
    func fetchCatBreeds() {
        guard let url = URL(string: APIConstants.catBreedsURL) else { return }
        networkManager.fetchData(from: url) { data in
            if let data = data {
                if let decodedImages: [CatBreed] = self.dataDecoder.decode(data, to: [CatBreed].self) {
                    DispatchQueue.main.async {
                        self.catBreeds = decodedImages
                    }
                }
            }
        }
    }
    
}
