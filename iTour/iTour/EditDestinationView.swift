//
//  EditDestinationView.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//

// For PREVIEW
// 1. Model Configuration
// 2. Model Container
// 3. Sample Data
// 4. Send objects

import SwiftData
import SwiftUI

struct EditDestinationView: View {
    // MARK: - if I just watnted to READ
    //    var destination: Destination
    
    @Bindable var destination: Destination
    @State private var newSightName = ""
   
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Form {
            TextField("Name", text: $destination.name)
            TextField("Details", text: $destination.details, axis: .vertical)
            DatePicker("Date", selection: $destination.date)
            
            Section("Priority") {
                Picker("Priority", selection: $destination.priority) {
                    Text("Meh").tag(1)
                    Text("Maybe").tag(2)
                    Text("Must").tag(3)
                }
                .pickerStyle(.segmented)
            }
            
            Section("Sight") {
                ForEach(destination.sights) { sight in
                    Text(sight.name)
                }
                .onDelete(perform: deleteSights)
                
                HStack {
                    TextField("Add a new sight in \(destination.name)", text: $newSightName)
                    
                    Button("Add", action: addSight)
                }
            }
        }
        .navigationTitle("Edit Destination")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func addSight() {
        guard !newSightName.isEmpty else {
            return
        }
        
        withAnimation {
            let sight = Sight(name: newSightName)
            destination.sights.append(sight)
            newSightName = ""
        }
    }
    
    func deleteSights(_ indexSet: IndexSet) {
        for index in indexSet {
            var sight = destination.sights[index]
            modelContext.delete(sight)
        }
        
        destination.sights.remove(atOffsets: indexSet)
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        let example = Destination(name: "Example Destination", details: "This place will house our destination details. It will be a long paragraph of stuff, you can expect to find for the destination.")
        return EditDestinationView(destination: example)
            .modelContainer(container)
    } catch {
        fatalError("Failed to create Model container.")
    }
   
}
