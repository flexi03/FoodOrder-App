//
//  CardModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 11.11.23.
//

import SwiftUI

// Card Model and sample Cards

struct Card: Identifiable {
    var id: UUID = .init()
    var bgColor: Color
    var balance: Int
}

var cards: [Card] = [
    Card(bgColor: .purple, balance: 1),
    Card(bgColor: .blue, balance: 2),
    Card(bgColor: .red, balance: 3),
    Card(bgColor: .green, balance: 4)
]
