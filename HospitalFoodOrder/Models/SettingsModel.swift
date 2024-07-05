//
//  SettingsModel.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.12.23.
//

import SwiftUI

// Modell für Einstellungen
public class Settings: ObservableObject {
    
    // MARK: Selection Variables
    @Published var showRestrictions: Bool = true {
        didSet {
            UserDefaults.standard.set(showRestrictions, forKey: "showRestrictions")
        }
    }
    
    @Published var coffeeSelected: Bool = true {
        didSet {
            UserDefaults.standard.set(coffeeSelected, forKey: "Kaffee")
        }
    }
    
    // Einschränkungen 1-4
    @Published var restrictions1: String = "Keine" {
        didSet {
            UserDefaults.standard.set(restrictions1, forKey: "restrictions1")
        }
    }
    
    @Published var restrictions2: String = "Keine" {
        didSet {
            UserDefaults.standard.set(restrictions2, forKey: "restrictions2")
        }
    }
    
    @Published var restrictions3: String = "Keine" {
        didSet {
            UserDefaults.standard.set(restrictions3, forKey: "restrictions3")
        }
    }
    
    @Published var restrictions4: String = "Keine" {
        didSet {
            UserDefaults.standard.set(restrictions4, forKey: "restrictions4")
        }
    }
    
    // Auswahloptionen
    @Published var breadOptions: [String] {
        didSet {
            UserDefaults.standard.set(breadOptions, forKey: "breadOptions")
        }
    }
    
    @Published var spreadsOptions: [String] {
        didSet {
            UserDefaults.standard.set(spreadsOptions, forKey: "spreadsOptions")
        }
    }
    
    @Published var spreadsOptions2: [String] {
        didSet {
            UserDefaults.standard.set(spreadsOptions2, forKey: "spreadsOptions2")
        }
    }
    
    @Published var specialsOptions: [String] {
        didSet {
            UserDefaults.standard.set(specialsOptions, forKey: "specialsOptions")
        }
    }
    
    @Published var teaOptions: [String] {
        didSet {
            UserDefaults.standard.set(teaOptions, forKey: "teaOptions")
        }
    }
    
    @Published var coffeeOptions: [String] {
        didSet {
            UserDefaults.standard.set(coffeeOptions, forKey: "coffeeOptions")
        }
    }
    
    @Published var fruitOptions: [String] {
        didSet {
            UserDefaults.standard.set(fruitOptions, forKey: "fruitOptions")
        }
    }
    
