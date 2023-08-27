//
//  CalendarController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit

class CalendarController: UITabBarController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen

        configureUI()
        
        // Do any additional setup after loading the view.
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        navigationItem.title = "Calendar"
        
    }
    
}
