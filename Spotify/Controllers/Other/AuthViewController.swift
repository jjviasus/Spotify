//
//  AuthViewController.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import UIKit
import WebKit // the apple provided framework for webviews

// This is where the user signs in with the API. We will load up an authentication page in a web view.
class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        // allow java script to be enabled
        
        let prefs = WKWebpagePreferences()
        prefs.allowsContentJavaScript = true
        
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = prefs
        
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }() // Note: look up anonymous closures in Swift
    
    // a closure that returns a Boolean as the property and the closure returns Void.
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign in"
        view.backgroundColor = .systemBackground
        webView.navigationDelegate = self //  we want to know when the page loads. For example: once the page redirects to the redirect uri or an error occurs, we want to make sure we can detect all those events.
        view.addSubview(webView)
        
        guard let url = AuthManager.shared.signInURL else { return } // unwrap the url
        webView.load(URLRequest(url: url))
    }
    
    // load up the URL to sign in the user
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds // sets this web view's frame to the entirety of the view controller's bounds
    }
    
    // webView:didStartProvisionalNavigation: Tells the delegate that navigation from the main frame has started.
    // The web view calls this method after it receives provisional approval to process a navigation request, but before it receives a response to that request.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        guard let url = webView.url else { return }
        
        // if the url has a parameter for code, we want to get that out. We want to exchange the code that spotify gives us after the user gives us permission, for an access token.
        
        // exchange the code for access token
        guard let code = URLComponents(string: url.absoluteString)?.queryItems?.first(where: { $0.name == "code"  })?.value else { return }
        
        print("Code: \(code)")
    }
}
