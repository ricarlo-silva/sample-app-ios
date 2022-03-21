//
//  AuthView.swift
//  sampleapp
//
//  Created by Ricarlo Silva on 28/11/21.
//

import SwiftUI
import WebKit

struct AuthView: View {
    
    @ObservedObject private var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel = AuthViewModel()){
        self.viewModel = viewModel
    }

    var body: some View {
        WebView(url: viewModel.url!).onLoadStatusChanged { webView in
            guard let url = webView.url?.absoluteString else { return }
            
            guard let code = URLComponents(string: url)?.queryItems?.first(where: {$0.name == "code" })?.value else {
                return
            }
            print("CODE: \(code)")
            
            webView.isHidden = true
            

            viewModel.fatchToken(code)
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}


struct WebView: UIViewRepresentable {
    
//    @Binding var title: String
    let url: URL
    var loadStatusChanged: ((WKWebView) -> Void)? = nil

    func makeCoordinator() -> WebView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let view = WKWebView()
        view.navigationDelegate = context.coordinator
        view.load(URLRequest(url: url))
        return view
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // you can access environment via context.environment here
        // Note that this method will be called A LOT
    }

    func onLoadStatusChanged(perform: ((WKWebView) -> Void)?) -> some View {
        var copy = self
        copy.loadStatusChanged = perform
        return copy
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.loadStatusChanged?(webView)
        }
    }
}
