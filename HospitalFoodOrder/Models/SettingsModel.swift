//
//  SettingsModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.12.23.
//

import SwiftUI

public class Settings: ObservableObject {
    @Published var showRestrictions: Bool {
        didSet { UserDefaults.standard.set(showRestrictions, forKey: "showRestrictions") }
    }
    @Published var coffeeSelected: Bool {
        didSet { UserDefaults.standard.set(coffeeSelected, forKey: "Kaffee") }
    }
    
    @Published var optionCategories: [String: [String]] {
        didSet { saveOptionCategories() }
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
        self.showRestrictions = UserDefaults.standard.bool(forKey: "showRestrictions")
        self.coffeeSelected = UserDefaults.standard.bool(forKey: "Kaffee")
        
        self.optionCategories = [
            "bread": ["Weizen", "Grau", "Körner", "Brötchen Normal", "Brötchen Grau", "Brötchen Körner"],
            "spreads": ["Butter", "Margarine", "Käse", "Pute", "Fleischwurst", "Schinken", "Salami"],
            "spreads2": ["Frischkäse Natur", "Frischkäse Kräuter", "Quark", "Schmelzkäse", "Schmelzkäse Pikant", "Leberwurst", "Schinkencreme", "Marmelade", "Honig", "Vegetarischer Aufstrich Tomate", "Vegetarischer Aufstrich Kräuter", "Nuss-Nougat Creme"],
            "specials": ["Frucht Joghurt", "Natur Joghurt", "Brühe", "Brühe vegetarisch",  "Milchreis", "Grieß"],
            "tea": ["Nichts", "Kamille", "Kräuter/ Grüner Tee", "Schwarzer Tee", "Früchte Tee", "Fenchel", "Pfefferminz"],
            "coffee": ["Nichts", "Kaffee", "Kaffee mit Milch", "Kaffee mit Zucker", "Kaffee mit Milch und Zucker", "Kakao"],
            "fruit": ["Nichts", "Apfel", "Banane", "Birne"],
            "extras": ["Zucker", "Süßstoff", "Milch", "Salz", "Pfeffer", "Zitrone", "Gewürzgurke", "Salatgurke", "Tomate", "Suppe", "Gemüse"]
        ]
        
        self.numberOfPatients = UserDefaults.standard.integer(forKey: "numberOfPatients")
        if self.numberOfPatients == 0 {
            self.numberOfPatients = 4
        }
        
        loadOptionCategories()
        loadSelections()
    }
    
    private func saveOptionCategories() {
        let encodedData = try? JSONEncoder().encode(optionCategories)
        UserDefaults.standard.set(encodedData, forKey: "optionCategories")
    }
    
    private func loadOptionCategories() {
        if let savedCategories = UserDefaults.standard.data(forKey: "optionCategories"),
           let decodedCategories = try? JSONDecoder().decode([String: [String]].self, from: savedCategories) {
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
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public class ColorSchemeModel: ObservableObject {
    @AppStorage("selectedColorMode") var mode: String = "Dunkel"
}
