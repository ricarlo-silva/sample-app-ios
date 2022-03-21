//
//  LibraryViewController.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 01/12/21.
//

import Foundation
import SwiftUI


struct LibraryView: View {
    
    @ObservedObject private var viewModel: LibraryViewModel
    
    init(viewModel: LibraryViewModel = LibraryViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            
            switch(viewModel.items) {
            case .Success(let data):
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(data, id: \.id) { item in
                            HStack {
                                
                                AsyncImage(
                                    url: URL(string: item.images[0].url),
                                    transaction: .init(animation: .easeInOut)
                                ) { phase in
                                    switch phase {
                                    case .empty:
                                        Color.gray
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .transition(.opacity.combined(with: .scale))
                                    case .failure:
                                        Color.gray
                                    @unknown default:
                                        Color.gray
                                    }
                                }
                                .frame(width: 60, height: 60)
                                
                                
                                VStack(alignment: .leading){
                                    Text(item.name)
                                    Text("\(item.type.rawValue.capitalized) . \(item.owner.displayName)")
                                }
                                
                            }
                        }
                    }
                }
            case .Loading:
                ProgressView()
            case .Failure(let error):
                AuthView()
//                Label("\(error.localizedDescription)", systemImage: "xmark")
            case .Idle:
                Text("")
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        .onAppear(perform: viewModel.getLast)
        .background(Color.gray.edgesIgnoringSafeArea(.all))
    }
    
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

