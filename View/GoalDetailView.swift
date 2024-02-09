//
//  GoalDetailView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 12/14/23.
//

import SwiftUI

struct GoalDetailView: View {
    @ObservedObject var viewModel: UpcomingGoalsViewModel
    @State private var isEditing = false
    @State private var editableGoalPost: GoalPost
    @State private var incrementValue = "1"
    @State private var displayedProgress: String
    @Environment(\.presentationMode) var presentationMode // Add this line
    
    // Modified initializer
    init(goalPost: GoalPost, viewModel: UpcomingGoalsViewModel) {
        _editableGoalPost = State(initialValue: goalPost)
        self.viewModel = viewModel
        _displayedProgress = State(initialValue: goalPost.currentProgress)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Move the condition to check if not editing to wrap the Text views for caption and timestamp
                if !isEditing {
                    Text(editableGoalPost.caption)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    if let timestamp = editableGoalPost.timestamp {
                        Spacer() // Add Spacer to push timestamp to the right
                        Text("Posted on: \(timestamp, formatter: dateFormatter)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                    }
                }
                
                Group {
                    if isEditing {
                        TextField("Caption", text: $editableGoalPost.caption)
                        Picker("Category", selection: $editableGoalPost.category) {
                            ForEach(GoalType.allCases, id: \.self) { category in
                                Text(category.rawValue.capitalized).tag(category)
                            }
                        }
                        DatePicker("Complete By", selection: $editableGoalPost.completeBy, displayedComponents: .date)
                        TextField("End Goal", text: $editableGoalPost.endGoal)
                        TextField("Increment Goal Progress by", text: $incrementValue)
                            .keyboardType(.numberPad)
                        Picker("Tracking Period", selection: $editableGoalPost.trackingPeriod) {
                            ForEach(TrackingPeriod.allCases, id: \.self) { period in
                                Text(period.rawValue.capitalized).tag(period)
                            }
                        }
                    } else {
                        displayOnlyView
                    }
                    
                    // Edit and Complete buttons
                    editAndCompleteButtons
                }
                .padding()
            }
        }
        .navigationBarTitle("Goal Details", displayMode: .inline)
        .navigationBarItems(trailing: EditButton(iconName: isEditing ? "checkmark.circle" : "pencil.circle", isEditing: $isEditing, saveAction: {
            if isEditing {
                viewModel.editGoalPost(goalPostId: editableGoalPost.id, with: editableGoalPost)
            }
        }))
    }

        
    private var displayOnlyView: some View {
        VStack(alignment: .leading, spacing: 4) { // Adjust the spacing as needed
            Text("Category: ").fontWeight(.semibold) + Text(editableGoalPost.category.rawValue.capitalizedFirstLetter())
            Text("Complete By: ").fontWeight(.semibold) + Text(editableGoalPost.completeBy, formatter: dateFormatter)
            Text("End Goal: ").fontWeight(.semibold) + Text(editableGoalPost.endGoal)
            Text("Current Progress: ").fontWeight(.semibold) + Text(displayedProgress)
            Text("Tracking Period: ").fontWeight(.semibold) + Text(editableGoalPost.trackingPeriod.rawValue.capitalizedFirstLetter())
            
            if containsNumbers(editableGoalPost.caption) && containsNumbers(displayedProgress) {
                progressView
            }
        }
    }


    
    private var progressView: some View {
        let progressPercentage = calculateProgress()
        return VStack {
            ProgressView(value: progressPercentage, total: 100)
                .progressViewStyle(LinearProgressViewStyle())
            Text("\(Int(progressPercentage))% Complete")
                .font(.caption)
                .foregroundColor(.blue)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
    
    private var editAndCompleteButtons: some View {
        Group {
            // This button is shown only when isEditing is true for deleting a goal
            if isEditing {
                Button("Delete Goal", role: .destructive) {
                    viewModel.deleteGoalPost(goalPostId: editableGoalPost.id)
                }
                .padding()
                .foregroundColor(.red)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .shadow(radius: 3)
            }
            
            // This button is now only shown when isEditing is true to save changes
            if isEditing {
                Button(action: {
                    viewModel.editGoalPost(goalPostId: editableGoalPost.id, with: editableGoalPost)
                    isEditing.toggle() // Toggle editing state to false after saving
                }) {
                    Text("Save Changes")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                }
                .buttonStyle(PlainButtonStyle())
            }
            
            // This button is shown only when isEditing is false to complete a goal
            if !isEditing {
                Button("Complete Goal") {
                    viewModel.completeGoal(for: editableGoalPost)
                    // Assuming you have a presentationMode to dismiss the view
                    presentationMode.wrappedValue.dismiss()
                }
                .font(.headline)
                .bold()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50) // Adjust the height as needed
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color.green)
                        .shadow(color: .gray, radius: 1, x: 0, y: 1) // Add a subtle shadow
                )
            }
        }
    }



    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
    
    private var daysToCompletion: Int {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: Date())
        let endOfDay = calendar.startOfDay(for: editableGoalPost.completeBy)
        let components = calendar.dateComponents([.day], from: startOfDay, to: endOfDay)
        return components.day ?? 0
    }
    
    private func extractGoalNumber(from caption: String) -> Float? {
        let percentagePattern = "\\b(\\d+(\\.\\d+)?)%\\b"
        
        do {
            // Try to match the percentage pattern
            let percentageRegex = try NSRegularExpression(pattern: percentagePattern, options: [])
            let percentageResults = percentageRegex.matches(in: caption, options: [], range: NSRange(caption.startIndex..., in: caption))
            
            // Check if we have any matches for the percentage
            if let match = percentageResults.first, match.range(at: 1).location != NSNotFound,
               let percentageRange = Range(match.range(at: 1), in: caption),
               let percentage = Float(caption[percentageRange]) {
                return percentage
            }
        } catch {
            // Handle or log the error
            print("Regex error: \(error)")
            return nil
        }
        let minutesPattern = "\\b(\\d+)\\s*(minutes|minute)\\b"
        
        do {
            // Try to match the minutes pattern
            let minutesRegex = try NSRegularExpression(pattern: minutesPattern, options: [])
            let minutesResults = minutesRegex.matches(in: caption, options: [], range: NSRange(caption.startIndex..., in: caption))
            
            // Check if we have any matches for the minutes
            if let match = minutesResults.first, match.range(at: 1).location != NSNotFound,
               let minutesRange = Range(match.range(at: 1), in: caption),
               let minutes = Float(caption[minutesRange]) {
                // Convert minutes to seconds and return
                return minutes * 60
            }
        } catch {
            // Handle or log the error
            print("Regex error: \(error)")
            return nil
        }
        
        
        let timePattern = "(?:(\\d+)\\s*hours?)?\\s*(?:(\\d+)\\s*minutes?)?\\s*(?:(\\d+)\\s*seconds?)?"
        let numberPattern = "\\b(\\d+)\\b"
        
        // Try to match a number followed by a word (like "pull-ups")
        let numberRegex = try! NSRegularExpression(pattern: numberPattern, options: [])
        let numberResults = numberRegex.matches(in: caption, options: [], range: NSRange(caption.startIndex..., in: caption))
        
        // Check if we have any matches for the number
        if let match = numberResults.first {
            // Extract the number
            if match.range(at: 1).location != NSNotFound,
               let numberRange = Range(match.range(at: 1), in: caption),
               let number = Float(caption[numberRange]) {
                return number
            }
        }
        
        // Try to match time in the format of hours, minutes, and seconds
        let timeRegex = try! NSRegularExpression(pattern: timePattern, options: [])
        let timeResults = timeRegex.matches(in: caption, options: [], range: NSRange(caption.startIndex..., in: caption))
        
        if let match = timeResults.first {
            var totalSeconds: Float = 0
            
            // Extract hours, if present
            if match.range(at: 1).location != NSNotFound,
               let hourRange = Range(match.range(at: 1), in: caption),
               let hours = Float(caption[hourRange]) {
                totalSeconds += hours * 3600
            }
            
            // Extract minutes, if present
            if match.range(at: 2).location != NSNotFound,
               let minuteRange = Range(match.range(at: 2), in: caption),
               let minutes = Float(caption[minuteRange]) {
                totalSeconds += minutes * 60
            }
            
            // Extract seconds, if present
            if match.range(at: 3).location != NSNotFound,
               let secondRange = Range(match.range(at: 3), in: caption),
               let seconds = Float(caption[secondRange]) {
                totalSeconds += seconds
            }
            
            return totalSeconds
        } else {
            // If no time format was found, look for a general numeric value
            let numberPattern = "\\b[0-9]+(\\.[0-9]+)?\\b"
            let numberRegex = try! NSRegularExpression(pattern: numberPattern, options: [])
            let numberResults = numberRegex.matches(in: caption, options: [], range: NSRange(caption.startIndex..., in: caption))
            if let match = numberResults.first {
                let range = Range(match.range, in: caption)!
                let numberString = String(caption[range])
                return Float(numberString)
            }
        }
        return nil
    }
    
    private func incrementProgress() {
        if let increment = Int(editableGoalPost.incrementValue), let currentProgressInt = Int(editableGoalPost.currentProgress) {
            let updatedProgress = currentProgressInt + increment
            editableGoalPost.currentProgress = String(updatedProgress)
            displayedProgress = editableGoalPost.currentProgress  // Update the displayed progress
            
            // Save the changes to the database
            viewModel.editGoalPost(goalPostId: editableGoalPost.id, with: editableGoalPost)
        }
    }
    
    private func containsNumbers(_ string: String) -> Bool {
        return string.range(of: "\\d", options: .regularExpression) != nil
    }
    
    private func calculateProgress() -> Double {
        guard let goalNumber = extractGoalNumber(from: editableGoalPost.caption),
              let currentProgress = extractGoalNumber(from: editableGoalPost.currentProgress),
              goalNumber != 0 else {
            return 0
        }
        
        if currentProgress > goalNumber{
            //         guard let initialValue = extractGoalNumber(from: editableGoalPost.currentProgress), // Assuming 'initialValue' is a property of 'GoalPost'
            //               initialValue > goalNumber else {
            //             return 0
            var initialValue: Float = 24.0
            // }
            let progress = (initialValue - currentProgress) / (initialValue - goalNumber)
            print("Weight loss progress: \(progress)")
            return Double(min(progress * 100, 100))
        } else {
            // For standard goals where progress is a direct ratio of current to goal.
            let progress = currentProgress / goalNumber
            print("Standard goal progress: \(progress)")
            return Double(min(progress * 100, 100))
        }
    }
}


struct EditButton: View {
    var iconName: String
    @Binding var isEditing: Bool
    var saveAction: () -> Void  // Add a closure to perform save action
    
    var body: some View {
        Button(action: {
            if isEditing {
                // Call saveAction if currently editing
                saveAction()
            }
            isEditing.toggle()
        }) {
            Image(systemName: iconName)
                .imageScale(.large)
                .foregroundColor(.blue)
        }
    }
}

extension String {
    func capitalizedFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
