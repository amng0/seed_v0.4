//
//  AddStatView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 11/10/23.
//

import SwiftUI

struct EditStatView: View {
    var stat: Stat
    @ObservedObject var viewModel: StatsViewModel
    var onEditComplete: () -> Void

    @State private var title: String
    @State private var value: String
    @Environment(\.presentationMode) var presentationMode // Added for handling the view dismissal


    init(stat: Stat, viewModel: StatsViewModel, onEditComplete: @escaping () -> Void) {
        self.stat = stat
        self.viewModel = viewModel
        self.onEditComplete = onEditComplete
        _title = State(initialValue: stat.title)
        _value = State(initialValue: stat.value)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $title)
                TextField("Value", text: $value)
            }
            .navigationBarTitle("Edit Stat", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                let updatedStat = Stat(id: stat.id, title: title, value: value, goalType: stat.goalType)
                viewModel.editStat(statId: stat.id, with: updatedStat)
                onEditComplete()
                presentationMode.wrappedValue.dismiss() // Dismiss the view

            })
        }
    }
}
