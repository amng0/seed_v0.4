//
//  MainTabController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}
            //feed.user = user
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        //logUserOut()
        super.viewDidLoad()
        authenticateUserAndConfigureUI()
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authenticateUserAndConfigureUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
        }
    }
    
    func logUserOut(){
        do {
            try Auth.auth().signOut()
            print("Logged user out")
        } catch let error {
            print("failed to sign user out")
        }
    }
    
    // MARK: - Selectors
    
    // MARK: - Helpers
    
    func configureUI() {

    }
    
    func configureViewControllers(){
        
        //Create seperate views throughout application
        //Centralize views
        
        //Create bottom tab bar
        let tabBarController = UITabBarController()
        tabBarController.tabBar.backgroundColor = .systemGray5
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavigationController(image: UIImage(systemName: "house.fill"), rootViewController: feed)
        
        let upcomingGoals = UpcomingGoalsController()
        let nav2 = templateNavigationController(image: UIImage(systemName: "flame"), rootViewController: upcomingGoals)
        
        let calendar = CalendarController()
        let nav3 = templateNavigationController(image: UIImage(systemName: "calendar" ), rootViewController: calendar)
        
        let goalProfile = MyGoalProfielController()
        let nav4 = templateNavigationController(image: UIImage(systemName: "figure.dance" ), rootViewController: goalProfile)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    //allows cross navigation through views
    //
    //what is a "rootViewController*******
    //
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        
        //Configure settings of top Navigation Bar on top of views
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        nav.navigationBar.standardAppearance = appearance
        nav.navigationBar.scrollEdgeAppearance = nav.navigationBar.standardAppearance
        
        return nav
    }
}




