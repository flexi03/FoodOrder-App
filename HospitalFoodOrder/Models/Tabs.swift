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

#Preview {
    ContentView(colorScheme: ColorSchemeModel())
}
