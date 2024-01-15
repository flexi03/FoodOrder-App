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
    @State private var newOptionBread: String = ""
    @State private var newOptionSpreads: String = ""
    @State private var newOptionSpreads2: String = ""
    @State private var newOptionSpecials: String = ""
    @State private var newOptionTea: String = ""
    @State private var newCoffeeOption: String = ""
    @State private var newOptionFruit: String = ""
    @State private var newExtrasOption: String = ""
    
    var body: some View {
        Form {
            Section(header: Text("Brot Optionen")) {
                List {
                    ForEach(settings.breadOptions.indices, id: \.self) { index in
                        TextField("Brot \(index + 1)", text: Binding(
                            get: { settings.breadOptions[index] },
                            set: { newValue in settings.breadOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteBreadOption)
                    .onMove(perform: settings.moveBreadOption)
                }
                TextField("Neue Brotoption hinzufügen", text: $newOptionBread)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionBread.isEmpty {
                            settings.breadOptions.append(newOptionBread)
                            newOptionBread = ""
                        }
                    }
            }

            Section(header: Text("Aufstrich Optionen")) {
                List {
                    ForEach(settings.spreadsOptions.indices, id: \.self) { index in
                        TextField("Aufstrich \(index + 1)", text: Binding(
                            get: { settings.spreadsOptions[index] },
                            set: { newValue in settings.spreadsOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteSpreadOption)
                    .onMove(perform: settings.moveSpreadOption)
                }
                TextField("Neue Aufstrichoption hinzufügen", text: $newOptionSpreads)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionSpreads.isEmpty {
                            settings.spreadsOptions.append(newOptionSpreads)
                            newOptionSpreads = ""
                        }
                    }
            }
            
            Section(header: Text("Aufstrich Optionen 2")) {
                List {
                    ForEach(settings.spreadsOptions2.indices, id: \.self) { index in
                        TextField("Aufstrich \(index + 1)", text: Binding(
                            get: { settings.spreadsOptions2[index] },
                            set: { newValue in settings.spreadsOptions2[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteSpreadOption2)
                    .onMove(perform: settings.moveSpreadOption2)
                }
                TextField("Neue Aufstrichoption hinzufügen", text: $newOptionSpreads2)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionSpreads2.isEmpty {
                            settings.spreadsOptions2.append(newOptionSpreads2)
                            newOptionSpreads2 = ""
                        }
                    }
            }
            
            Section(header: Text("Specials Optionen")) {
                List {
                    ForEach(settings.specialsOptions.indices, id: \.self) { index in
                        TextField("Specials \(index + 1)", text: Binding(
                            get: { settings.specialsOptions[index] },
                            set: { newValue in settings.specialsOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteSpecialsOption)
                    .onMove(perform: settings.moveSpecialsOption)
                }
                TextField("Neue Specials hinzufügen", text: $newOptionSpecials)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionSpecials.isEmpty {
                            settings.specialsOptions.append(newOptionSpecials)
                            newOptionSpecials = ""
                        }
                    }
            }

            Section(header: Text("Tee Optionen")) {
                List {
                    ForEach(settings.teaOptions.indices, id: \.self) { index in
                        TextField("Tee \(index + 1)", text: Binding(
                            get: { settings.teaOptions[index] },
                            set: { newValue in settings.teaOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteTeaOption)
                    .onMove(perform: settings.moveTeaOption)
                }
                TextField("Neue Teeoption hinzufügen", text: $newOptionTea)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionTea.isEmpty {
                            settings.teaOptions.append(newOptionTea)
                            newOptionTea = ""
                        }
                    }
            }
            
            Section(header: Text("Kaffee Optionen")) {
                List {
                    ForEach(settings.coffeeOptions.indices, id: \.self) { index in
                        TextField("Kaffee \(index + 1)", text: Binding(
                            get: { settings.coffeeOptions[index] },
                            set: { newValue in settings.coffeeOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteCoffeeOption)
                    .onMove(perform: settings.moveCoffeeOption)
                }
                TextField("Neue Kaffeesorte hinzufügen", text: $newCoffeeOption)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newCoffeeOption.isEmpty {
                            settings.coffeeOptions.append(newCoffeeOption)
                            newCoffeeOption = ""
                        }
                    }
            }

            Section(header: Text("Obst Optionen")) {
                List {
                    ForEach(settings.fruitOptions.indices, id: \.self) { index in
                        TextField("Kaffee \(index + 1)", text: Binding(
                            get: { settings.fruitOptions[index] },
                            set: { newValue in settings.fruitOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteFruitOption)
                    .onMove(perform: settings.moveFruitOption)
                }
                TextField("Neue Obstsorte hinzufügen", text: $newOptionFruit)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newOptionFruit.isEmpty {
                            settings.fruitOptions.append(newOptionFruit)
                            newOptionFruit = ""
                        }
                    }
            }
            
            Section(header: Text("Extras Optionen")) {
                List {
                    ForEach(settings.extrasOptions.indices, id: \.self) { index in
                        TextField("Extras \(index + 1)", text: Binding(
                            get: { settings.extrasOptions[index] },
                            set: { newValue in settings.extrasOptions[index] = newValue }
                        ))
                    }
                    .onDelete(perform: settings.deleteExtrasOption)
                    .onMove(perform: settings.moveExtrasOption)
                }
                
                TextField("Neue Extras Option hinzufügen", text: $newExtrasOption)
                    .autocapitalization(.words)
                    .disableAutocorrection(true)
                    .onSubmit {
                        if !newExtrasOption.isEmpty {
                            settings.extrasOptions.append(newExtrasOption)
                            newExtrasOption = ""
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
        })
    }
}
