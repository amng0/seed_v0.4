//
//  CalendarView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/27/23.
//

import SwiftUI
import Firebase

struct CalendarView: View {
    @State private var selectedDate = Date()
    //private let calendar = Calendar.current
    var goalPosts: [GoalPost]?  // Array of GoalPost objects
    @ObservedObject var viewModel = UpcomingGoalsViewModel()
    
    @GestureState private var dragOffset = CGSize.zero

    var body: some View {
        VStack {
            // Month Navigation and Title
            monthNavigation

            // Days of the week
            daysOfWeekHeader

            // Date grid with swipe gesture
            dateGrid
                .gesture(
                    DragGesture()
                        .updating($dragOffset, body: { (value, state, _) in
                            state = value.translation
                        })
                        .onEnded({ value in
                            if value.translation.width > 100 {
                                // Swipe right
                                self.changeMonth(by: -1)
                            } else if value.translation.width < -100 {
                                // Swipe left
                                self.changeMonth(by: 1)
                            }
                        })
                )

            // ScrollView for goal post captions
            ScrollView {
                VStack {
                    ForEach(goalPostsForDate(date: selectedDate), id: \.id) { goalPost in
                        goalPostCaptionCard(goalPost)
                    }
                }
            }
        }
        .padding(.top, 10) // Adjust padding to start higher
        .padding(.horizontal, 13) // Add more spacing on the sides
        .onAppear {
            viewModel.fetchGoalPosts()
        }
    }

    var monthNavigation: some View {
        HStack {
            Button(action: {
                self.changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text("\(monthName(from: selectedDate)) \(String(year(from: selectedDate)))")
                .font(.title)

            Spacer()

            Button(action: {
                self.changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
            }
        }
        .padding()
    }

    var daysOfWeekHeader: some View {
        HStack {
            ForEach(daysOfWeek, id: \.self) { day in
                Text(day)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    var dateGrid: some View {
        let daysInMonth = self.daysInMonth(date: selectedDate)
        let firstDayOfMonth = self.firstDayOfMonth(date: selectedDate)
        let weekdayOfFirstDay = self.weekday(from: firstDayOfMonth)
        let startingSpaces = weekday(from: firstDayOfMonth) - calendar.firstWeekday + 1

        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 10) {
            ForEach(0..<startingSpaces, id: \.self) { _ in
                Text("") // Empty cells for alignment
                    .frame(width: 30, height: 30)
            }
            ForEach(1...daysInMonth, id: \.self) { day in
                let dayDate = self.calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth)!
                Text("\(day)")
                    .frame(width: 30, height: 30)
                    .background(self.isGoalPostDate(date: dayDate) ? Color.green.opacity(0.5) : (self.isToday(date: dayDate) ? Color.blue.opacity(0.5) : Color.clear))
                    .cornerRadius(15)
                    .foregroundColor(self.isGoalPostDate(date: dayDate) || self.isToday(date: dayDate) ? .white : .primary)
                    .onTapGesture {
                        self.selectedDate = dayDate
                    }
            }
        }
    }


    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 1 // Sunday
        return cal
    }



    
    func isToday(date: Date) -> Bool {
        calendar.isDateInToday(date)
    }



    func goalPostCaptionCard(_ goalPost: GoalPost) -> some View {
        Text(goalPost.caption)
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground)) // Use system background color
            .foregroundColor(Color.primary) // Adapt text color for Dark Mode
            .cornerRadius(10)
            .shadow(radius: 5)
            .font(.headline)
            .padding(.horizontal)
            .padding(.top, 10)
    }


    func isGoalPostDate(date: Date) -> Bool {
        viewModel.fetchedGoalPosts.contains { goalPost in
            calendar.isDate(goalPost.completeBy, inSameDayAs: date) && goalPost.status == .active
        }
    }

    func goalPostsForDate(date: Date) -> [GoalPost] {
        viewModel.fetchedGoalPosts.filter {
            calendar.isDate($0.completeBy, inSameDayAs: date) && $0.status == .active
        }
    }
    func changeMonth(by amount: Int) {
        if let newDate = calendar.date(byAdding: .month, value: amount, to: selectedDate) {                selectedDate = newDate
        }
    }

    // Helper Functions
    func monthName(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: date)
    }

    func year(from date: Date) -> Int {
        let year = calendar.component(.year, from: date)
        return year
    }

    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }


    func firstDayOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }


    func weekday(from date: Date) -> Int {
        let weekday = calendar.component(.weekday, from: date)
        // Sunday is 1, so no need to adjust for a 0 index array.
        return weekday - calendar.firstWeekday
    }




       func isToday(day: Int) -> Bool {
           calendar.isDate(selectedDate, inSameDayAs: calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth(date: selectedDate))!)
       }

       var daysOfWeek: [String] {
           ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
       }
   }

//struct CalendarView_Previews: PreviewProvider {
//    static var previews: some View {
//        CalendarView()
//    }
//}
