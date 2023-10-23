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
import PhotosUI

struct EditDestinationView: View {
    // MARK: - if I just watnted to READ
    //    var destination: Destination
    @Environment(\.modelContext) private var modelContext
    @Bindable var destination: Destination
    @State private var newSightName = ""
    
    @State private var photosItem: PhotosPickerItem?

    var sortedSights: [Sight] {
        destination.sights.sorted {
            $0.name < $1.name
        }
    }
    
    var body: some View {
        Form {
            Section {
                if let imageData = destination.image {
                    if let image = UIImage(data: imageData) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    }
                }
                
                PhotosPicker("Attach a photo", selection: $photosItem, matching: .images)
            }
            
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
                ForEach(sortedSights) { sight in
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
        .onChange(of: photosItem) {
            Task {
                destination.image = try? await photosItem?.loadTransferable(type: Data.self)
            }
        }
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
            let sight = sortedSights[index]
            modelContext.delete(sight)
        }
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
