//
//  UserSession.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 29/11/21.
//

import Foundation

struct UserSession: Codable {
    
    let accessToken: String
    let expiresIn: Int
    var refreshToken: String?
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
}
