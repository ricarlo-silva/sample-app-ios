//
//  ContentView.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 30/10/21.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello World").padding()
                
                NavigationLink(destination: AuthView()) {
                    Text("Sign with Spotify")
                }
            }
        }.navigationTitle("Welcome")

    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
