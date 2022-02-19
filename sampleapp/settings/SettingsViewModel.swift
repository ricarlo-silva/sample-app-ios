//
//  SettingsViewModel.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 27/12/21.
//

import Foundation
import CoreNetwork

class SettingsViewModel: ObservableObject {
    
    
    @Published private(set) var logout: ViewState<Bool> = .Idle
    
    private let apiClient: NetworkClientProtocol
    private let sessionLocal: SessionLocalProtocol
    
    init(
        apiClient: NetworkClientProtocol = NetworkClient.shared,
        sessionLocal: SessionLocalProtocol = SessionLocal()
    ) {
        self.apiClient = apiClient
        self.sessionLocal = sessionLocal
    }
    
    
    func doLogout() {
        sessionLocal.saveUser(user: nil)
    }
    
}
