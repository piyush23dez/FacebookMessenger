//
//  FacebookTabBarViewController.swift
//  FacebookMessenger
//
//  Created by Sharma, Piyush on 9/17/16.
//  Copyright © 2016 Sharma, Piyush. All rights reserved.
//

import UIKit

class FacebookTabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let flowLayout = UICollectionViewFlowLayout()
       
        //First NavigationController
        let friendsViewController = FriendsViewController(collectionViewLayout: flowLayout)
        let friendsNavController = UINavigationController(rootViewController: friendsViewController)
        
        //Setup Tabbar item for first NavigationController
        friendsNavController.tabBarItem.title = "Recent"
        friendsNavController.tabBarItem.image = UIImage(named: "recent")

        //Second NavigationController
        let callsNavController = createTabbarNavigationController(tabItemTitle: "Calls", tabItemImageName: "calls")
        let groupNavController = createTabbarNavigationController(tabItemTitle: "Groups", tabItemImageName: "groups")
        let peopleNavController = createTabbarNavigationController(tabItemTitle: "People", tabItemImageName: "people")
        let settingsNavController = createTabbarNavigationController(tabItemTitle: "Settings", tabItemImageName: "settings")
        
        //Setup all controllers as childs of TabbarController
        viewControllers = [friendsNavController, callsNavController, groupNavController, peopleNavController, settingsNavController]
    }
    
    
    func createTabbarNavigationController(tabItemTitle: String, tabItemImageName: String) -> UINavigationController {
        let viewController = UIViewController()
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = tabItemTitle
        navController.tabBarItem.image = UIImage(named: tabItemImageName)
        return navController
    }
}
