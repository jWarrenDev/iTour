//
//  SightsView.swift
//  iTour
//
//  Created by Jerrick Warren on 10/22/23.
//

import SwiftUI
import SwiftData

struct SightsView: View {
    @Query(sort: \Sight.name) var sights: [Sight]
    
    var body: some View {
        NavigationStack{
            List(sights) { sight in
                NavigationLink(value: sight.destination) {
                    VStack(alignment:.leading) {
                        Text(sight.name)
                            .font(.headline)
                        Text(sight.destination?.name ?? "")
                            .font(.caption)
                    }
                }
            }
            .navigationTitle("Sights to See")
            .navigationDestination(for: Destination.self, destination: EditDestinationView.init)
        }
    }
}

#Preview {
    SightsView()
}
