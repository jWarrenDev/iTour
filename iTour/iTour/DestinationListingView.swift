//
//  DestinationListingView.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//

// the init function is to reference the QUERY itself, rather than the array of data returned

import SwiftData
import SwiftUI

struct DestinationListingView: View {
    
    @Environment(\.modelContext) var modelContext

    @Query(sort: [
            SortDescriptor(\Destination.priority, order: .reverse),
            SortDescriptor(\Destination.name, order: .forward)
                ])
    
    var destinations: [Destination]
    
    init(sort: [SortDescriptor<Destination>],
         searchString: String,
         minimumDate: Date) {
        _destinations = Query(filter: #Predicate {
            if searchString.isEmpty {
                return $0.date > minimumDate
            } else {
                return $0.name.localizedStandardContains(searchString) && $0.date > minimumDate
            }
        },sort: sort)
        
    }
    
    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)
                        Text(destination.date.formatted(date: .long, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestinations)
        }
    }
    
    func deleteDestinations(_ indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    DestinationListingView(sort: [SortDescriptor(\Destination.name)], searchString: "", minimumDate: Date.distantPast)
}
