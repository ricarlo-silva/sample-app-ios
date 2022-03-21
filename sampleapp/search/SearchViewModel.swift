//
//  SearchView.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 03/12/21.
//

import Foundation
import CoreNetwork

//@MainActor
class SearchViewModel: ObservableObject {
    
    @Published private(set) var search: SearchResponse? = nil
    
    @Published private(set) var genres: ViewState<[Genre]> = .Idle
    
    @Published var query: String = ""
    
    private let apiClient: NetworkClientProtocol
    
    init(
        apiClient: NetworkClientProtocol = NetworkClient.shared
    ) {
        self.apiClient = apiClient
    }
    
    func search(query: String) {
        Task {
            
            let request = Request(
                path:  "https://api.spotify.com/v1/search?q=name:\(query)&type=album,track",
                httpMethod: .GET
            )
            
            let result = await apiClient.call(request: request, type: SearchResponse.self)
            
            switch result {
            case .success(let search):
                self.search = search
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getGenres() {
        
        Task {
            
            let request = Request(
                path:  "https://api.spotify.com/v1/recommendations/available-genre-seeds",
                httpMethod: .GET
            )
            
            let result = await apiClient.call(request: request, type: GenreResponse.self)
            
            switch result {
            case .success(let genres):
                DispatchQueue.main.async {
                    self.genres = .Success(genres.genres.map { Genre(name: $0) })
                }
            case .failure(let error):
                switch error {
                case HttpException.Unauthorized:
                    print("")
                case HttpException.ApiError(let error):
                    print(error.message)
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}