    // Getränkeauswahl 1-4
    @Published var drinkSelection: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(drinkSelection, forKey: "drinkSelection")
        }
    }
    
    @Published var drinkSelection2: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(drinkSelection2, forKey: "drinkSelection2")
        }
    }
    
    @Published var drinkSelection3: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(drinkSelection3, forKey: "drinkSelection3")
        }
    }
    
    @Published var drinkSelection4: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(drinkSelection4, forKey: "drinkSelection4")
        }
    }
    
    // Extras Otionen
    @Published var extrasOptions: [String] {
        didSet {
            UserDefaults.standard.set(extrasOptions, forKey: "extrasOptions")
        }
    }
    
    // Extras 1-4
    @Published var extras: String = "" {
        didSet {
            UserDefaults.standard.set(extras, forKey: "extras")
        }
    }
    
    @Published var extras2: String = "" {
        didSet {
            UserDefaults.standard.set(extras2, forKey: "extras2")
        }
    }
    
    @Published var extras3: String = "" {
        didSet {
            UserDefaults.standard.set(extras3, forKey: "extras3")
        }
    }
    
    @Published var extras4: String = "" {
        didSet {
            UserDefaults.standard.set(extras4, forKey: "extras4")
        }
    }
    
    // Brot Zähler 1-4
    @Published var selectedBreadCounts: [String: Int] {
        didSet {
            UserDefaults.standard.set(selectedBreadCounts, forKey: "selectedBreadCounts")
        }
    }
    @Published var selectedBreadCounts2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedBreadCounts2, forKey: "selectedBreadCounts2")
        }
    }
    @Published var selectedBreadCounts3: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedBreadCounts3, forKey: "selectedBreadCounts3")
        }
    }
    @Published var selectedBreadCounts4: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedBreadCounts4, forKey: "selectedBreadCounts4")
        }
    }
    
    // Austrichzähler 1 -4
    @Published var selectedSpreadsCounts: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts, forKey: "selectedSpreadsCounts")
        }
    }
    @Published var selectedSpreadsCounts_2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts_2, forKey: "selectedSpreadsCounts_2")
        }
    }
    @Published var selectedSpreadsCounts_3: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts_3, forKey: "selectedSpreadsCounts_3")
        }
    }
    @Published var selectedSpreadsCounts_4: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts_4, forKey: "selectedSpreadsCounts_4")
        }
    }
    
    // Aufstrichzähler2 1-4
    @Published var selectedSpreadsCounts2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts2, forKey: "selectedSpreadsCounts2")
        }
    }
    @Published var selectedSpreadsCounts2_2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts2_2, forKey: "selectedSpreadsCounts2_2")
        }
    }
    @Published var selectedSpreadsCounts2_3: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts2_3, forKey: "selectedSpreadsCounts2_3")
        }
    }
    @Published var selectedSpreadsCounts2_4: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpreadsCounts2_4, forKey: "selectedSpreadsCounts2_4")
        }
    }
    
    // Specialszähler 1-4
    @Published var selectedSpecialsCounts: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpecialsCounts, forKey: "selectedSpecialsCounts")
        }
    }
    @Published var selectedSpecialsCounts2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpecialsCounts2, forKey: "selectedSpecialsCounts2")
        }
    }
    @Published var selectedSpecialsCounts3: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpecialsCounts3, forKey: "selectedSpecialsCounts3")
        }
    }
    @Published var selectedSpecialsCounts4: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(selectedSpecialsCounts4, forKey: "selectedSpecialsCounts4")
        }
    }
    
    // Teeauswahl 1-4
    @Published var selectedTeaFlavor: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedTeaFlavor, forKey: "selectedTeaFlavor")
        }
    }
    @Published var selectedTeaFlavor2: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedTeaFlavor2, forKey: "selectedTeaFlavor2")
        }
    }
    @Published var selectedTeaFlavor3: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedTeaFlavor3, forKey: "selectedTeaFlavor3")
        }
    }
    @Published var selectedTeaFlavor4: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedTeaFlavor4, forKey: "selectedTeaFlavor4")
        }
    }
    
    // Kaffeeauswahl 1-4
    @Published var selectedCoffeeFlavor: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedCoffeeFlavor, forKey: "selectedCoffeeFlavor")
        }
    }
    @Published var selectedCoffeeFlavor2: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedCoffeeFlavor2, forKey: "selectedCoffeeFlavor2")
        }
    }
    @Published var selectedCoffeeFlavor3: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedCoffeeFlavor3, forKey: "selectedCoffeeFlavor3")
        }
    }
    @Published var selectedCoffeeFlavor4: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedCoffeeFlavor4, forKey: "selectedCoffeeFlavor4")
        }
    }
        
    // Obstauswahl 1-4
    @Published var selectedFruitComposition: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedFruitComposition, forKey: "selectedFruitComposition")
        }
    }
    @Published var selectedFruitComposition2: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedFruitComposition2, forKey: "selectedFruitComposition2")
        }
    }
    @Published var selectedFruitComposition3: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedFruitComposition3, forKey: "selectedFruitComposition3")
        }
    }
    @Published var selectedFruitComposition4: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(selectedFruitComposition4, forKey: "selectedFruitComposition4")
        }
    }

    @Published var fruitSelection: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(fruitSelection, forKey: "fruitSelection")
        }
    }
    @Published var fruitSelection2: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(fruitSelection2, forKey: "fruitSelection2")
        }
    }
    @Published var fruitSelection3: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(fruitSelection3, forKey: "fruitSelection3")
        }
    }
    @Published var fruitSelection4: String = "Nichts" {
        didSet {
            UserDefaults.standard.set(fruitSelection4, forKey: "fruitSelection4")
        }
    }
    
    @Published var extrasOptionSelection: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(extrasOptionSelection, forKey: "extrasOptionSelection")
        }
    }
    @Published var extrasOptionSelection2: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(extrasOptionSelection2, forKey: "extrasOptionSelection2")
        }
    }
    @Published var extrasOptionSelection3: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(extrasOptionSelection3, forKey: "extrasOptionSelection3")
        }
    }
    @Published var extrasOptionSelection4: [String: Int] = [:] {
        didSet {
            UserDefaults.standard.set(extrasOptionSelection4, forKey: "extrasOptionSelection4")
        }
    }
    
    // Neue Optionen
    @Published var newBreadOption: String = ""
    @Published var newSpreadOption: String = ""
    @Published var newSpecialsOption: String = ""
    @Published var newTeaOption: String = "Nichts"
    @Published var newFruitOption: String = "Nichts"
    
    init() {
        self.showRestrictions = UserDefaults.standard.bool(forKey: "showRestrictions")
        self.coffeeSelected = UserDefaults.standard.bool(forKey: "Kaffee")
        self.restrictions1 = UserDefaults.standard.string(forKey: "restrictions1") ?? "Keine"
        self.restrictions2 = UserDefaults.standard.string(forKey: "restrictions2") ?? "Keine"
        self.restrictions3 = UserDefaults.standard.string(forKey: "restrictions3") ?? "Keine"
        self.restrictions4 = UserDefaults.standard.string(forKey: "restrictions4") ?? "Keine"
        self.breadOptions = UserDefaults.standard.stringArray(forKey: "breadOptions") ?? ["Weizen", "Grau", "Körner", "Brötchen Normal", "Brötchen Grau", "Brötchen Körner"]
        self.spreadsOptions = UserDefaults.standard.stringArray(forKey: "spreadsOptions") ?? ["Butter", "Margarine", "Käse", "Pute", "Fleischwurst", "Schinken", "Salami"]
        self.spreadsOptions2 = UserDefaults.standard.stringArray(forKey: "spreadsOptions2") ?? ["Frischkäse Natur", "Frischkäse Kräuter", "Quark", "Schmelzkäse", "Schmelzkäse Pikant", "Leberwurst", "Schinkencreme", "Marmelade", "Honig", "Vegetarischer Aufstrich Tomate", "Vegetarischer Aufstrich Kräuter", "Nuss-Nougat Creme"]
        self.specialsOptions = UserDefaults.standard.stringArray(forKey: "specialsOptions") ?? ["Frucht Joghurt", "Natur Joghurt", "Brühe", "Brühe vegetarisch",  "Milchreis", "Grieß"]
        self.selectedBreadCounts = UserDefaults.standard.dictionary(forKey: "selectedBreadCounts") as? [String: Int] ?? [:]
        self.selectedBreadCounts2 = UserDefaults.standard.dictionary(forKey: "selectedBreadCounts2") as? [String: Int] ?? [:]
        self.selectedBreadCounts3 = UserDefaults.standard.dictionary(forKey: "selectedBreadCounts3") as? [String: Int] ?? [:]
        self.selectedBreadCounts4 = UserDefaults.standard.dictionary(forKey: "selectedBreadCounts4") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts_2 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts_2") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts_3 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts_3") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts_4 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts_4") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts2 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts2") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts2_2 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts2_2") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts2_3 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts2_3") as? [String: Int] ?? [:]
        self.selectedSpreadsCounts2_4 = UserDefaults.standard.dictionary(forKey: "selectedSpreadsCounts2_4") as? [String: Int] ?? [:]
        self.selectedSpecialsCounts = UserDefaults.standard.dictionary(forKey: "selectedSpecialsCounts") as? [String: Int] ?? [:]
        self.selectedSpecialsCounts2 = UserDefaults.standard.dictionary(forKey: "selectedSpecialsCounts2") as? [String: Int] ?? [:]
        self.selectedSpecialsCounts3 = UserDefaults.standard.dictionary(forKey: "selectedSpecialsCounts3") as? [String: Int] ?? [:]
        self.selectedSpecialsCounts4 = UserDefaults.standard.dictionary(forKey: "selectedSpecialsCounts4") as? [String: Int] ?? [:]
        self.selectedTeaFlavor = UserDefaults.standard.string(forKey: "selectedTeaFlavor") ?? "Nichts"
        self.selectedTeaFlavor2 = UserDefaults.standard.string(forKey: "selectedTeaFlavor2") ?? "Nichts"
        self.selectedTeaFlavor3 = UserDefaults.standard.string(forKey: "selectedTeaFlavor3") ?? "Nichts"
        self.selectedTeaFlavor4 = UserDefaults.standard.string(forKey: "selectedTeaFlavor4") ?? "Nichts"
        self.selectedCoffeeFlavor = UserDefaults.standard.string(forKey: "selectedCoffeeFlavor") ?? "Nichts"
        self.selectedCoffeeFlavor2 = UserDefaults.standard.string(forKey: "selectedCoffeeFlavor2") ?? "Nichts"
        self.selectedCoffeeFlavor3 = UserDefaults.standard.string(forKey: "selectedCoffeeFlavor3") ?? "Nichts"
        self.selectedCoffeeFlavor4 = UserDefaults.standard.string(forKey: "selectedCoffeeFlavor4") ?? "Nichts"
        self.selectedFruitComposition = UserDefaults.standard.string(forKey: "selectedFruitComposition") ?? "Nichts"
        self.selectedFruitComposition2 = UserDefaults.standard.string(forKey: "selectedFruitComposition2") ?? "Nichts"
        self.selectedFruitComposition3 = UserDefaults.standard.string(forKey: "selectedFruitComposition3") ?? "Nichts"
        self.selectedFruitComposition4 = UserDefaults.standard.string(forKey: "selectedFruitComposition4") ?? "Nichts"
        self.fruitSelection = UserDefaults.standard.string(forKey: "fruitSelection") ?? "Nichts"
        self.fruitSelection2 = UserDefaults.standard.string(forKey: "fruitSelection2") ?? "Nichts"
        self.fruitSelection3 = UserDefaults.standard.string(forKey: "fruitSelection3") ?? "Nichts"
        self.fruitSelection4 = UserDefaults.standard.string(forKey: "fruitSelection4") ?? "Nichts"
        self.extrasOptionSelection = UserDefaults.standard.dictionary(forKey: "extrasOptionSelection") as? [String: Int] ?? [:]
        self.extrasOptionSelection2 = UserDefaults.standard.dictionary(forKey: "extrasOptionSelection2") as? [String: Int] ?? [:]
        self.extrasOptionSelection3 = UserDefaults.standard.dictionary(forKey: "extrasOptionSelection3") as? [String: Int] ?? [:]
        self.extrasOptionSelection4 = UserDefaults.standard.dictionary(forKey: "extrasOptionSelection4") as? [String: Int] ?? [:]
        self.drinkSelection = UserDefaults.standard.string(forKey: "drinkSelection") ?? "Nichts"
        self.drinkSelection2 = UserDefaults.standard.string(forKey: "drinkSelection2") ?? "Nichts"
        self.drinkSelection3 = UserDefaults.standard.string(forKey: "drinkSelection3") ?? "Nichts"
        self.drinkSelection4 = UserDefaults.standard.string(forKey: "drinkSelection4") ?? "Nichts"
        self.teaOptions = UserDefaults.standard.stringArray(forKey: "teaOptions") ?? ["Nichts", "Kamille", "Kräuter/ Grüner Tee", "Schwarzer Tee", "Früchte Tee", "Fenchel", "Pfefferminz"]
        self.coffeeOptions = UserDefaults.standard.stringArray(forKey: "coffeeOptions") ?? ["Nichts", "Kaffee", "Kaffee mit Milch", "Kaffee mit Zucker", "Kaffee mit Milch und Zucker"]
        self.fruitOptions = UserDefaults.standard.stringArray(forKey: "fruitOptions") ?? ["Nichts", "Apfel", "Banane", "Birne", "Apfel & Banane", "Apfel & Birne", "Banane & Birne", "Alles"]
        self.extrasOptions = UserDefaults.standard.stringArray(forKey: "extrasOptions") ?? ["Zucker", "Süßstoff", "Zitrone", "Milch", "Salz", "Pfeffer", "Gewürzgurke", "Gurke", "Tomate", "Suppe", "Gemüse", "Kakao"]
        self.extras = UserDefaults.standard.string(forKey: "extras") ?? ""
        self.extras2 = UserDefaults.standard.string(forKey: "extras2") ?? ""
        self.extras3 = UserDefaults.standard.string(forKey: "extras3") ?? ""
        self.extras4 = UserDefaults.standard.string(forKey: "extras4") ?? ""
    }
    
    func deleteBreadOption(at offsets: IndexSet) {
        for index in offsets {
            let bread = breadOptions[index]
            breadOptions.remove(at: index)
            selectedBreadCounts[bread] = nil
            selectedBreadCounts2[bread] = nil
            selectedBreadCounts3[bread] = nil
            selectedBreadCounts4[bread] = nil
        }
    }
    
    func deleteSpreadOption(at offsets: IndexSet) {
        for index in offsets {
            let spread = spreadsOptions[index]
            spreadsOptions.remove(at: index)
            selectedSpreadsCounts[spread] = nil
            selectedSpreadsCounts_2[spread] = nil
            selectedSpreadsCounts_3[spread] = nil
            selectedSpreadsCounts_4[spread] = nil
        }
    }
    
    func deleteSpreadOption2(at offsets: IndexSet) {
        for index in offsets {
            let spread = spreadsOptions2[index]
            spreadsOptions2.remove(at: index)
            selectedSpreadsCounts2[spread] = nil
            selectedSpreadsCounts2_2[spread] = nil
            selectedSpreadsCounts2_3[spread] = nil
            selectedSpreadsCounts2_4[spread] = nil
        }
    }
    
    
    func deleteSpecialsOption(at offsets: IndexSet) {
        for index in offsets {
            let specials = specialsOptions[index]
            specialsOptions.remove(at: index)
            selectedSpecialsCounts[specials] = nil
            selectedSpecialsCounts2[specials] = nil
            selectedSpecialsCounts3[specials] = nil
            selectedSpecialsCounts4[specials] = nil
        }
    }

    func deleteTeaOption(at offsets: IndexSet) {
        for index in offsets {
            let tea = teaOptions[index]
            teaOptions.remove(at: index)
            if selectedTeaFlavor == tea {
                selectedTeaFlavor = "Nichts"
                selectedTeaFlavor2 = "Nichts"
                selectedTeaFlavor3 = "Nichts"
                selectedTeaFlavor4 = "Nichts"
            }
        }
    }
    
    func deleteCoffeeOption(at offsets: IndexSet) {
        for index in offsets {
            let coffee = coffeeOptions[index]
            coffeeOptions.remove(at: index)
            if selectedCoffeeFlavor == coffee {
                selectedCoffeeFlavor = "Nichts"
                selectedCoffeeFlavor2 = "Nichts"
                selectedCoffeeFlavor3 = "Nichts"
                selectedCoffeeFlavor4 = "Nichts"
            }
        }
    }

    func deleteFruitOption(at offsets: IndexSet) {
        for index in offsets {
            let fruit = fruitOptions[index]
            fruitOptions.remove(at: index)
            if selectedFruitComposition == fruit {
                selectedFruitComposition = "Nichts"
                selectedFruitComposition2 = "Nichts"
                selectedFruitComposition3 = "Nichts"
                selectedFruitComposition4 = "Nichts"
            }
        }
    }
    
    func deleteExtrasOption(at offsets: IndexSet) {
        for index in offsets {
            let extras = extrasOptions[index]
            extrasOptions.remove(at: index)
            extrasOptionSelection[extras] = nil
            extrasOptionSelection2[extras] = nil
            extrasOptionSelection3[extras] = nil
            extrasOptionSelection4[extras] = nil
        }
    }

    func moveBreadOption(from source: IndexSet, to destination: Int) {
        breadOptions.move(fromOffsets: source, toOffset: destination)
    }

    func moveSpreadOption(from source: IndexSet, to destination: Int) {
        spreadsOptions.move(fromOffsets: source, toOffset: destination)
    }
    
    func moveSpreadOption2(from source: IndexSet, to destination: Int) {
        spreadsOptions2.move(fromOffsets: source, toOffset: destination)
    }
    
    func moveSpecialsOption(from source: IndexSet, to destination: Int) {
        specialsOptions.move(fromOffsets: source, toOffset: destination)
    }

    func moveTeaOption(from source: IndexSet, to destination: Int) {
        teaOptions.move(fromOffsets: source, toOffset: destination)
    }
    
    func moveCoffeeOption(from source: IndexSet, to destination: Int) {
        coffeeOptions.move(fromOffsets: source, toOffset: destination)
    }

    func moveFruitOption(from source: IndexSet, to destination: Int) {
        fruitOptions.move(fromOffsets: source, toOffset: destination)
    }
    
    func moveExtrasOption(from source: IndexSet, to destination: Int) {
        extrasOptions.move(fromOffsets: source, toOffset: destination)
    }

    func validateSelections() -> Bool {
        let breadSelectionNotEmpty = !selectedBreadCounts.isEmpty
        let breadSelectionNotEmpty2 = !selectedBreadCounts2.isEmpty
        let breadSelectionNotEmpty3 = !selectedBreadCounts3.isEmpty
        let breadSelectionNotEmpty4 = !selectedBreadCounts4.isEmpty
        
        let spreadSelectionNotEmpty = !selectedSpreadsCounts.isEmpty
        let spreadSelectionNotEmpty_2 = !selectedSpreadsCounts_2.isEmpty
        let spreadSelectionNotEmpty_3 = !selectedSpreadsCounts_3.isEmpty
        let spreadSelectionNotEmpty_4 = !selectedSpreadsCounts_4.isEmpty
        
        let spreadSelectionNotEmpty2 = !selectedSpreadsCounts2.isEmpty
        let spreadSelectionNotEmpty2_2 = !selectedSpreadsCounts2_2.isEmpty
        let spreadSelectionNotEmpty2_3 = !selectedSpreadsCounts2_3.isEmpty
        let spreadSelectionNotEmpty2_4 = !selectedSpreadsCounts2_4.isEmpty
        
        let specialsSelectionNotEmpty = !selectedSpecialsCounts.isEmpty
        let specialsSelectionNotEmpty2 = !selectedSpecialsCounts2.isEmpty
        let specialsSelectionNotEmpty3 = !selectedSpecialsCounts3.isEmpty
        let specialsSelectionNotEmpty4 = !selectedSpecialsCounts4.isEmpty
        
        let drinkSelectionNotEmpty = !drinkSelection.isEmpty
        let drinkSelection2NotEmpty = !drinkSelection2.isEmpty
        let drinkSelection3NotEmpty = !drinkSelection3.isEmpty
        let drinkSelection4NotEmpty = !drinkSelection4.isEmpty

        let teaSelectionNotEmpty = !selectedTeaFlavor.isEmpty
        let teaSelectionNotEmpty2 = !selectedTeaFlavor2.isEmpty
        let teaSelectionNotEmpty3 = !selectedTeaFlavor3.isEmpty
        let teaSelectionNotEmpty4 = !selectedTeaFlavor4.isEmpty
        
        let coffeeSelectionNotEmpty = !selectedCoffeeFlavor.isEmpty
        let coffeeSelectionNotEmpty2 = !selectedCoffeeFlavor2.isEmpty
        let coffeeSelectionNotEmpty3 = !selectedCoffeeFlavor3.isEmpty
        let coffeeSelectionNotEmpty4 = !selectedCoffeeFlavor4.isEmpty

        let fruitSelectionNotEmpty = !fruitOptions.isEmpty
        
        let extrasSelectionNotEmpty = !extrasOptionSelection.isEmpty
        let extrasSelectionNotEmpty2 = !extrasOptionSelection2.isEmpty
        let extrasSelectionNotEmpty3 = !extrasOptionSelection3.isEmpty
        let extrasSelectionNotEmpty4 = !extrasOptionSelection4.isEmpty


        return breadSelectionNotEmpty || breadSelectionNotEmpty2 || breadSelectionNotEmpty3 || breadSelectionNotEmpty4 || spreadSelectionNotEmpty || spreadSelectionNotEmpty_2 || spreadSelectionNotEmpty_3 || spreadSelectionNotEmpty_4 || spreadSelectionNotEmpty2 || spreadSelectionNotEmpty2_2 || spreadSelectionNotEmpty2_3 || spreadSelectionNotEmpty2_4 || specialsSelectionNotEmpty || specialsSelectionNotEmpty2 || specialsSelectionNotEmpty3 || specialsSelectionNotEmpty4 || drinkSelectionNotEmpty || drinkSelection2NotEmpty || drinkSelection3NotEmpty || drinkSelection4NotEmpty || teaSelectionNotEmpty || teaSelectionNotEmpty2 || teaSelectionNotEmpty3 || teaSelectionNotEmpty4 || fruitSelectionNotEmpty || coffeeSelectionNotEmpty || coffeeSelectionNotEmpty2 || coffeeSelectionNotEmpty3 || coffeeSelectionNotEmpty4 || extrasSelectionNotEmpty || extrasSelectionNotEmpty2 || extrasSelectionNotEmpty3 || extrasSelectionNotEmpty4
        }
}
