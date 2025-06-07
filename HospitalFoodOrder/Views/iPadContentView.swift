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
    @ObservedObject var patientSelection: patientSelectionManager
    
    // MARK: - Body
    var body: some View {
        NavigationView {
            // Order Form Tab
            ZStack {
                OrderFormViewIPad(settings: settings, patientSelection: patientSelectionManager())
                
                if patientSelection.patientSelection >= 2 {
                    FloatingButton(systemImage: "arrow.left", action: {
                        patientSelection.patientSelection-=1
                    }, alignment: .bottomLeading)
                }
                
                if patientSelection.patientSelection < settings.numberOfPatients {
                    FloatingButton(systemImage:"arrow.right", action: {
                        patientSelection.patientSelection+=1
                    }, alignment: .bottomTrailing)
                }
            }
            .preferredColorScheme(getColorScheme())
        }
        .navigationViewStyle(.stack)
    }
    
    // MARK: - Helper Functions
    private func createResetActionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = (1...settings.numberOfPatients).map { patientNumber in
            .default(Text("Bestellung \(patientNumber)")) {
                settings.resetSelections(for: patientNumber)
                triggerHapticFeedback(.rigid)
            }
        }
        buttons.append(.default(Text("Für Später Bestellung")) {
            settings.resetSelections(for: 101)
        })
        
        buttons.append(.default(Text("Alle Bestellungen")) {
            settings.resetAllSelections()
            patientSelection.patientSelection = 1
            settings.toggleSummary = false
            triggerHapticFeedback(.heavy)
        })
        buttons.append(.cancel(Text("Abbrechen")))
        
        return ActionSheet(title: Text("Welche Bestellung möchtest Du zurücksetzen?"), buttons: buttons)
    }
    
    private func triggerHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
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

func FloatingButton(systemImage: String, action: @escaping () -> Void, alignment: Alignment) -> some View {
    return VStack {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 32)) // Größere Icons für iPad
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(width: 120, height: 120) // Größere Buttons für iPad
                .background(.accent)
                .clipShape(Circle())
                .shadow(radius: 6, y: 3) // Stärkerer Schatten für bessere Sichtbarkeit
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    .padding(.horizontal, 40) // Mehr Padding für bessere Erreichbarkeit
    .padding(.vertical, 40)
}
