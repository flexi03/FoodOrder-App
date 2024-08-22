//
//  ContentView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.09.23.
//

import SwiftUI

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

func resetOptions() {
    print("Reset")
    let settings = Settings()
    settings.optionCategories = [
        "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
        "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
        "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0],
        "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0, "Milchreis": 0, "Grieß": 0],
        "tea": ["Nichts": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0],
        "coffee": ["Nichts": 0, "Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0],
        "fruit": ["Nichts": 0, "Apfel": 0, "Banane": 0, "Birne": 0, "Apfel & Banane": 0, "Apfel & Birne": 0, "Banane & Birne": 0, "Alles": 0],
        "extras": ["Zucker": 0, "Süßstoff": 0, "Zitrone": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Gewürzgurke": 0, "Gurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0, "Kakao": 0]
    ]
}

struct ContentView: View {
    @StateObject var settings = Settings()
    @State private var activeTab: Tab = .order
    @ObservedObject var colorScheme: ColorSchemeModel
    @Namespace private var animation
    @State private var tabShapePosition: CGPoint = .zero
        
    var body: some View {
        TabView(selection: $activeTab) {
            NavigationView {
                OrderFormView2(settings: settings, patientSelection: patientSelectionManager())
            }
            .tabItem {
                Label("Bestellung", systemImage: "cart.badge.plus")
            }
            .tag(Tab.order)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationView {
                WorkingTimeView()
            }
            .tabItem {
                Label("Arbeitszeit", systemImage: "clock.arrow.circlepath")
            }
            .tag(Tab.workingtime)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationView {
                SettingsView(colorScheme: colorScheme, settings: settings)
            }
            .tabItem {
                Label("Einstellungen", systemImage: "gear.badge")
            }
            .tag(Tab.settings)
            .toolbar(.hidden, for: .tabBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(getColorScheme())
        .overlay(CustomTabBar(), alignment: .bottom)
        .tint(Color.accentColor)
    }
    
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
    
    // MARK: Custom Tab Bar
    @ViewBuilder
    func CustomTabBar(_ tint: Color = .accentColor, _ inactiveTint: Color = .accentColor) -> some View {
        HStack(alignment: .bottom ,spacing: 0) {
            ForEach(Tab.allCases, id: \.rawValue) {
                TabItem(tint: tint,
                        inactiveTint: inactiveTint,
                        tab: $0,
                        animation: animation,
                        cornerRadius: CGSize(width: 20, height: 20),
                        activeTab: $activeTab,
                        position: $tabShapePosition)
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

@main
struct OrderApp: App {
    @StateObject var settings = Settings()
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                SplashView(isFirstLaunch: $isFirstLaunch)
            } else {
                ContentView(colorScheme: ColorSchemeModel())
                    .environmentObject(settings)
            }
        }
    }
}

// Preview
#Preview {
    ContentView(colorScheme: ColorSchemeModel())
        .environmentObject(Settings())
}
