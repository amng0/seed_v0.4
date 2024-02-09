//
//  UpcomingGoal.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 8/26/23.
//

import Foundation

enum GoalType: String, CaseIterable, Hashable, Codable {
    case physical
    case mental
    case creative
    case financial
    
    var icon: String {
        switch self {
        case .physical:
            return "dumbbell"
        case .mental:
            return "brain"
        case .creative:
            return "paintpalette.fill"
        case .financial:
            return "dollarsign.circle"
        }
    }
}

