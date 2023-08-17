//
//  dataModel.swift
//  NewBrightonMurals
//
//  Created by Joseph Dobos on 01/12/2022.
//

import Foundation
//sets the structure of the JSON data
// MARK: - NewbrightonMural
struct NewbrightonMural: Decodable {
    let id: String
    let title: String?
    let artist: String?
    let info: String?
    let thumbnail: URL?
    let lat: String?
    let lon: String?
    let enabled: String
    let lastModified: String
    let images: [Image]
}

// MARK: - Image
struct Image: Decodable {
    let id, filename: String
}

// MARK: - BrightonMurals
struct BrightonMurals: Decodable {
    let newbrighton_murals: [NewbrightonMural]
}
