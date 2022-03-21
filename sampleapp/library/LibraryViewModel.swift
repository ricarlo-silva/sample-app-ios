//
//  LibraryViewModel.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 26/12/21.
//

import Foundation
import CoreNetwork

class LibraryViewModel: ObservableObject {
    
    @Published private(set) var items: ViewState<[Playlist]> = .Idle
    
    private let apiClient: NetworkClientProtocol
    
    init(
        apiClient: NetworkClientProtocol = NetworkClient.shared
    ) {
        self.apiClient = apiClient
    }
    
    
    func getLast() {
        Task {
            DispatchQueue.main.async {
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
                    self.items = .Failure(HttpException.Unauthorized) //.Success(search.items)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.items = .Failure(error)
                }
            }
        }
    }
}
