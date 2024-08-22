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
    
    @Published var optionCategories: [String: [String: Int]] {
        didSet { saveOptionCategories() }
    }

    @Published var privateOptionCategories: [String: [String: Int]] {
        didSet { savePrivateOptionCategories() }
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
        self.showRestrictions = UserDefaults.standard.bool(forKey: "showRestrictions")
        self.coffeeSelected = UserDefaults.standard.bool(forKey: "Kaffee")
        self.showPatientTypePicker = UserDefaults.standard.bool(forKey: "showPatientTypePicker")
        
        self.optionCategories = [
                    "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
                    "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
                    "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0],
                    "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0, "Milchreis": 0, "Grieß": 0],
                    "tea": ["Nichts": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0],
                    "coffee": ["Nichts": 0, "Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
                    "fruit": ["Nichts": 0, "Apfel": 0, "Banane": 0, "Birne": 0],
                    "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0]
                ]
        
        self.privateOptionCategories = [
            "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0, "Ciabatta": 0, "Vollkornbrot": 0],
            "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0, "Lachs": 0],
            "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0, "Hummus": 0],
            "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0,  "Milchreis": 0, "Grieß": 0, "Müsli": 0],
            "tea": ["Nichts": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0, "Earl Grey": 0],
            "coffee": ["Nichts": 0, "Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0, "Espresso": 0, "Cappuccino": 0],
            "fruit": ["Nichts": 0, "Apfel": 0, "Banane": 0, "Birne": 0, "Orange": 0, "Trauben": 0],
            "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0, "Obstsalat": 0]
        ]

        self.isPrivatePatient = UserDefaults.standard.bool(forKey: "isPrivatePatient")
        
        
        self.numberOfPatients = UserDefaults.standard.integer(forKey: "numberOfPatients")
        if self.numberOfPatients == 0 {
            self.numberOfPatients = 4
        }
        
        loadPrivateOptionCategories()
        loadOptionCategories()
        loadSelections()
    }
    
    private func saveOptionCategories() {
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
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}

public class ColorSchemeModel: ObservableObject {
    @AppStorage("selectedColorMode") var mode: String = "Dunkel"
}
