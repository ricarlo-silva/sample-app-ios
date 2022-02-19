//
//  File.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 07/12/21.
//

import Foundation
import CoreNetwork
import SwiftUI

extension View {
    
//    @State private var showingAlert = false


    func handlerError(error: Error) {
        
        let message: String
        
        switch error {
        case HttpException.Unauthorized:
            // TODO: redict to login
            print("Unauthorized")
            return
        case HttpException.ApiError(let error):
            message = error.message
        default:
            message = "Ocorreu um erro."
        }
        
        print(message)
        
//        Alert(
//            title: Text("Erro"),
//            message: Text(message),
//            dismissButton: .default(Text("OK"))
//        )
        
    }
}

// https://stackoverflow.com/questions/60973766/how-to-show-reuse-the-same-view-alert-in-swiftui-from-all-viewmodels-in-case-o

struct BgView<Content>: View where Content: View {
    
    @State private var showingAlert = false
    
    let content: Content

    var body : some View {
        ZStack {
            content
        }.alert("Important message", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}
