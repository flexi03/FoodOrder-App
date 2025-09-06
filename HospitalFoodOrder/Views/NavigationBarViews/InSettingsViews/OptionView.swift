//
//  OptionView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 04.12.23.
//

import SwiftUI

struct OptionView: View {
    @State private var isResetConfirmationPresented: Bool = false
	@StateObject var settings = Settings()
    @State private var newOptions: [String: String] = [:]
    @State private var newOptionCategory: String = ""
    @State private var isEditingPrivateOptions: Bool = false
    
    let categories: [(key: String, name: String)] = [
        ("bread", "Brot"),
        ("preordered", "Vorbestellungen"),
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
                    let sortedOptions = settings.getSortedOptions(for: category.key, isPrivate: isEditingPrivateOptions)
                    ForEach(sortedOptions, id: \.0) { option, _ in
                        Text(option)
                    }
                    .onMove { from, to in
                        moveOption(in: category.key, from: from, to: to)
                    }
                    .onDelete { indexSet in
                        deleteOption(in: category.key, at: indexSet)
                    }
                    
                    HStack {
                        TextField("Neue \(category.name) Option", text: Binding(
                            get: { self.newOptions[category.key] ?? "" },
                            set: { self.newOptions[category.key] = $0 }
                        ))
                        .onSubmit {
                            addNewOption(to: category.key)
//                            ToastManager.shared.showSuccess("Eine Option wurde in \(category.name) hinzugefügt!")
                        }
                        Button(action: {
                            addNewOption(to: category.key)
                        }) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            
            //            Section("Neue Kategorie") {
            //                HStack {
            //                    TextField("Neue Kategorie", text: $newOptionCategory)
            //                    Button(action: addNewCategory) {
            //                        Image(systemName: "plus.circle.fill")
            //                    }
            //                }
            //            }
            
            Section("") {
            }
            .frame(height: 40)
        }
        .navigationTitle("Optionen")
        .navigationBarItems(trailing: resetButton)
        .alert(isPresented: $isResetConfirmationPresented) {
            resetConfirmationAlert
        }
//        .withToasts()
        .environment(\.editMode, .constant(.active))
    }
    
