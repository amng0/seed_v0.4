//
//  AddStatView.swift
//  seed_v0.4
//
//  Created by Amie Nguyen on 11/10/23.
//

import SwiftUI

struct AddStatView: View {
    @Binding var showing: Bool
    @Binding var title: String
    @Binding var value: String
    @Environment(\.dismiss) var dismiss
    var goalType: String
    
    // Inject viewModel
    var viewModel: StatsViewModel
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Stat Details")) {
                    TextField("Title", text: $title)
                    TextField("Value", text: $value)
                }
                Button("Save") {
                    let newStat = Stat(title: title, value: value, goalType: "physical")
                    viewModel.addStat(stat: newStat)
                    
                    // Reset the fields and close the sheet
                    title = ""
                    value = ""
                    showing = false // Set this to false to dismiss the sheet
                }


                }
            }
            .navigationTitle("Add \(goalType) Stat")
            .navigationBarItems(leading: Button("Cancel") {
                self.showing.toggle()
                dismiss()
                
            })
        }
    }
//}

//struct AddStatView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddStatView()
//    }
//}
