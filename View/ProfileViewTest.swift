//
//  GoalProfileView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 10/12/23.
//

import SwiftUI
import Combine
import MapKit
import Firebase


//struct Stat: Identifiable {
//    var id = UUID()
//    var title: String
//    var value: String
//}

struct ProfileViewTest: View {
    @State private var selectedView = 0
    @State private var subscriberCount: String = "Fetching..."
    @State private var showingAddStatSheet = false
    @State private var newStatTitle: String = ""
    @State private var newStatValue: String = ""
    // @ObservedObject private var viewModel = StatsViewModel()
    
    let apiKey = "AIzaSyC-hlXP2XsLzATPnUCYBiG3UCN_s5HCvzc"
    let channelId = "UCrzJLFM7yNu4sIM1RRCe5tw"
    
    var body: some View {
        VStack {
            // Banner
            Image("banner")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 125)
                .clipped()
            
            // Profile Picture and details
            HStack(alignment: .top, spacing: 15){
                // Profile picture
                Image("profile_pic")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
                // OFFSET CHANGES POSITIONING
                    .offset(y: -50)
                    .padding(.bottom, -50)
                
                // Profile Details
                VStack(alignment: .leading, spacing: 2) {
                    Text("Amie Nguyen")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("@amng0")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
            
            // Tribe count and bio
            VStack (alignment: .leading, spacing: 3){
                Text("69").fontWeight(.bold) + Text(" Tribe Members")
                    .font(.subheadline)
                Text("im jus tryna buy a jet lol")
                    .font(.body)
                    .foregroundColor(.black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 40)
            
            
            .padding(.top, 5)
            // Filter View / Picker
            Picker("", selection: $selectedView) {
                Text("Active Goals").tag(0)
                Text("Stats").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            .onReceive(Just(selectedView)) { newValue in
                if newValue == 1 {
                    //   loadSubscriberCount() // Load subscriber count when "Stats" is selected
                    
                    // PHYSICAL:
                    //                    if let uid = Auth.auth().currentUser?.uid {
                    //                        viewModel.loadStats(forUserID: uid)
                    //                    } else {
                    //                        print("No authenticated user found.")
                }
            }
        }
    }
}
        // Toggled content based on the selected view
//        if selectedView == 0 {
//            //Text("This is the content for Active Goals")
//            //activeGoalPopulation()
//            ProfilePostsView()
//        } else {
//            HStack{
//                Spacer()
//
//                Button(action: {
//                    print("Filter button")
//                }){
//                    Image(systemName: "line.3.horizontal.decrease.circle.fill")
//                }
//                .padding(.trailing, 27)
//            }
//            Text("YouTube Subscribers: \(subscriberCount)")
//            // StatsView(viewModel: StatsViewModel())
//
//
//        }
//        Spacer()
//    }
//
//    struct ProfilePostsView: View {
//        var body: some View {
//            ScrollView {
//                VStack(spacing: 0){
//                    ForEach(0..<10, id: \.self) { _ in
//
//                        //                        ActiveGoalView(viewModel: ActiveGoalViewModel(activeGoal: .goalPost, user: .user))
//                    }
//                }
//            }
//        }
//    }
    
//    func activeGoalPopulation() -> some View {
//        List(0..<10) { _ in
//            Rectangle()
//                .fill(Color.clear)
//                .frame(height: 50)  // Adjust the height as needed
//                .listRowInsets(EdgeInsets())
//                .background(Color(UIColor.systemBackground)) // Use systemBackground color for adaptability
//        }
//    }
//
//
//}
//
    
//    struct GoalProfileView_Previews: PreviewProvider {
//        static var previews: some View {
//            GoalProfileHeaderView(stat: $stat)
//        }
//    }
    //}

