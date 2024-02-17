//
//  TabShape.swift
//  TrainingsApp
//
//  Created by Felix Kircher on 21.12.23.
//

import SwiftUI

// Custom Tab Shape
struct TabShape: Shape {
    var midpoint: CGFloat
    var cornerRadius: CGSize 
    
    // Adding Shape Animation
    var animatableData: CGFloat {
        get { midpoint }
        set {
            midpoint = newValue
        }
    }
    
    func path(in rect: CGRect) -> Path {
        return Path { path in
            // First Drawing the Rectangle Shape
            path.addPath(RoundedRectangle(cornerSize: cornerRadius).path(in: rect))
            // Now Drawing Upward Curve Shape
            path.move(to: .init(x: midpoint - 60, y: 0))
            
            let to = CGPoint(x: midpoint, y: -25)
            let control1 = CGPoint(x: midpoint - 25, y: 0)
            let control2 = CGPoint(x: midpoint - 25, y: -25)
            
            path.addCurve(to: to, control1: control1, control2: control2)
            
            let to1 = CGPoint(x: midpoint + 60, y: 0)
            let control3 = CGPoint(x: midpoint + 25, y: -25)
            let control4 = CGPoint(x: midpoint + 25, y: 0)
            
            path.addCurve(to: to1, control1: control3, control2: control4)
        }
    }
}

