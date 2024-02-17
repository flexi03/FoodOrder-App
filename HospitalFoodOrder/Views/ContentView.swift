//
//  ContentView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.09.23.
//

import SwiftUI
//import UIKit
//import Lottie

public class patientSelectionManager: ObservableObject {
    @Published var patientSelection: String = "P1" {
        didSet {
            UserDefaults.standard.set(patientSelection, forKey: "patientSelection")
        }
    }
    init() {
        self.patientSelection = UserDefaults.standard.object(forKey: "patientSelection") as? String ?? "P1"
    }
    @Published var foodIntolerance1: String = "WK1"
    @Published var foodIntolerance2: String = "WK2"
    @Published var foodIntolerance3: String = "WK3"
    @Published var foodIntolerance4: String = "WK4"
}

func resetOptions() {

    print("Reset")
        
    Settings.init().breadOptions.replace(Settings.init().breadOptions, with: ["Weizen", "Grau", "Körner", "Brötchen"])
    
    Settings.init().spreadsOptions.replace(Settings.init().spreadsOptions, with: ["Butter", "Margarine", "Käse", "Pute", "Fleischwurst", "Schinken", "Salami"])
    
    Settings.init().spreadsOptions2.replace(Settings.init().spreadsOptions2, with: ["Frischkäse Natur", "Frischkäse Kräuter", "Quark", "Schmelzkäse", "Leberwurst", "Mettwurst", "Marmelade", "Honig"])
    
    Settings.init().specialsOptions.replace(Settings.init().specialsOptions, with: ["Frucht Joghurt", "Natur Joghurt", "Grießpudding", "Milchreis", "Brühe" , "Brühe vegetarisch"])
    
    Settings.init().teaOptions.replace(Settings.init().teaOptions, with: ["Nichts", "Kamille", "Kräuter/ Grüner Tee", "Schwarzer Tee", "Früchte Tee", "Fenchel", "Pfefferminz"])
    
    Settings.init().coffeeOptions.replace(Settings.init().coffeeOptions, with: ["Nichts", "Kaffee", "Kaffee mit Milch", "Kaffee mit Zucker", "Kaffee mit Milch und Zucker"])
    
    Settings.init().fruitOptions.replace(Settings.init().fruitOptions, with: ["Nichts", "Apfel", "Banane", "Birne"])
    
    Settings.init().extrasOptions.replace(Settings.init().extrasOptions, with: ["Zucker", "Süßstoff", "Milch", "Salz", "Pfeffer", "Gurke", "Tomate", "Suppe"])
    
//    exit(0)
}


struct ContentView: View {
    
//    @State var selection = 1
    
    @State private var activeTab: Tab = .order
    
    @ObservedObject var colorScheme: ColorSchemeModel
    
    @Namespace private var animation
    
    @State private var tabShapePosition: CGPoint = .zero
    
    @AppStorage("showWorkingTime") var showWorkingTime: Bool = true
    
    var body: some View {
        TabView(selection: $activeTab) {
            
            NavigationView {
                OrderFormView(settings: Settings(), patientSelection: patientSelectionManager())
            }
            .tabItem {
                Label("Bestellung", systemImage: "cart.badge.plus")
            }
            .tag(Tab.order)
            .toolbar(.hidden, for: .tabBar)
            
            if showWorkingTime == true {
                NavigationView {
                    WorkingTimeView()
                }
                .tabItem {
                    Label("Arbeitszeit", systemImage: "clock.arrow.circlepath")
                }
                .tag(Tab.workingtime)
                .toolbar(.hidden, for: .tabBar)
            }
                    
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
        .colorScheme(getColorScheme())
//        .preferredColorScheme(getColorScheme())
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
    
    // Custom Tab Bar
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
//        .onChange(of: activeTab) { _ in
//            let generator = UINotificationFeedbackGenerator()
//            generator.notificationOccurred(.success)
//        }
    }
}


@main
struct OrderApp: App {
    @ObservedObject var settings = Settings()
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
        var body: some Scene {
            WindowGroup {
                if isFirstLaunch {
                    // Zeige den Splashscreen
                    SplashView(isFirstLaunch: $isFirstLaunch)
                } else {
                    // Zeige den Hauptinhalt der App
                    ContentView(colorScheme: ColorSchemeModel())
                }
            }
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
////            LottieView(url: Bundle.main.url(forResource: "foodAnimation", withExtension: "lottie")!)
//        }
    }
}

// Preview
#Preview() {
    ContentView(colorScheme: ColorSchemeModel())
}

