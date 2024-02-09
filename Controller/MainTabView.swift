import SwiftUI
import Firebase

struct MainTabView: View {
    @State private var selection = 0
    @State private var uniqueKeys = [Int: UUID]()
    
    var body: some View {
        TabView(selection: $selection) {
            FeedView() // Assuming you have a SwiftUI View for Feed
                .id(uniqueKeys[0, default: UUID()])
                .tabItem {
                    Label("", systemImage: "house")
                }
                .tag(0)
            
            SearchView() // Assuming you have a SwiftUI View for Upcoming Goals
                .id(uniqueKeys[1, default: UUID()])
                .tabItem {
                    Label("", systemImage: "magnifyingglass")
                }
                .tag(1)
            
            UpcomingGoalsView() // Assuming you have a SwiftUI View for Feed
                .id(uniqueKeys[2, default: UUID()])
                .tabItem {
                    Label("", systemImage: "flame")
                }
                .tag(2)
            
            CalendarView() // Assuming you have a SwiftUI View for Calendar
                .id(uniqueKeys[3, default: UUID()])
                .tabItem {
                    Label("", systemImage: "calendar")
                }
                .tag(3)
            
            UserProfileView()
                .id(uniqueKeys[4, default: UUID()])
                .tabItem {
                    Label("", systemImage: "person.crop.circle")
                }
                .tag(4)
        }
        .onChange(of: selection) { newSelection in
            // Generate a new UUID for the re-selected tab to reset its view
            uniqueKeys[newSelection] = UUID()
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
