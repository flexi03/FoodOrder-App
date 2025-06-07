//
//  SettingsModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.12.23.
//

import SwiftUI

public class Settings: ObservableObject {
    
    // MARK: - Layout Settings (Vereinfacht)
    /// Enum für Layout-Modi
    public enum LayoutMode: String, CaseIterable {
        case automatic = "automatic"  // Basierend auf Gerät
        case forceiPhone = "iPhone"   // Immer iPhone Layout
        case forceiPad = "iPad"       // Immer iPad Layout
        
        var displayName: String {
            switch self {
            case .automatic:
                return "Automatisch"
            case .forceiPhone:
                return "iPhone Layout"
            case .forceiPad:
                return "iPad Layout"
            }
        }
    }
    
    @Published var layoutMode: LayoutMode {
        didSet {
            UserDefaults.standard.set(layoutMode.rawValue, forKey: "layoutMode")
            // Haptic Feedback für bessere UX
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
    
    // MARK: - Computed Properties für Layout
    /// Bestimmt ob iPhone Layout erzwungen werden soll
    var forceiPhoneLayout: Bool {
        return layoutMode == .forceiPhone
    }
    
    /// Bestimmt ob iPad Layout erzwungen werden soll
    var forceiPadLayout: Bool {
        return layoutMode == .forceiPad
    }
    
    // MARK: - Andere Einstellungen (unverändert)
    @Published var toggleSummary: Bool {
        didSet { UserDefaults.standard.set(toggleSummary, forKey: "toggleSummary") }
    }
    
    @Published var showRestrictions: Bool {
        didSet { UserDefaults.standard.set(showRestrictions, forKey: "showRestrictions") }
    }
    
    @Published var coffeeSelected: Bool {
        didSet { UserDefaults.standard.set(coffeeSelected, forKey: "Kaffee") }
    }
    
    @Published var NewTabBarSelection: Bool {
        didSet { UserDefaults.standard.set(NewTabBarSelection, forKey: "NewTabBarSelection") }
    }
    
    @Published var RainbowMode: Bool {
        didSet { UserDefaults.standard.set(RainbowMode, forKey: "RainbowMode") }
    }
    
    @Published var optionCategories: [String: [String: Int]] {
        didSet { saveOptionCategories() }
    }
    
    @Published var privateOptionCategories: [String: [String: Int]] {
        didSet { savePrivateOptionCategories() }
    }
    
    // Neue Properties für die Sortierreihenfolge
    @Published var optionOrder: [String: [String]] {
        didSet { saveOptionOrder() }
    }
    
    @Published var privateOptionOrder: [String: [String]] {
        didSet { savePrivateOptionOrder() }
    }
    
    @Published var isPrivatePatient: Bool {
        didSet { UserDefaults.standard.set(isPrivatePatient, forKey: "isPrivatePatient") }
    }
    
    @Published var showPatientTypePicker: Bool {
        didSet {
            UserDefaults.standard.set(showPatientTypePicker, forKey: "showPatientTypePicker")
        }
    }
    
    @Published var numberOfPatients: Int {
        didSet { UserDefaults.standard.set(numberOfPatients, forKey: "numberOfPatients") }
    }
    
    @Published var restrictions: [Int: String] = [:]
    @Published var breadCounts: [Int: [String: Int]] = [:]
    @Published var spreadsCounts: [Int: [String: Int]] = [:]
    @Published var spreadsCounts2: [Int: [String: Int]] = [:]
    @Published var specialsCounts: [Int: [String: Int]] = [:]
    @Published var teaQuantities: [Int: [String: Int]] = [:]
    @Published var coffeeQuantities: [Int: [String: Int]] = [:]
    @Published var fruitQuantities: [Int: [String: Int]] = [:]
    @Published var drinkSelections: [Int: String] = [:]
    @Published var extrasCounts: [Int: [String: Int]] = [:]
    @Published var extras: [Int: String] = [:]
    
    init() {
        // Layout Mode laden (mit Migration von alten Werten)
        let savedLayoutMode = UserDefaults.standard.string(forKey: "layoutMode") ?? LayoutMode.automatic.rawValue
        self.layoutMode = LayoutMode(rawValue: savedLayoutMode) ?? .automatic
        
        // Restliche Einstellungen laden
        self.toggleSummary = UserDefaults.standard.bool(forKey: "toggleSummary") || false
        self.showRestrictions = UserDefaults.standard.bool(forKey: "showRestrictions") || true
        self.coffeeSelected = UserDefaults.standard.bool(forKey: "Kaffee") || true
        self.showPatientTypePicker = UserDefaults.standard.bool(forKey: "showPatientTypePicker") || false
        self.NewTabBarSelection = UserDefaults.standard.bool(forKey: "NewTabBarSelection") || true
        self.RainbowMode = UserDefaults.standard.bool(forKey: "RainbowMode") || true
        
        self.optionCategories = UserDefaults.standard.dictionary(forKey: "optionCategories") as? [String:[String:Int]] ?? [
            "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
            "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
            "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0],
            "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0, "Milchreis": 0, "Grieß": 0],
            "tea": ["Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0],
            "coffee": ["Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
            "fruit": ["Apfel": 0, "Banane": 0, "Birne": 0],
            "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0]
        ]
        
        self.privateOptionCategories = UserDefaults.standard.dictionary(forKey: "privateOptionCategories") as? [String:[String:Int]] ?? [
            "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
            "preordered": ["Lachs": 0, "Tomate-Mozarella": 0, "Rohkostteller": 0],
            "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Gouda": 0, "Edamer": 0, "Leerdamer": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
            "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nutella": 0],
            "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0,  "Milchreis": 0, "Grieß": 0, "Müsli": 0],
            "tea": ["Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Hagebutte": 0, "Fenchel": 0, "Pfefferminz": 0, "Earl Grey": 0],
            "coffee": ["Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
            "fruit": ["Apfel": 0, "Banane": 0, "Birne": 0],
            "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0]
        ]
        
        self.isPrivatePatient = UserDefaults.standard.bool(forKey: "isPrivatePatient") || false
        self.optionOrder = UserDefaults.standard.object(forKey: "optionOrder") as? [String: [String]] ?? [:]
        self.privateOptionOrder = UserDefaults.standard.object(forKey: "privateOptionOrder") as? [String: [String]] ?? [:]
        
        self.numberOfPatients = UserDefaults.standard.integer(forKey: "numberOfPatients")
        if self.numberOfPatients == 0 {
            self.numberOfPatients = 4
        }
        
        // Migration: Alte Boolean-Werte in neuen Enum konvertieren
        if UserDefaults.standard.object(forKey: "layoutMode") == nil {
            let oldForceiPhone = UserDefaults.standard.bool(forKey: "forceiPhoneLayout")
            let oldForceiPad = UserDefaults.standard.bool(forKey: "forceiPadLayout")
            
            if oldForceiPhone {
                self.layoutMode = .forceiPhone
            } else if oldForceiPad {
                self.layoutMode = .forceiPad
            } else {
                self.layoutMode = .automatic
            }
            
            // Alte Werte löschen
            UserDefaults.standard.removeObject(forKey: "forceiPhoneLayout")
            UserDefaults.standard.removeObject(forKey: "forceiPadLayout")
            
            // Neuen Wert speichern
            UserDefaults.standard.set(self.layoutMode.rawValue, forKey: "layoutMode")
        }
        
        
        
        loadOptionCategories()
        loadPrivateOptionCategories()
        loadOptionOrder()
        loadPrivateOptionOrder()
        
        // Initialisiere die Sortierreihenfolge, falls sie noch nicht existiert
        for (category, options) in optionCategories {
            if optionOrder[category] == nil {
                optionOrder[category] = Array(options.keys)
            }
        }
        
        for (category, options) in privateOptionCategories {
            if privateOptionOrder[category] == nil {
                privateOptionOrder[category] = Array(options.keys)
            }
        }
        
        loadSelections()
    }
    
    // MARK: - Hilfsfunktionen
    func saveOptionCategories() {
        let encodedData = try? JSONEncoder().encode(optionCategories)
        UserDefaults.standard.set(encodedData, forKey: "optionCategories")
    }
    
    private func loadOptionCategories() {
        if let savedCategories = UserDefaults.standard.data(forKey: "optionCategories"),
           let decodedCategories = try? JSONDecoder().decode([String: [String: Int]].self, from: savedCategories) {
            optionCategories = decodedCategories
        }
    }
    
    func saveSelections() {
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        func saveData<T: Encodable>(_ data: T, forKey key: String) {
            if let encodedData = try? encoder.encode(data) {
                defaults.set(encodedData, forKey: key)
            }
        }
        
        saveData(restrictions, forKey: "restrictions")
        saveData(breadCounts, forKey: "breadCounts")
        saveData(spreadsCounts, forKey: "spreadsCounts")
        saveData(spreadsCounts2, forKey: "spreadsCounts2")
        saveData(specialsCounts, forKey: "specialsCounts")
        saveData(teaQuantities, forKey: "teaQuantities")
        saveData(coffeeQuantities, forKey: "coffeeQuantities")
        saveData(fruitQuantities, forKey: "fruitQuantities")
        saveData(drinkSelections, forKey: "drinkSelections")
        saveData(extrasCounts, forKey: "extrasCounts")
        saveData(extras, forKey: "extras")
    }
    
    func loadSelections() {
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard
        
        func loadData<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
            guard let data = defaults.data(forKey: key) else { return nil }
            return try? decoder.decode(T.self, from: data)
        }
        
        restrictions = loadData([Int: String].self, forKey: "restrictions") ?? [:]
        breadCounts = loadData([Int: [String: Int]].self, forKey: "breadCounts") ?? [:]
        spreadsCounts = loadData([Int: [String: Int]].self, forKey: "spreadsCounts") ?? [:]
        spreadsCounts2 = loadData([Int: [String: Int]].self, forKey: "spreadsCounts2") ?? [:]
        specialsCounts = loadData([Int: [String: Int]].self, forKey: "specialsCounts") ?? [:]
        teaQuantities = loadData([Int: [String: Int]].self, forKey: "teaQuantities") ?? [:]
        coffeeQuantities = loadData([Int: [String: Int]].self, forKey: "coffeeQuantities") ?? [:]
        fruitQuantities = loadData([Int: [String: Int]].self, forKey: "fruitQuantities") ?? [:]
        drinkSelections = loadData([Int: String].self, forKey: "drinkSelections") ?? [:]
        extrasCounts = loadData([Int: [String: Int]].self, forKey: "extrasCounts") ?? [:]
        extras = loadData([Int: String].self, forKey: "extras") ?? [:]
    }
    
    func resetSelections(for patientNumber: Int) {
        restrictions[patientNumber] = nil
        breadCounts[patientNumber] = [:]
        spreadsCounts[patientNumber] = [:]
        spreadsCounts2[patientNumber] = [:]
        specialsCounts[patientNumber] = [:]
        teaQuantities[patientNumber] = [:]
        coffeeQuantities[patientNumber] = [:]
        fruitQuantities[patientNumber] = [:]
        drinkSelections[patientNumber] = nil
        extrasCounts[patientNumber] = [:]
        extras[patientNumber] = nil
        
        saveSelections()
    }
    
    func resetAllSelections() {
        restrictions = [:]
        breadCounts = [:]
        spreadsCounts = [:]
        spreadsCounts2 = [:]
        specialsCounts = [:]
        teaQuantities = [:]
        coffeeQuantities = [:]
        fruitQuantities = [:]
        drinkSelections = [:]
        extrasCounts = [:]
        extras = [:]
        
        saveSelections()
        
        ToastManager.shared.showSuccess("Alle Bestellungen wurden zurückgesetzt!")

    }
    
    func validateSelections() -> Bool {
        for patientNumber in 1...numberOfPatients {
            if !breadCounts[patientNumber].isNilOrEmpty ||
                !spreadsCounts[patientNumber].isNilOrEmpty ||
                !spreadsCounts2[patientNumber].isNilOrEmpty ||
                !specialsCounts[patientNumber].isNilOrEmpty ||
                !teaQuantities[patientNumber].isNilOrEmpty ||
                !coffeeQuantities[patientNumber].isNilOrEmpty ||
                !fruitQuantities[patientNumber].isNilOrEmpty ||
                !extrasCounts[patientNumber].isNilOrEmpty ||
                !(extras[patientNumber] ?? "").isEmpty {
                return true
            }
        }
        return false
    }
    
    private func savePrivateOptionCategories() {
        let encodedData = try? JSONEncoder().encode(privateOptionCategories)
        UserDefaults.standard.set(encodedData, forKey: "privateOptionCategories")
    }
    
    private func loadPrivateOptionCategories() {
        if let savedCategories = UserDefaults.standard.data(forKey: "privateOptionCategories"),
           let decodedCategories = try? JSONDecoder().decode([String: [String: Int]].self, from: savedCategories) {
            privateOptionCategories = decodedCategories
        }
    }
    
    func saveOptionOrder() {
        UserDefaults.standard.set(optionOrder, forKey: "optionOrder")
    }
    
    func savePrivateOptionOrder() {
        UserDefaults.standard.set(privateOptionOrder, forKey: "privateOptionOrder")
    }
    
    private func loadOptionOrder() {
        if let savedOrder = UserDefaults.standard.object(forKey: "optionOrder") as? [String: [String]] {
            optionOrder = savedOrder
        }
    }
    
    private func loadPrivateOptionOrder() {
        if let savedOrder = UserDefaults.standard.object(forKey: "privateOptionOrder") as? [String: [String]] {
            privateOptionOrder = savedOrder
        }
    }
    
    // Neue Methode zum Abrufen sortierter Optionen
    func getSortedOptions(for category: String, isPrivate: Bool) -> [(String, Int)] {
        let options = isPrivate ? privateOptionCategories[category] ?? [:] : optionCategories[category] ?? [:]
        let order = isPrivate ? privateOptionOrder[category] ?? [] : optionOrder[category] ?? []
        
        return order.compactMap { key in
            guard let value = options[key] else { return nil }
            return (key, value)
        }
    }
    
    // Neue Methode zum Aktualisieren der Sortierreihenfolge
    func updateOptionOrder(for category: String, isPrivate: Bool, newOrder: [String]) {
        if isPrivate {
            privateOptionOrder[category] = newOrder
            savePrivateOptionOrder()
        } else {
            optionOrder[category] = newOrder
            saveOptionOrder()
        }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public class ColorSchemeModel: ObservableObject {
    @AppStorage("selectedColorMode") var mode: String = "Dunkel"
}
