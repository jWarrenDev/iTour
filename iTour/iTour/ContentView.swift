//
//  ContentView.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//

// ForEach.. if you want to add delete modifier
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // read it and put in an array
    // NSFetchResults ( @FetchRequest)

    @Environment(\.modelContext) var modelContext
    @State private var path = [Destination]()
    @State private var sortOrder = [SortDescriptor(\Destination.date, order: .forward),
                                    SortDescriptor(\Destination.name)]
    @State private var searchString = ""
    
    @State private var minimumDate = Date.distantPast
    let currentDate = Date.now
    
    var body: some View {
        NavigationStack(path: $path){
            DestinationListingView(sort: sortOrder,
                                   searchString: searchString,
                                   minimumDate: minimumDate
            )
            .navigationTitle("iTour")
            .searchable(text: $searchString)
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
    
            .toolbar {
                Button("Add Destination", systemImage: "plus", action: addDestination)
                
                Menu("Sort", systemImage: "arrow.up.arrow.down") {
                    Picker("Sort", selection: $sortOrder) {
                        Text("Name")
                            .tag([
                                SortDescriptor(\Destination.name),
                                SortDescriptor(\Destination.date, order: .reverse)
                            ])
                        Text("Priority")
                            .tag([
                                SortDescriptor(\Destination.priority, order: .reverse),
                                SortDescriptor(\Destination.name)
                            ])
                        Text("Date")
                            .tag([
                                SortDescriptor(\Destination.date, order: .reverse),
                                SortDescriptor(\Destination.name)
                                 ])
                    }
                    .pickerStyle(.inline)
                    
                    Picker("Filter", selection: $minimumDate) {
                        Text("Show all destinations")
                            .tag(Date.distantPast)
                        Text("Show Future destinations")
                            .tag(currentDate)
                    }
                    .pickerStyle(.inline)
                }
            }
        }
    }

    func addDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        path = [destination]
    }
}

#Preview {
    ContentView()
}
