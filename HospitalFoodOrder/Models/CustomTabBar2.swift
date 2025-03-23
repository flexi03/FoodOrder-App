//
//  CustomTabBar2.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 03.09.24.
//

import SwiftUI

// MARK: Custom Tab Bar 2
struct CustomTabBar2: View {
    var activeForegroundColor: Color = .white
    var activeBackgroundColor: Color = .accentColor
    var useAnimatedOverlay: Bool
    
    @Binding var activeTab: Tab
    @Namespace var animation
    
    @ObservedObject var settings: Settings
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button {
                    activeTab = tab
                } label: {
                    HStack(spacing: 5) {
                        Image(systemName: tab.systemImage)
                            .font(.title3)
                            .frame(width: 50, height: 50)
                            
                        if tab == activeTab {
                            Text(tab.rawValue)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .lineLimit(1)
                        }
                    }
                    .foregroundColor(activeTab == tab ? activeForegroundColor : .white)
                    .padding(.vertical, 4)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .background {
                        if activeTab == tab {
                            Capsule()
                                .fill(activeBackgroundColor.gradient)
                                .blur(radius: 2)
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .onChange(of: activeTab) { _ in
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 5)
        .frame(height: 65)
        .background(
            Group {
                if useAnimatedOverlay {
                    ZStack { // Stack two for more blur and less distortion on the inside
                        AnimatedColorWheelOverlay()
                            .mask(
                                Capsule()
                            )
                            .blur(radius: 12)
                        
                        AnimatedColorWheelOverlay()
                            .mask(
                                Capsule()
                            )
                            .blur(radius: 20)
                    }
                    
                } else {
                    Color.clear // or any other background you want when not using the animated overlay
                }
            }
        )
        .background(.ultraThinMaterial, in: Capsule())
        .background(
            .background
                .shadow(.drop(color: .gray.opacity(0.4),radius: 5, x: 5, y: 5))
                .shadow(.drop(color: .gray.opacity(0.3),radius: 5, x: -5, y: -5)),
            in: .capsule
        )
        .animation(.smooth(duration: 0.2, extraBounce: 0), value: activeTab)
    }
}

#Preview {
    ContentView(colorScheme: ColorSchemeModel())
}
