//
//  SearchViewController.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 01/12/21.
//

import Foundation
import SwiftUI

struct SearchView: View {
    
    @ObservedObject private var viewModel: SearchViewModel
    
    init(viewModel: SearchViewModel = SearchViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
//                Image(systemName: "magnifyingglass")
                TextField("Search...", text: $viewModel.query)
                    .foregroundColor(Color.white)
                    .onSubmit {
                        viewModel.search(query: "enkode")
                    }
            }
            .padding(4.0)
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).foregroundColor(Color.black))
            
            
            switch viewModel.genres {
            case .Success(let data):
                List(data) {
                    Text($0.name)
                }
            case .Loading:
                // TODO: show loading
                Text("loading...")
            case .Failure:
                Text("error...")
                //handlerError(error: error)
            case .Idle:
                Text("init...")
            }
            
            
        }
        .onAppear(perform: viewModel.getGenres)
        .background(Color.gray.edgesIgnoringSafeArea(.all))
//            .padding()
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
