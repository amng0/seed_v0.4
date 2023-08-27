//
//  UpcomingGoal.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 8/26/23.
//

import Foundation

enum GoalType: String, CaseIterable, Hashable {
    case physical
    case mental
    case financial
    case creative
    
    var icon: String {
        switch self {
        case .physical:
            return "dumbbell"
        case .mental:
            return "brain"
        case .financial:
            return "dollarsign.circle"
        case .creative:
            return "paintpalette.fill"
        }
    }
}

