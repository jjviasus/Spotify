//
//  WelcomeViewController.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import UIKit

// Welcome screen if a user is not signed in.
class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign In with Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Spotify"
        view.backgroundColor = .systemGreen
        
        // add the button to our view
        view.addSubview(signInButton)
        // attach the selector function
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    // layout the button
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        signInButton.frame = CGRect(
            x: 20,
            y: view.height-50-view.safeAreaInsets.bottom,
            width: view.width-40,
            height: 50)
    }
    
    // have an action handler for the button (when sign in is tapped)
    @objc func didTapSignIn() {
        let vc = AuthViewController()
        
        // tells our Welcome Controller that the user has successfully signed in
        vc.completionHandler = { [weak self] success in
            // handle the result of the sign in
            
            // on the main thread
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never // smaller
        
        // pushes the authentication view controller on to the screen
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        // Log user in or yell at them for error
        guard success else {
            // if something went wrong, show an alert
            let alert = UIAlertController(title: "Oops", message: "Something went wrong when signing in.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabBarVC = TabBarViewController()
        mainAppTabBarVC.modalPresentationStyle = .fullScreen // so the user can't swipe it away
        present(mainAppTabBarVC, animated: true)
    }
    
}
