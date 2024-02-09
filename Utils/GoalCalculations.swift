//
//  GoalCalculations.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/6/24.
//

enum GoalCalculationType{
    case weightGain(current: Double, target: Double)
    case weightLoss(current: Double, target: Double)
    case timeImprovement(current: Double, target: Double) // Measured in seconds or minutes
    case countIncrease(current: Int, target: Int) // Like repetitions
    case countDecrease(current: Int, target: Int)
    case bodyFatPercentage(current: Double, target: Double)
    case completionPercentage(current: Double, target: Double) // 0.0 to 1.0 for percentage
}

