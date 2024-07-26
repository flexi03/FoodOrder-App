//
//  Tabs.swift
//  TrainingsApp
//
//  Created by Felix Kircher on 20.12.23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    
    case order = "Bestellung"
    case workingtime = "Arbeitszeit"
    case settings = "Einstellungen"
    
    var systemImage: String {
        switch self {
            case .order:
                return "cart.badge.plus"
            case .workingtime:
                return "clock.arrow.circlepath"
            case .settings:
                return "gear.badge"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}

struct TabItem: View {
    var tint: Color = .accentColor
    var inactiveTint: Color 
    var tab: Tab
    var animation: Namespace.ID
    var cornerRadius: CGSize
    @Binding var activeTab: Tab
    @Binding var position: CGPoint
    
    @State private var tabPosition: CGPoint = .zero
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                    }
                }
            
            Text(tab.rawValue)
                .bold()
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .accentColor.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .contentShape(RoundedRectangle(cornerSize: cornerRadius))
        .viewPosition(completion: { rect in
            tabPosition.x = rect.midX
            
            // Updating Active Tab Position
            if activeTab == tab {
                position.x = rect.midX
            }
        })
        .onTapGesture {
            activeTab = tab
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                position.x = tabPosition.x
            }
        }
        
    }
}

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

// Custom View Extension
// Which will return View Position

struct PositionKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

extension View {
    @ViewBuilder
    func viewPosition(completion: @escaping (CGRect) -> ()) -> some View {
        self
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Color.clear
                        .preference(key: PositionKey.self, value: rect)
                        .onPreferenceChange(PositionKey.self, perform: completion)
                }
            }
    }
}


#Preview {
    ContentView(colorScheme: ColorSchemeModel())
}
