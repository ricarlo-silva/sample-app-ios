//
//  ListResponse.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 22/12/21.
//

import Foundation

// MARK: - ListsResponse
struct ListResponse: Codable {
    let next: String
    let href: String
    let offset: Int
//    let previous: JSONNull?
    let limit: Int
    let items: [Playlist]
    let total: Int
}

// MARK: - Playlist
struct Playlist: Codable, Identifiable {
    let id: String
    let description: String
    let isPublic: Bool
//    let primaryColor: JSONNull?
    let snapshotID: String
    let href: String
    let owner: Owner
    let tracks: Tracks
    let uri: String
    let type: ItemType
    let collaborative: Bool
    let images: [ImageResponse]
    let externalUrls: ExternalUrls
    let name: String

    enum CodingKeys: String, CodingKey {
        case description = "description"
        case id
        case isPublic = "public"
//        case primaryColor = "primary_color"
        case snapshotID = "snapshot_id"
        case href, owner, tracks, uri, type, collaborative, images
        case externalUrls = "external_urls"
        case name
    }
}

// MARK: - Image
struct ImageResponse: Codable {
    let url: String
    let width, height: Int
}

// MARK: - Owner
struct Owner: Codable {
    let id, displayName: String
    let externalUrls: ExternalUrls
    let href: String
    let type: OwnerType
    let uri: String

    enum CodingKeys: String, CodingKey {
        case id
        case displayName = "display_name"
        case externalUrls = "external_urls"
        case href, type, uri
    }
}

enum OwnerType: String, Codable {
    case user = "user"
}

// MARK: - Tracks
struct Tracks: Codable {
    let total: Int
    let href: String
}

enum ItemType: String, Codable {
    case playlist = "playlist"
}
