//
//  Sight.swift
//  iTour
//
//  Created by Jerrick Warren on 10/21/23.
//

// inverse relationship.  Must be optional
// better to do it explicitly in Destination.swfit
// Very cool!

import SwiftData

@Model
class Sight {
    var name: String
    var destination: Destination?
    
    init(name: String) {
        self.name = name
    }
}
