//
//  UpcomingGoalsController.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 7/27/23.
//

import UIKit
import SwiftUI

class UpcomingGoalsController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        navigationItem.title = "Upcoming Goals"
        
        // Create the SwiftUI view and wrap it in a UIHostingController
        let upcomingGoalsView = UpcomingGoalsView()
        let hostingController = UIHostingController(rootView: upcomingGoalsView)
        
        // Add the hosting controller as a child view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Setup the constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
}
