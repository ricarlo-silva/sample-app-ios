//
//  AuthViewModel.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 29/11/21.
//

import Foundation
import CoreNetwork

class AuthViewModel: ObservableObject {
    
    @Published private(set) var user: UserSession? = nil
    
    private let apiClient: NetworkClientProtocol
    private let sessionLocal: SessionLocalProtocol
    
    init(
        apiClient: NetworkClientProtocol = NetworkClient.shared,
        sessionLocal: SessionLocalProtocol = SessionLocal()
    ) {
        self.apiClient = apiClient
        self.sessionLocal = sessionLocal
    }
    
    private let redirect_uri = "https://iosacademy.io"
    
    var url: URL? {
        let scope = "user-read-private"
        let string = "https://accounts.spotify.com/authorize?response_type=code&client_id=\(sessionLocal.clientID)&scope=\(scope)&redirect_uri=\(redirect_uri)&show_dialog=true"
        
        return URL(string: string)
    }
    
    func fatchToken(_ code: String) {
        
        Task {
            let basicToken = "\(sessionLocal.clientID):\(sessionLocal.secretID)".data(using: .utf8)
            
            guard let base64 = basicToken?.base64EncodedString() else {
                print("failure to get base64")
                return
            }
            
            let request = Request(
                path: "https://accounts.spotify.com/api/token",
                httpMethod: .POST,
                headers: [
                    "Content-Type" : "application/x-www-form-urlencoded",
                    "Authorization" : "Basic \(base64)"
                ],
                httpBody: TokenRequest(
                    grant_type: "authorization_code",
                    code: code,
                    redirect_uri: redirect_uri
                ).dict
            )
            
            let result = await apiClient.call(request: request, type: UserSession.self)
            
            switch result {
            case .success(let user):
                self.user = user
                sessionLocal.saveUser(user: user)
//                fatch()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
//    func fatch() {
//
//        Task {
//
//            let request = Request(
//                path: "https://api.spotify.com/v1/artists/0TnOYISbd1XYRBk9myaseg",
//                httpMethod: .GET
//            )
//
//            let result = await apiClient.call(request: request, type: Artist.self)
//
//            switch result {
//            case .success(let user):
//                print(user)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
    
//    @MainActor
//    func setDate() {
//    }
}


struct Artist: Codable {
    let name: String
    let popularity: Int
    let type, uri: String
}

struct TokenRequest: Codable {
    
    let grant_type: String
    let code: String
    let redirect_uri: String
    
    enum CodingKeys: String, CodingKey {
        
        case grant_type = "grant_type"
        case code = "code"
        case redirect_uri = "redirect_uri"
    }
}

struct RefreshTokenRequest: Codable {
    
    let grant_type: String
    let refresh_token: String
    
    enum CodingKeys: String, CodingKey {
        
        case grant_type = "grant_type"
        case refresh_token = "refresh_token"
    }
}


class TokenInterceptor : InterceptorProtocol {
    
    private let sessionLocal: SessionLocalProtocol
    
    init(sessionLocal: SessionLocalProtocol = SessionLocal()) {
        self.sessionLocal = sessionLocal
    }
    
    func intercept(request: URLRequest) async -> Result<URLRequest, Error> {
        var _request = request
        if let accessToken = sessionLocal.getUser()?.accessToken {
            _request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        return .success(_request)
    }
}

class AuthenticatorInterceptor : InterceptorProtocol {
    
    private let sessionLocal: SessionLocalProtocol
    private let apiClient: NetworkClient
    
    init(
        sessionLocal: SessionLocalProtocol = SessionLocal(),
        apiClient: NetworkClient = NetworkClient.shared
    ) {
        self.sessionLocal = sessionLocal
        self.apiClient = apiClient
    }
    
    func intercept(request: URLRequest) async -> Result<URLRequest, Error> {
        
        
        let basicToken = "\(sessionLocal.clientID):\(sessionLocal.secretID)".data(using: .utf8)
        
        guard let base64 = basicToken?.base64EncodedString() else {
            return .failure(HttpException.Unauthorized)
        }
        
        let oldRefreshToken = sessionLocal.getUser()?.refreshToken ?? ""
        let _request = Request(
            path: "https://accounts.spotify.com/api/token",
            httpMethod: .POST,
            headers: [
                "Content-Type" : "application/x-www-form-urlencoded",
                "Authorization" : "Basic \(base64)"
            ],
            httpBody: RefreshTokenRequest(
                grant_type: "refresh_token",
                refresh_token: oldRefreshToken
            ).dict
        )
        
        sessionLocal.saveUser(user: nil)
        
        let result = await apiClient.call(request: _request, type: UserSession.self)
        
        switch result {
        case .success(var user):
            if(user.refreshToken == nil) {
                user.refreshToken = oldRefreshToken
            }
            sessionLocal.saveUser(user: user)
            var _request = request
            _request.setValue("Bearer \(user.accessToken)", forHTTPHeaderField: "Authorization")
            return .success(_request)
        case .failure(let error):
            return .failure(error)
        }
    }
}
