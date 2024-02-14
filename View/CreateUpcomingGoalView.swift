import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseDatabase

struct CreateUpcomingGoalsView: View {
    @StateObject var viewModel = UpcomingGoalsViewModel()
    @StateObject var feedPostViewModel = FeedViewModel()
    @State private var caption: String = ""
    @State private var category: String = ""
    @State private var trackingPeriod: String = ""
    @State private var endGoal: String = ""
    @State private var currentProgress: String = ""
    @State private var completeBy: Date = Date()
    @State private var incrementValue: String = "1"
    @Environment(\.presentationMode) var presentationMode // Add this line

    init(initialGoalType: GoalType) {
          _category = State(initialValue: initialGoalType.rawValue)
      }
      
      var customCalendar: Calendar {
          var calendar = Calendar(identifier: .gregorian)
          calendar.locale = Locale(identifier: "en_US_POSIX")
          calendar.firstWeekday = 1
          return calendar
      }

      var body: some View {
          NavigationView {
              Form {
                  Section(header: Text("Create Your Goal")) {
                      TextField("Goal Caption", text: $caption)
                      Picker("Category", selection: $category) {
                          ForEach(GoalType.allCases, id: \.self) { category in
                              Text(category.rawValue.capitalized).tag(category)
                          }
                      }
                      Picker("Tracking Period", selection: $trackingPeriod) {
                          ForEach(TrackingPeriod.allCases, id: \.self) { period in
                              Text(period.rawValue.capitalized).tag(period.rawValue)
                          }
                      }

                      TextField("End Goal", text: $endGoal)
                      TextField("Current Progress", text: $currentProgress)

                      DatePicker("Complete By", selection: $completeBy, displayedComponents: .date)
                          .environment(\.calendar, customCalendar)
                  }

                  Section {
                      Button(action: createGoal) {
                          Text("Create Goal")
                              .foregroundColor(.blue)
                      }
                  }
              }
              .navigationBarTitle("New Goal", displayMode: .inline)
              .navigationBarItems(trailing: Button("Cancel") {
                  presentationMode.wrappedValue.dismiss()
              })
          }
      }

    private func createGoal() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No logged-in user.")
            return
        }
        
        let userRef = Database.database().reference().child("users").child(currentUser.uid)
        
        userRef.observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error fetching data:")
                return
            }
            
            userRef.observeSingleEvent(of: .value) { snapshot in
                guard let value = snapshot.value as? [String: Any],
                      let userDetails = SessionUserDetails(dictionary: value) else {
                    print("Could not retrieve user data.")
                    return
                }
                
                let selectedGoalType = self.goalType(from: self.category)
                let selectedTrackingPeriod = self.trackingPeriod(from: self.trackingPeriod)
                let goalPost = GoalPost(caption: self.caption,
                                        uid: currentUser.uid,
                                        category: selectedGoalType,
                                        completeBy: self.completeBy,
                                        endGoal: self.endGoal,
                                        user: userDetails,
                                        trackingPeriod: selectedTrackingPeriod,
                                        currentProgress: self.currentProgress,
                                        incrementValue: self.incrementValue,
                                        status: .active)
                
                let newFeedPost = FeedPost(goalPost: goalPost)
                self.feedPostViewModel.uploadFeedPost(with: goalPost.uid, feedPost: newFeedPost)
                self.viewModel.setupAuth(goalPost: goalPost)
                
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
    // Convert user input (String) to GoalType
    private func goalType(from category: String) -> GoalType {
        switch category.lowercased() {
        case "physical": return .physical
        case "mental": return .mental
        case "creative": return .creative
        case "financial": return .financial

        default: return .physical // Handle default case
        }
    }
    
    // Convert user input (String) to TrackingPeriod
    private func trackingPeriod(from trackingPeriod: String) -> TrackingPeriod {
        switch trackingPeriod.lowercased() {
        case "weekly": return .weekly
        case "monthly": return .monthly
        case "quarterly": return .quarterly
        default: return .weekly // Handle default case
        }
    }
}
        
