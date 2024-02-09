//
//  CustomCalendar.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/6/24.
//

import Foundation

struct CustomCalendar {
    // Static variable for custom calendar
    static var shared: Calendar {
        var calendar = Calendar.current
        calendar.firstWeekday = 1 // Set Sunday as the first day of the week
        return calendar
    }
}

