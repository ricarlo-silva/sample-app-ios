//
//  SessionLocal.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 30/11/21.
//

import Foundation

protocol SessionLocalProtocol {
    
    var clientID: String { get set }
    var secretID: String { get set }
    
    func saveUser(user: UserSession?)
    func getUser() -> UserSession?
}

class SessionLocal: SessionLocalProtocol {
    
    private let USER_SESSION_KEY = "USER_SESSION_KEY"
    private let defaults: UserDefaults
    
    var clientID: String
    
    var secretID: String
    
    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
        
        // 1
        guard let filePath = Bundle.main.path(forResource: "Keys", ofType: "plist") else {
            fatalError("Couldn't find file 'Keys.plist'.")
        }
        // 2
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let value = plist?.object(forKey: "CLIENT_ID") as? String else {
            fatalError("Couldn't find key 'CLIENT_ID' in 'Keys.plist'.")
        }
        
        clientID = value
        
        
        guard let value = plist?.object(forKey: "SECRET_ID") as? String else {
            fatalError("Couldn't find key 'SECRET_ID' in 'Keys.plist'.")
        }
        
        secretID = value
    }
    
    func saveUser(user: UserSession?) {
        defaults.set(user?.dict, forKey: USER_SESSION_KEY)
    }
    
    func getUser() -> UserSession? {
        if let data = defaults.data(forKey: USER_SESSION_KEY) {
            return try? JSONDecoder().decode(UserSession.self, from: data)
        }
        return nil
    }
}
