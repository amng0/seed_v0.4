//
//  CompletedGoalsView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 1/15/24.
//

import SwiftUI

struct CompletedGoalsView: View {
    @ObservedObject var viewModel: UpcomingGoalsViewModel

    var body: some View {
        List(viewModel.fetchedGoalPosts.filter { $0.status == .completed }) { goalPost in
            VStack(alignment: .leading) {
                Text(goalPost.caption)
                    .font(.headline)
                Text("Completed by: \(goalPost.completeBy, formatter: itemFormatter)")
                    .font(.subheadline)
                Text("Likes: \(goalPost.likes)")
                    .font(.subheadline)
            }
        }
        .onAppear {
            viewModel.fetchGoalPosts()
            print("poop: \(viewModel.fetchedGoalPosts.filter { $0.status == .completed })")
        }
    }

    private var itemFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
}

struct CompletedGoalsView_Previews: PreviewProvider {
    static var previews: some View {
        CompletedGoalsView(viewModel: UpcomingGoalsViewModel())
    }
}