    private func currentOptions(for category: String) -> [String: Int] {
        isEditingPrivateOptions ? settings.privateOptionCategories[category] ?? [:] : settings.optionCategories[category] ?? [:]
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
    
    
    private func moveOption(in category: String, from source: IndexSet, to destination: Int) {
        var currentOrder = isEditingPrivateOptions ?
        (settings.privateOptionOrder[category] ?? []) :
        (settings.optionOrder[category] ?? [])
        
        currentOrder.move(fromOffsets: source, toOffset: destination)
        
        settings.updateOptionOrder(for: category, isPrivate: isEditingPrivateOptions, newOrder: currentOrder)
    }
    //    private func moveOption(in category: String, from source: IndexSet, to destination: Int) {
    //        var options = currentOptions(for: category)
    //        let keys = Array(options.keys)
    //        let movedKeys = source.map { keys[$0] }
    //        
    //        for key in movedKeys {
    //            options.removeValue(forKey: key)
    //        }
    //        
    //        let sortedKeys = keys.enumerated().sorted { (first, second) -> Bool in
    //            if source.contains(first.offset) {
    //                if source.contains(second.offset) {
    //                    return first.offset < second.offset
    //                }
    //                return false
    //            }
    //            if source.contains(second.offset) {
    //                return true
    //            }
    //            return first.offset < second.offset
    //        }.map { $0.element }
    //        
    //        var newOptions: [String: Int] = [:]
    //        for (index, key) in sortedKeys.enumerated() {
    //            if index == destination {
    //                for movedKey in movedKeys {
    //                    newOptions[movedKey] = options[movedKey] ?? 0
    //                }
    //            }
    //            if !movedKeys.contains(key) {
    //                newOptions[key] = options[key]
    //            }
    //        }
    //        if destination == sortedKeys.count {
    //            for movedKey in movedKeys {
    //                newOptions[movedKey] = options[movedKey] ?? 0
    //            }
    //        }
    //        
    //        if isEditingPrivateOptions {
    //            settings.privateOptionCategories[category] = newOptions
    //        } else {
    //            settings.optionCategories[category] = newOptions
    //        }
    //    }
    
    private func addNewOption(to category: String) {
        if let newOption = newOptions[category], !newOption.isEmpty {
            if isEditingPrivateOptions {
                settings.privateOptionCategories[category, default: [:]][newOption] = 0
                settings.privateOptionOrder[category, default: []].append(newOption)
            } else {
                settings.optionCategories[category, default: [:]][newOption] = 0
                settings.optionOrder[category, default: []].append(newOption)
            }
            newOptions[category] = ""
            settings.saveOptionCategories()
            settings.saveOptionOrder()
            
            ToastManager.shared.showSuccess("\(newOption) wurde erfolgreich hinzugefügt!")
        }
    }
    
    private func deleteOption(in category: String, at indexSet: IndexSet) {
        let options = isEditingPrivateOptions ? settings.privateOptionOrder[category] ?? [] : settings.optionOrder[category] ?? []
        indexSet.forEach { index in
            let optionToRemove = options[index]
            if isEditingPrivateOptions {
                settings.privateOptionCategories[category]?.removeValue(forKey: optionToRemove)
                settings.privateOptionOrder[category]?.remove(at: index)
            } else {
                settings.optionCategories[category]?.removeValue(forKey: optionToRemove)
                settings.optionOrder[category]?.remove(at: index)
            }
            ToastManager.shared.showWarning("\(optionToRemove) wurde entfernt!")
        }
        settings.saveOptionCategories()
        settings.saveOptionOrder()
    }
    
    private func addNewCategory() {
        if !newOptionCategory.isEmpty {
            if isEditingPrivateOptions {
                settings.privateOptionCategories[newOptionCategory] = [:]
            } else {
                settings.optionCategories[newOptionCategory] = [:]
            }
            newOptionCategory = ""
            
            ToastManager.shared.showSuccess("\(newOptionCategory) wurde erfolgreich hinzugefügt!")
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
                "bread": ["Weizen": 0, "Grau": 0, "Körner": 0, "Brötchen Normal": 0, "Brötchen Grau": 0, "Brötchen Körner": 0],
                "preorderd": ["Lachs": 0, "Tomate-Mozarella": 0, "Rohkostteller": 0],
                "spreads": ["Butter": 0, "Margarine": 0, "Käse": 0, "Gouda": 0, "Edamer": 0, "Leerdamer": 0, "Pute": 0, "Fleischwurst": 0, "Schinken": 0, "Salami": 0],
                "spreads2": ["Frischkäse Natur": 0, "Frischkäse Kräuter": 0, "Quark": 0, "Schmelzkäse": 0, "Schmelzkäse Pikant": 0, "Leberwurst": 0, "Schinkencreme": 0, "Marmelade": 0, "Honig": 0, "Vegetarischer Aufstrich Tomate": 0, "Vegetarischer Aufstrich Kräuter": 0, "Nutella": 0],
                "specials": ["Frucht Joghurt": 0, "Natur Joghurt": 0, "Brühe": 0, "Brühe vegetarisch": 0,  "Milchreis": 0, "Grieß": 0, "Müsli": 0],
                "tea": ["Kamille": 0, "Kräuter/ Grüner Tee": 0, "Schwarzer Tee": 0, "Hagebutte": 0, "Fenchel": 0, "Pfefferminz": 0, "Earl Grey": 0],
                "coffee": ["Kaffee": 0, "Kaffee mit Milch": 0, "Kaffee mit Zucker": 0, "Kaffee mit Milch und Zucker": 0, "Kakao": 0],
                "fruit": ["Apfel": 0, "Banane": 0, "Birne": 0],
                "extras": ["Zucker": 0, "Süßstoff": 0, "Milch": 0, "Salz": 0, "Pfeffer": 0, "Zitrone": 0, "Gewürzgurke": 0, "Salatgurke": 0, "Tomate": 0, "Suppe": 0, "Gemüse": 0]
            ]
        } else {
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
        ToastManager.shared.showWarning("Alle Optionen wurden zurückgesetzt!!!", details: "Die neuen Optionen sind nun \(settings.optionCategories)")
    }
}

struct OptionView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OptionView(settings: Settings())
        }
    }
}
