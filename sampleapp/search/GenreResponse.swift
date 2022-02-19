//
//  GenreResponse.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 05/12/21.
//

import Foundation

// MARK: - GenreResponse
struct GenreResponse: Codable {
    let genres: [String]
}

struct Genre: Identifiable {
    let name: String
    let id = UUID()
}
