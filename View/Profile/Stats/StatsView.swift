import SwiftUI
import Firebase

struct StatsView: View {
    @ObservedObject private var viewModel: StatsViewModel

    @State private var showingAddStatSheet = false
    @State private var showingEditStatSheet = false
    @State private var statForEdit: Stat?
    @State private var newStatTitle = "" // State variable for title
    @State private var newStatValue = "" // State variable for value

    init(viewModel: StatsViewModel) {
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.stats, id: \.id) { stat in
                        StatCell(stat: stat) {
                            self.statForEdit = stat // Assign the selected stat for editing
                        }
                        .background(
                            NavigationLink(destination: EditStatView(stat: stat, viewModel: viewModel) {
                                self.statForEdit = nil // Reset the selected stat after editing
                                viewModel.fetchStats() // Refresh data after editing
                            }, isActive: Binding<Bool>(
                                get: { self.statForEdit?.id == stat.id },
                                set: { _ in }
                            )) {
                                EmptyView()
                            }
                            .hidden() // Hide the NavigationLink visually
                        )
                        .padding(.vertical, 4) // Add some vertical padding between cells
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { self.showingAddStatSheet = true }) {
                        Image(systemName: "plus.circle")
                            .imageScale(.large)
                            .foregroundColor(.primary)
                    }
                }
            }
            .sheet(isPresented: $showingAddStatSheet) {
                AddStatView(showing: $showingAddStatSheet, title: $newStatTitle, value: $newStatValue, goalType: "", viewModel: viewModel)            }
        }
        .navigationTitle("Stats")
        .onAppear {
            viewModel.fetchStats() // Fetch stats when the view appears
        }
    }
}



struct StatCell: View {
    var stat: Stat
    var editAction: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(stat.title).font(.headline)
                Text(stat.value).font(.subheadline)
            }
            Spacer()
            Button(action: editAction) {
                Image(systemName: "pencil.circle").foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground)) // You can change this if you want a different background
        .cornerRadius(10)
        //.shadow(radius: 1) // Optional: Adds a subtle shadow for depth
    }
}
