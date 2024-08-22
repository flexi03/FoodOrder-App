//
//  OptionView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 04.12.23.
//

import SwiftUI

struct OptionView: View {
    @State private var isResetConfirmationPresented: Bool = false
    @ObservedObject var settings: Settings
    @State private var newOption: String = ""
    @State private var newOptionCategory: String = ""
    @State private var isEditingPrivateOptions: Bool = false
    
    let categories: [(key: String, name: String)] = [
        ("bread", "Brot"),
        ("spreads", "Aufstrich"),
        ("spreads2", "Aufstrich 2"),
        ("specials", "Specials"),
        ("tea", "Tee"),
        ("coffee", "Kaffee"),
        ("fruit", "Obst"),
        ("extras", "Extras")
    ]
    
    var body: some View {
        List {
            Section(header: Text("Optionen bearbeiten")) {
                Picker("Optionen bearbeiten", selection: $isEditingPrivateOptions) {
                    Text("Normal").tag(false)
                    Text("Privatpatient*in").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            ForEach(categories, id: \.key) { category in
                Section(header: Text("\(category.name) Optionen")) {
                    ForEach(Array(currentOptions[category.key]?.keys.sorted() ?? []), id: \.self) { option in
                        HStack {
                            Text(option)
                            Spacer()
                            Text("\(currentOptions[category.key]?[option] ?? 0)")
                        }
                    }
                    .onDelete { indexSet in
                        deleteOptions(at: indexSet, for: category.key)
                    }
                    .onMove { source, destination in
                        moveOptions(from: source, to: destination, for: category.key)
                    }
                    
                    HStack {
                        TextField("Neue \(category.name) Option", text: $newOption)
                        Button(action: {
                            addNewOption(to: category.key)
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            
            Section("Neue Kategorie") {
                HStack {
                    TextField("Neue Kategorie", text: $newOptionCategory)
                    Button(action: addNewCategory) {
                        Image(systemName: "plus.circle.fill")
                    }
                }
            }
        }
        .navigationTitle("Optionen")
        .navigationBarItems(trailing: resetButton)
        .alert(isPresented: $isResetConfirmationPresented) {
            resetConfirmationAlert
        }
    }
    
    private var currentOptions: [String: [String: Int]] {
        isEditingPrivateOptions ? settings.privateOptionCategories : settings.optionCategories
    }
    
    private var resetButton: some View {
        Button(action: { isResetConfirmationPresented.toggle() }) {
            Image(systemName: "arrow.clockwise")
                .fontWeight(.bold)
        }
    }
    
    private var resetConfirmationAlert: Alert {
        Alert(
            title: Text("Optionen zurücksetzen"),
            message: Text("Sind Sie sicher, dass Sie die kompletten Optionen zurücksetzen möchten?"),
            primaryButton: .destructive(Text("Zurücksetzen")) {
                resetOptions()
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.warning)
            },
            secondaryButton: .cancel(Text("Abbrechen"))
        )
    }
    
    private func deleteOptions(at offsets: IndexSet, for category: String) {
        var options = currentOptions[category] ?? [:]
        let sortedKeys = Array(options.keys.sorted())
        for index in offsets {
            let key = sortedKeys[index]
            options.removeValue(forKey: key)
        }
        updateOptions(category: category, with: options)
    }
    
    private func moveOptions(from source: IndexSet, to destination: Int, for category: String) {
        var options = currentOptions[category] ?? [:]
        var sortedKeys = Array(options.keys.sorted())
        sortedKeys.move(fromOffsets: source, toOffset: destination)
        let newDict = Dictionary(uniqueKeysWithValues: sortedKeys.map { ($0, options[$0] ?? 0) })
        updateOptions(category: category, with: newDict)
    }
    
    private func addNewOption(to category: String) {
        if !newOption.isEmpty {
            var options = currentOptions[category] ?? [:]
            options[newOption] = 0
            updateOptions(category: category, with: options)
            newOption = ""
        }
    }
    
    private func addNewCategory() {
        if !newOptionCategory.isEmpty {
            if isEditingPrivateOptions {
                settings.privateOptionCategories[newOptionCategory] = [:]
            } else {
                settings.optionCategories[newOptionCategory] = [:]
            }
            newOptionCategory = ""
        }
    }
    
    private func updateOptions(category: String, with options: [String: Int]) {
        if isEditingPrivateOptions {
            settings.privateOptionCategories[category] = options
        } else {
            settings.optionCategories[category] = options
        }
    }
    
    private func resetOptions() {
        if isEditingPrivateOptions {
            settings.privateOptionCategories = [
                "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0, "Ciabatta": 0, "Vollkornbrot": 0],
                "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0, "Lachs": 0],
                "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0, "Hummus": 0],
                "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0,  "Milchreis": 0, "Grieß": 0, "Müsli": 0],
                "tea": ["Nichts": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0, "Earl Grey": 0],
                "coffee": ["Nichts": 0, "Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0, "Espresso": 0, "Cappuccino": 0],
                "fruit": ["Nichts": 0, "Apfel": 0, "Banane": 0, "Birne": 0, "Orange": 0, "Trauben": 0],
                "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0, "Obstsalat": 0]
            ]
        } else {
            settings.optionCategories = [
                "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
                "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
                "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nuss-Nougat Creme": 0],
                "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0,  "Milchreis": 0, "Grieß": 0],
                "tea": ["Nichts": 0, "Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Früchte Tee": 0, "Fenchel": 0, "Pfefferminz": 0],
                "coffee": ["Nichts": 0, "Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
                "fruit": ["Nichts": 0, "Apfel": 0, "Banane": 0, "Birne": 0],
                "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0]
            ]
        }
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OptionView(settings: Settings())
        }
    }
}
