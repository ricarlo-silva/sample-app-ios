//
//  sampleappApp.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 30/10/21.
//

import SwiftUI
import CoreNetwork

@main
struct sampleappApp: App {
        
    @StateObject var viewRouter = ViewRouter()
    
    init(){
        NetworkClient.shared.setup(
            authenticator: AuthenticatorInterceptor(),
            interceptors: [TokenInterceptor()]
        )
    }
    
    var body: some Scene {
        WindowGroup {
            switch viewRouter.currentPage {
            case .page1:
                WelcomeView()
            case .page2:
                MainView()
            }
        }
    }


}


enum Page {
    case page1
    case page2
}

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page
    
    private let sessionLocal: SessionLocalProtocol

    init(sessionLocal: SessionLocalProtocol = SessionLocal()){
        self.sessionLocal = sessionLocal
        
        if (sessionLocal.getUser()) != nil {
            currentPage = .page2
        } else {
            currentPage = .page1
        }
    }
    
}
