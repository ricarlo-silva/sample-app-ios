//
//  Search.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 03/12/21.
//

import Foundation

// MARK: - UserProfile
struct SearchResponse: Codable {
    let tracks,
        artists,
        albums,
        playlists,
        shows,
        episodes: ListResponse?
}

//// MARK: - Albums
//struct Albums: Codable {
//    let href: String
//    let items: [Item]
//    let limit: Int
//    let next: String?
//    let offset: Int
//    let previous: String?
//    let total: Int
//}
//
//// MARK: - Item
//struct Item: Codable {
//}

