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
    settings.optionCategories["bread"] = ["Weizen", "Grau", "Körner", "Brötchen Normal", "Brötchen Grau", "Brötchen Körner"]
    settings.optionCategories["spreads"] = ["Butter", "Margarine", "Käse", "Pute", "Fleischwurst", "Schinken", "Salami"]
    settings.optionCategories["spreads2"] = ["Frischkäse Natur", "Frischkäse Kräuter", "Quark", "Schmelzkäse", "Schmelzkäse Pikant", "Leberwurst", "Schinkencreme", "Marmelade", "Honig", "Vegetarischer Aufstrich Tomate", "Vegetarischer Aufstrich Kräuter", "Nuss-Nougat Creme"]
    settings.optionCategories["specials"] = ["Frucht Joghurt", "Natur Joghurt", "Brühe", "Brühe vegetarisch",  "Milchreis", "Grieß"]
    settings.optionCategories["tea"] = ["Nichts", "Kamille", "Kräuter/ Grüner Tee", "Schwarzer Tee", "Früchte Tee", "Fenchel", "Pfefferminz"]
    settings.optionCategories["coffee"] = ["Nichts", "Kaffee", "Kaffee mit Milch", "Kaffee mit Zucker", "Kaffee mit Milch und Zucker"]
    settings.optionCategories["fruit"] = ["Nichts", "Apfel", "Banane", "Birne", "Apfel & Banane", "Apfel & Birne", "Banane & Birne", "Alles"]
    settings.optionCategories["extras"] = ["Zucker", "Süßstoff", "Zitrone", "Milch", "Salz", "Pfeffer", "Gewürzgurke", "Gurke", "Tomate", "Suppe", "Gemüse", "Kakao"]
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
                OrderFormView2(settings: Settings(), patientSelection: patientSelectionManager())
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
                SettingsView(colorScheme: ColorSchemeModel(), settings: Settings())
            }
            .tabItem {
                Label("Einstellungen", systemImage: "gear.badge")
            }
            .tag(Tab.settings)
            .toolbar(.hidden, for: .tabBar)
        }
        .navigationViewStyle(StackNavigationViewStyle())
//        .colorScheme(getColorScheme())
        .preferredColorScheme(getColorScheme())
        .overlay(CustomTabBar(), alignment: .bottom)
        .tint(Color.accentColor)
        //                .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: Tab.allCases)
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
                        animation: animation, cornerRadius: CGSize(width: 20, height: 20),
                        activeTab: $activeTab,
                        position: $tabShapePosition)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 8)
        .background(content: {
            TabShape(midpoint: tabShapePosition.x, cornerRadius: CGSize(width: 20, height: 20))
                .fill(.background) // App Farbe hier anpassen
                .ignoresSafeArea()
                .shadow(color: tint.opacity(0.5), radius: 5, x: 0, y: -5)
                .blur(radius: 0)
                .padding(.top, 25)
        })
        .colorScheme(getColorScheme())
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7), value: activeTab)
        .frame(alignment: .bottom)
        .onChange(of: activeTab) { _ in
            // Erzeuge eine leichte Vibration
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
