//
//  iPadContentView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 06.06.25.
//

import SwiftUI

/// Main content view that manages the app's tab-based navigation and appearance
/// Handles patient selection, settings, and working time tracking
struct iPadContentView: View {
    // MARK: - Properties
    @StateObject var settings = Settings()
    @State private var activeTab: Tab = .order
    @ObservedObject var colorScheme: ColorSchemeModel
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    // MARK: - Body
    var body: some View {
        TabView(selection: $activeTab) {
            // Order Form Tab
            OrderFormView(settings: settings, patientSelection: patientSelectionManager())
                .tabItem {
                    Label("Bestellung", systemImage: "cart.badge.plus")
                }
                .tag(Tab.order)
                .toolbar(.hidden, for: .tabBar)
                .accessibilityLabel("Bestellungen aufnehmen")
                .accessibilityHint("Tippen Sie hier, um Essensbestellungen aufzunehmen")
            
            // Working Time Tab
            NavigationView {
                WorkingTimeView()
            }
            .tabItem {
                Label("Arbeitszeit", systemImage: "clock.arrow.circlepath")
            }
            .tag(Tab.workingtime)
            .toolbar(.hidden, for: .tabBar)
                .accessibilityLabel("Arbeitszeit erfassen")
                .accessibilityHint("Tippen Sie hier, um Ihre Arbeitszeiten zu erfassen und zu verwalten")
            
            // Settings Tab
            NavigationView {
                SettingsView(colorScheme: colorScheme, settings: settings)
            }
            .tabItem {
                Label("Einstellungen", systemImage: "gear.badge")
            }
            .tag(Tab.settings)
            .toolbar(.hidden, for: .tabBar)
                .accessibilityLabel("Einstellungen")
                .accessibilityHint("Tippen Sie hier, um App-Einstellungen anzupassen")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(getColorScheme())
        .safeAreaInset(edge: .bottom) {
            if settings.NewTabBarSelection {
                CustomTabBar2(
                    useAnimatedOverlay: settings.RainbowMode,
                    activeTab: $activeTab,
                    settings: Settings()
                )
            } else {
                CustomTabBar()
            }
        }
        .tint(Color.accentColor)
    }
}


// MARK: - Helper Functions
extension iPadContentView {
    /// Returns the appropriate color scheme based on user settings
    public func getColorScheme() -> ColorScheme {
        switch colorScheme.mode {
        case "Dunkel":
            return .dark
        case "Hell":
            return .light
        default:
            return .dark
        }
    }
    
    /// Creates a custom tab bar with the specified appearance
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .accentColor, _ inactiveTint: Color = .accentColor) -> some View {
        HStack(alignment: .bottom, spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(
                    tint: tint,
                    inactiveTint: inactiveTint,
                    tab: $0,
                    animation: animation,
                    cornerRadius: CGSize(width: 20, height: 20),
                    activeTab: $activeTab,
                    position: $tabShapePosition
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(content: {
            TabShape(midpoint: tabShapePosition.x, cornerRadius: CGSize(width: 20, height: 20))
                .fill(.background)
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.5), radius: 5, x: 0, y: -5)
                .blur(radius: 0)
                .padding(.top, 25)
        })
        .colorScheme(getColorScheme())
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
        .frame(alignment: .bottom)
        .onChange(of: activeTab) { _ in
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}
