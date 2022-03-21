//
//  HomeViewModel.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 01/12/21.
//

import Foundation
import CoreNetwork

class HomeViewModel: ObservableObject {
    
    @Published private(set) var items: ViewState<[Playlist]> = .Idle
    
    private let apiClient: NetworkClientProtocol
    
    init(
        apiClient: NetworkClientProtocol = NetworkClient.shared
    ) {
        self.apiClient = apiClient
    }
    
    func getLast() {
        Task {
            runMain {
                self.items = .Loading()
            }
            
            let request = Request(
                path: "https://api.spotify.com/v1/me/playlists",
                httpMethod: .GET
            )
            
            let result = await apiClient.call(request: request, type: ListResponse.self)
            
            switch result {
            case .success(let search):
                DispatchQueue.main.async {
                    self.items = .Success(search.items)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.items = .Failure(error)
                }
            }
        }
    }
}


func runMain(execute work: @escaping @convention(block) () -> Void) {
    DispatchQueue.main.async {
        work()
    }
}
