//
//  TabBarViewController.swift
//  Spotify
//
//  Created by Justin Viasus on 8/1/21.
//

import UIKit

// In this Spotify app, we are going to have three main tabs, which implies us using a tab bar view controller.
class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create the view controllers
        let vc1 = HomeViewController()
        let vc2 = SearchViewController()
        let vc3 = LibraryViewController()
        
        vc1.title = "Browse"
        vc2.title = "Search"
        vc3.title = "Library"
        
        // each of these view controllers is going to have a large title
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        // create three navigation controllers.
        // Note: a navigation controller is a controller in which you have a title bar, a navigation bar, and you can navigate between controllers horizontally.
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.navigationBar.tintColor = .label // label in dark mode is white, in white mode it is black
        
        // set the icons for the tabs
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        // set the view controllers for this view controller
        setViewControllers([nav1, nav2, nav3], animated: false)
    }

}
