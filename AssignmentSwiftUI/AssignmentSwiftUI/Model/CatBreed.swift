//
//  CatBreed.swift
//  AssignmentSwiftUI
//
//  Created by Satish Rajpurohit on 19/12/24.
//

import Foundation

struct CatBreed: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let image: CatBreedImage?

    struct CatBreedImage: Codable {
        let url: String
    }
}
