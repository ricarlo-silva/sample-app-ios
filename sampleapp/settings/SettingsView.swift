//
//  SettingsView.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 27/12/21.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    
    @ObservedObject private var viewModel: SettingsViewModel
    
    @StateObject var viewRouter = ViewRouter()

    
    init(viewModel: SettingsViewModel = SettingsViewModel()){
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewRouter.currentPage {
        case .page1:
            WelcomeView()
        case .page2:
            Text("Sair")
                .onTapGesture {
                    viewModel.doLogout()
            }
        }
    }
}
