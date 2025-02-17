//
//  AnimatedColorWheelOverlay.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 11.09.24.
//

import SwiftUI

struct AnimatedColorWheelOverlay: View {
    @State private var rotation: Double = 0
    @State private var colorPhase: Double = 0 // Controls the color transitions
    
    let baseColors: [Color] = [
        .red, .orange, .yellow, .green, .blue, .indigo, .purple, .pink
    ]
    
    var dynamicColors: [Color] {
        let count = baseColors.count
        return (0..<count).map { index in
            let phase = (Double(index) / Double(count) + colorPhase).truncatingRemainder(dividingBy: 1.0)
            let fromIndex = Int(phase * Double(baseColors.count))
            let toIndex = (fromIndex + 1) % baseColors.count
            let progress = (phase * Double(baseColors.count)) - Double(fromIndex)
            
            return interpolateColors(
                from: baseColors[fromIndex],
                to: baseColors[toIndex],
                progress: progress
            )
        }
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let timeInterval = timeline.date.timeIntervalSince1970
                let angle = Angle.degrees(timeInterval.remainder(dividingBy: 5) / 5 * 360)
                
                // Update color phase for smooth transitions
//                colorPhase = timeInterval.remainder(dividingBy: 10) / 10
                
                context.translateBy(x: size.width / 2, y: size.height / 2)
                context.rotate(by: angle)
                
                for (index, color) in dynamicColors.enumerated() {
                    let path = Path { p in
                        p.move(to: .zero)
                        p.addArc(center: .zero, radius: max(size.width, size.height),
                                 startAngle: Angle(degrees: Double(index) / Double(dynamicColors.count) * 360),
                                 endAngle: Angle(degrees: Double(index + 1) / Double(dynamicColors.count) * 360),
                                 clockwise: false)
                        p.closeSubpath()
                    }
                    
                    context.addFilter(.blur(radius: 15))
                    context.fill(path, with: .color(color.opacity(1)))
                }
            }
        }
        .allowsHitTesting(false)
    }
    
    // Color interpolation function
    func interpolateColors(from: Color, to: Color, progress: Double) -> Color {
        let from = UIColor(from)
        let to = UIColor(to)
        
        var fromHue: CGFloat = 0, fromSaturation: CGFloat = 0, fromBrightness: CGFloat = 0, fromAlpha: CGFloat = 0
        var toHue: CGFloat = 0, toSaturation: CGFloat = 0, toBrightness: CGFloat = 0, toAlpha: CGFloat = 0
        
        from.getHue(&fromHue, saturation: &fromSaturation, brightness: &fromBrightness, alpha: &fromAlpha)
        to.getHue(&toHue, saturation: &toSaturation, brightness: &toBrightness, alpha: &toAlpha)
        
        // Handle hue wrapping around the color wheel
        var hueDiff = toHue - fromHue
        if hueDiff > 0.5 { hueDiff -= 1 }
        if hueDiff < -0.5 { hueDiff += 1 }
        
        let interpolatedHue = (fromHue + hueDiff * progress).truncatingRemainder(dividingBy: 1.0)
        let interpolatedSaturation = fromSaturation + (toSaturation - fromSaturation) * progress
        let interpolatedBrightness = fromBrightness + (toBrightness - fromBrightness) * progress
        
        return Color(uiColor: UIColor(
            hue: interpolatedHue,
            saturation: interpolatedSaturation,
            brightness: interpolatedBrightness,
            alpha: 1.0
        ))
    }
}

//struct AnimatedColorWheelOverlay_Previews: PreviewProvider {
//    static var previews: some View {
//        AnimatedColorWheelOverlay()
//    }
//}
