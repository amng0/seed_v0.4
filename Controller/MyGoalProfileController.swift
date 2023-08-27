//
//  MyGoalProfileController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit

class MyGoalProfielController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemYellow

        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        navigationItem.title = "My Goal Profile"
        
    }
}
