//
//  SplashViewModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 24.01.25.
//

import SwiftUI

struct SplashItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var caption: String = ""
    
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    /// As you can observe, the ZIndex won't have any animation effects. Therefore, I'll modify the offset value when it starts moving and reset its original offset value after a slight delay. This will ultimately make the icons appear to be swapping.
    var extraOffset: CGFloat = -350
}

let SplashItems: [SplashItem] = [
    .init(
        image: "cart.fill.badge.plus",
        title: "Willkommen bei HospitalFoodOrder",
        scale: 1
    ),
    .init(
        image: "pencil.and.list.clipboard",
        title: "Nimm einfach Bestellungen auf",
        scale: 0.6,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(
        image: "clock.arrow.trianglehead.counterclockwise.rotate.90",
        title: "Tracke einfach deine Arbeitszeit",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 160,
        extraOffset: -120
    ),
    .init(
        image: "person.fill.questionmark",
        title: "Hab keinen Stress mehr mit Merken",
        scale: 0.35,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 250,
        extraOffset: -100
    ),
]
