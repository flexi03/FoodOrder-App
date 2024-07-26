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
    @State private var newOptions: [String: String] = [:]
    
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
        Form {
            ForEach(categories, id: \.key) { category in
                Section(header: Text("\(category.name) Optionen")) {
                    ForEach(settings.optionCategories[category.key] ?? [], id: \.self) { option in
                        TextField(option, text: Binding(
                            get: { option },
                            set: { newValue in
                                if let index = settings.optionCategories[category.key]?.firstIndex(of: option) {
                                    settings.optionCategories[category.key]?[index] = newValue
                                }
                            }
                        ))
                    }
                    .onDelete { indexSet in
                        settings.optionCategories[category.key]?.remove(atOffsets: indexSet)
                    }
                    .onMove { source, destination in
                        settings.optionCategories[category.key]?.move(fromOffsets: source, toOffset: destination)
                    }
                    
                    TextField("Neue \(category.name) Option hinzufügen", text: Binding(
                        get: { self.newOptions[category.key] ?? "" },
                        set: { self.newOptions[category.key] = $0 }
                    ))
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if let newOption = newOptions[category.key], !newOption.isEmpty {
                            settings.optionCategories[category.key]?.append(newOption)
                            newOptions[category.key] = ""
                        }
                    }
                }
            }
            
            Section("") {
            }
            .frame(height: 50)
        }
        .navigationTitle("Optionen")
        .navigationBarItems(trailing: Button(action: {
            isResetConfirmationPresented.toggle()
        }) {
            Image(systemName: "arrow.clockwise")
                .fontWeight(.bold)
        })
        .alert(isPresented: $isResetConfirmationPresented) {
            Alert(
                title: Text("Optionen zurücksetzen"),
                message: Text("Sind Sie sicher, dass Sie die kompletten Optionen zurücksetzen möchten?"),
                primaryButton: .destructive(Text("Zurücksetzen")) {
                    resetOptions()
                    // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning)
                },
                secondaryButton: .cancel(Text("Abbrechen"))
            )
        }
    }
    
    private func resetOptions() {
        settings.optionCategories = [
            "bread": ["Weizen", "Grau", "Körner", "Brötchen Normal", "Brötchen Grau", "Brötchen Körner"],
            "spreads": ["Butter", "Margarine", "Käse", "Pute", "Fleischwurst", "Schinken", "Salami"],
            "spreads2": ["Frischkäse Natur", "Frischkäse Kräuter", "Quark", "Schmelzkäse", "Schmelzkäse Pikant", "Leberwurst", "Schinkencreme", "Marmelade", "Honig", "Vegetarischer Aufstrich Tomate", "Vegetarischer Aufstrich Kräuter", "Nuss-Nougat Creme"],
            "specials": ["Frucht Joghurt", "Natur Joghurt", "Brühe", "Brühe vegetarisch",  "Milchreis", "Grieß"],
            "tea": ["Nichts", "Kamille", "Kräuter/ Grüner Tee", "Schwarzer Tee", "Früchte Tee", "Fenchel", "Pfefferminz"],
            "coffee": ["Nichts", "Kaffee", "Kaffee mit Milch", "Kaffee mit Zucker", "Kaffee mit Milch und Zucker", "Kakao"],
            "fruit": ["Nichts", "Apfel", "Banane", "Birne"],
            "extras": ["Zucker", "Süßstoff", "Milch", "Salz", "Pfeffer", "Zitrone", "Gewürzgurke", "Salatgurke", "Tomate", "Suppe", "Gemüse"]
        ]
    }
}
