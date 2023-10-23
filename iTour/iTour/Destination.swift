//
//  Destination.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//

import Foundation
import SwiftData

@Model
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    @Relationship(deleteRule: .cascade, inverse: \Sight.destination) var sights = [Sight]()
    
    init(name: String = "", details: String = "" , date: Date = .now, priority: Int = 2) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
        self.sights = sights
    }
}
