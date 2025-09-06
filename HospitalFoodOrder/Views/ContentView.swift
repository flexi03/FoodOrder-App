//
//  ContentView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.09.23.
//

import SwiftUI

/// Main content view that manages the app's tab-based navigation and appearance
/// Handles patient selection, settings, and working time tracking
struct ContentView: View {
    // MARK: - Properties
	@StateObject var settings = Settings()
    @State private var activeTab: Tab = .order
    @ObservedObject var colorScheme: ColorSchemeModel
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    // MARK: - Computed Properties
    /// Determines which layout to use based on device and settings
    private var shouldUseiPadLayout: Bool {
        let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        
        // Wenn force iPad Layout aktiviert ist, immer iPad Layout verwenden
        if settings.forceiPadLayout {
            return true
        }
        
        // Wenn force iPhone Layout aktiviert ist, immer iPhone Layout verwenden
        if settings.forceiPhoneLayout {
            return false
        }
        
        // Ansonsten basierend auf Gerät entscheiden
        return isiPad
    }
    
    // MARK: - Body
    var body: some View {
        Group {
            if shouldUseiPadLayout {
                iPadContentView(colorScheme: colorScheme, patientSelection: patientSelectionManager())
                    .environmentObject(settings)
            } else {
                iPhoneContentView(colorScheme: colorScheme)
                    .environmentObject(settings)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: shouldUseiPadLayout)
    }
}

/// iPhone-specific content view
struct iPhoneContentView: View {
    @EnvironmentObject var settings: Settings
    @State private var activeTab: Tab = .order
    @ObservedObject var colorScheme: ColorSchemeModel
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
    
    var body: some View {
        TabView(selection: $activeTab) {
            // Order Form Tab
            OrderFormView(settings: settings, patientSelection: patientSelectionManager())
                .tabItem {
                    Label("Bestellung", systemImage: "cart.badge.plus")
                }
                .tag(Tab.order)
				.toolbar(settings.NewTabBarSelection ? .hidden : .visible, for: .tabBar)
                .accessibilityLabel("Bestellungen aufnehmen")
                .accessibilityHint("Tippen Sie hier, um Essensbestellungen aufzunehmen")
            
//            // Working Time Tab
//            NavigationStack {
//                WorkingTimeView()
//            }
//            .tabItem {
//                Label("Arbeitszeit", systemImage: "clock.arrow.circlepath")
//            }
//            .tag(Tab.workingtime)
//			.toolbar(settings.NewTabBarSelection ? .hidden : .visible, for: .tabBar)
//			.accessibilityLabel("Arbeitszeit erfassen")
//                .accessibilityHint("Tippen Sie hier, um Ihre Arbeitszeiten zu erfassen und zu verwalten")
            
            // Settings Tab
            NavigationStack {
                SettingsView(colorScheme: colorScheme, settings: settings)
            }
            .tabItem {
                Label("Einstellungen", systemImage: "gear.badge")
            }
            .tag(Tab.settings)
			.toolbar(settings.NewTabBarSelection ? .hidden : .visible, for: .tabBar)
                .accessibilityLabel("Einstellungen")
                .accessibilityHint("Tippen Sie hier, um App-Einstellungen anzupassen")
        }
//        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(getColorScheme())
        .safeAreaInset(edge: .bottom) {
            if settings.NewTabBarSelection {
                CustomTabBar2(
                    useAnimatedOverlay: settings.RainbowMode,
                    activeTab: $activeTab,
                    settings: Settings()
                )
            } else {
//                CustomTabBar()
            }
        }
        .tint(Color.accentColor)
    }
    
    /// Returns the appropriate color scheme based on user settings
    private func getColorScheme() -> ColorScheme {
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
    private func CustomTabBar(_ tint: Color = .accentColor, _ inactiveTint: Color = .accentColor) -> some View {
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

// MARK: - Patient Selection Manager
/// Manages the currently selected patient and persists the selection
public class patientSelectionManager: ObservableObject {
    @Published var patientSelection: Int = 1 {
        didSet {
            UserDefaults.standard.set(patientSelection, forKey: "patientSelection")
        }
    }
    
    init() {
        self.patientSelection = UserDefaults.standard.object(forKey: "patientSelection") as? Int ?? 1
    }
}

@main
struct OrderApp: App {
    @StateObject var settings = Settings()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                SplashView(isFirstLaunch: $isFirstLaunch)
                    .withToasts()
            } else {
                ContentView(colorScheme: ColorSchemeModel())
                    .environmentObject(settings)
                    .withToasts()
//                    .presentPaywallIfNeeded(
//                        requiredEntitlementIdentifier: "ofrnge907150907",
//                        purchaseCompleted: { customerInfo in
//                            print("Purchase completed: \(customerInfo.entitlements)")
//                        },
//                        restoreCompleted: { customerInfo in
//                            // Paywall will be dismissed automatically if the entitlement is now active.
//                            print("Purchases restored: \(customerInfo.entitlements)")
//                        }
//                    )
            }
        }
    }
}

// Preview
#Preview {
    ContentView(colorScheme: ColorSchemeModel())
        .environmentObject(Settings())
}

/// Resets all food options to their default values
func resetOptions() {
    print("Resetting options to defaults")
    let settings = Settings()
    
    // Define default food categories and options
    settings.optionCategories = [
		"bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
		"spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
		"spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Honig": 0, "Marmelade": 0, "Leberwurst": 0, "Schinkencreme": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0],
		"specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Milchreis": 0, "Grieß": 0, "Brühe": 0, "Brühe vegetarisch": 0, "Brotaufstrich Hering" : 0, "Brotaufstrich Geflügel" : 0, "Brotaufstrich Eiersalat" : 0],
		"tea": ["Pfefferminz": 0, "Früchte Tee": 0, "Fenchel": 0, "Schwarzer Tee": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0],
		"coffee": ["Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
		"fruit": ["Apfel": 0, "Banane": 0, "Birne": 0],
		"extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Suppe": 0, "Salatgurke": 0, "Gewürzgurke": 0, "Tomate": 0, "Gemüse": 0, "Salat" : 0]
    ]
}
