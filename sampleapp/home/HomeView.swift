//
//  HomeView.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 01/12/21.
//

import Foundation
import SwiftUI

struct HomeView: View {
    
    @ObservedObject private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel = HomeViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    HStack {
                        Text("Boa noite")
                            .bold()
                        Spacer()
                        
                        NavigationLink(destination: SettingsView()){
                            Image(systemName: "gearshape")
                                .padding()
                        }
                        
                    }
                    
                    Tesy(title: "Suas playlistes", viewModel: viewModel)
                    
                    Tesy(title: "Suas playlistes", viewModel: viewModel)
                    
                }
                //                .padding(.leading, 10)
                //            .navigationBarTitle("Users", displayMode: .large)
                .onAppear(perform: viewModel.getLast)
            }
            .padding()
            .background(Color.gray.edgesIgnoringSafeArea(.all))
        }
    }
}

struct Tesy: View {
    
    private let title: String
    
    @ObservedObject private var viewModel: HomeViewModel
    
    init(title: String, viewModel: HomeViewModel = HomeViewModel()){
        self.title = title
        self.viewModel = viewModel
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // MARK: - Title
            Text(title)
                .foregroundColor(Color.white)
            
            // MARK: - List
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    
                    switch(viewModel.items){
                    case .Success(let data):
                        ForEach(data, id: \.id) { item in
                            VStack(alignment: .leading) {
                                AsyncImage(
                                    url: URL(string: item.images[0].url),
                                    transaction: .init(animation: .easeInOut)
                                ) { phase in
                                    switch phase {
                                    case .empty:
                                        //                                    randomPlaceholderColor()
                                        //                                      .opacity(0.2)
                                        //                                      .transition(.opacity.combined(with: .scale))
                                        Color.gray
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .transition(.opacity.combined(with: .scale))
                                    case .failure:
                                        //                                    ErrorView(error)
                                        Color.gray
                                    @unknown default:
                                        //                                    ErrorView()
                                        Color.gray
                                    }
                                }
                                .frame(width: 150, height: 150)
                                //                          .mask(RoundedRectangle(cornerRadius: 16))
                                
                                Text(item.name)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                            }
                            .onTapGesture {
                                print(item.name)
                            }
                        }
                    case .Idle, .Failure, .Loading:
                        Text("any")
                    }
                }
                //                .padding(.top, 10)
            }
            .frame(height: 240)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
