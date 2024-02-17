//
//  OrderFormView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 23.11.23.
//

import SwiftUI


struct OrderFormView: View {
    
    @ObservedObject var settings: Settings
    @ObservedObject var patientSelection: patientSelectionManager
    
    @State private var isResetConfirmationPresented: Bool = false
    @State private var isResetAllConfirmationPresented: Bool = false
    
    @ObservedObject private var selectionManager = SelectionManager()
    
    @State private var color = Color.accent
    
    @State private var isButtonPressed = false
    
    // Function to filter options based on selection count
    func filterOptions(options: [String], counts: [String: Int]) -> [String] {
        return options.filter { counts[$0] ?? 0 > 0 }
    }
    
    var body: some View {
        Form {
            Section {
                Picker("Patientenauswahl", selection: $patientSelection.patientSelection) {
                    Text("1").tag("P1")
                    Text("2").tag("P2")
                    Text("3").tag("P3")
                    Text("4").tag("P4")
                }
                .frame(height: 50)
                .pickerStyle(SegmentedPickerStyle())
                .scaledToFill()
                .onChange(of: patientSelection.patientSelection) { _ in
                    // Erzeuge eine leichte Vibration
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    determineColor()
                }
            }
            
            if settings.showRestrictions == true {
                if patientSelection.patientSelection == "P1" {
                    if isButtonPressed == false {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions1) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                    if isButtonPressed == true && settings.restrictions1 == "Keine" {
                        // Nichts anzeigen
                    } else if isButtonPressed == true && settings.restrictions1 != "Keine" {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions1) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                }
                
                if patientSelection.patientSelection == "P2" {
                    if isButtonPressed == false {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions2) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                    if isButtonPressed == true && settings.restrictions2 == "Keine" {
                        // Nichts anzeigen
                    } else if isButtonPressed == true && settings.restrictions2 != "Keine" {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions2) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                }
                
                if patientSelection.patientSelection == "P3" {
                    if isButtonPressed == false {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions3) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                    if isButtonPressed == true && settings.restrictions3 == "Keine" {
                        // Nichts anzeigen
                    } else if isButtonPressed == true && settings.restrictions3 != "Keine" {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions3) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                }
                
                if patientSelection.patientSelection == "P4" {
                    if isButtonPressed == false {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions4) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                    if isButtonPressed == true && settings.restrictions4 == "Keine" {
                        // Nichts anzeigen
                    } else if isButtonPressed == true && settings.restrictions4 != "Keine" {
                        Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                            Picker ("Einschränkungen", selection: $settings.restrictions4) {
                                Text("Keine").tag("Keine")
                                Text("Schnabelbecher").tag("Schnabelbecher")
                                Text("Schmieren").tag("Schmieren")
                                Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                            }
                        }
                    }
                }
            }

            if patientSelection.patientSelection == "P1" {
                let breadOptions = isButtonPressed ? filterOptions(options: settings.breadOptions, counts: settings.selectedBreadCounts) : settings.breadOptions
                if breadOptions.isEmpty {
                    // Nichts anzeigen
                } else {
                    Section(header: Text("Brot").fontWeight(.semibold)) {
                        ForEach(breadOptions, id: \.self) { bread in
                            Stepper("\(bread) (\(max(0, settings.selectedBreadCounts[bread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedBreadCounts[bread] ?? 0) },
                                set: { newValue in
                                    settings.selectedBreadCounts[bread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .onAppear(perform: determineColor)
                            .foregroundColor(settings.selectedBreadCounts[bread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteBreadOption)
                    }
                }
                
                let spreadOptions = isButtonPressed ? filterOptions(options: settings.spreadsOptions, counts: settings.selectedSpreadsCounts) : settings.spreadsOptions
                if spreadOptions.isEmpty {
                    // Keine Aufstriche ausgewählt
                } else {
                    Section(header: Text("Aufstrich").fontWeight(.semibold)) {
                        ForEach(spreadOptions, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption)
                        
                    }
                    .onAppear(perform: determineColor)
                }
                
                let spread2Options = isButtonPressed ? filterOptions(options: settings.spreadsOptions2, counts: settings.selectedSpreadsCounts2) : settings.spreadsOptions2
                if spread2Options.isEmpty {
                    
                } else {
                    Section(header: Text("Aufstrich 2").fontWeight(.semibold)) {
                        ForEach(spread2Options, id: \.self) { spread2 in
                            Stepper("\(spread2) (\(max(0, settings.selectedSpreadsCounts2[spread2] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts2[spread2] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts2[spread2] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts2[spread2] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption2)
                        
                    }
                }
                
                let specialsOptions = isButtonPressed ? filterOptions(options: settings.specialsOptions, counts: settings.selectedSpecialsCounts) : settings.specialsOptions
                if specialsOptions.isEmpty {
                    // Keine Specials ausgewählt
                } else {
                    Section(header: Text("Specials").fontWeight(.semibold)) {
                        ForEach(specialsOptions, id: \.self) { specials in
                            Stepper("\(specials) (\(max(0, settings.selectedSpecialsCounts[specials] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpecialsCounts[specials] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpecialsCounts[specials] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpecialsCounts[specials] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpecialsOption)
                        
                    }
                }
                
                if isButtonPressed == true && settings.selectedTeaFlavor == "Nichts" && settings.selectedCoffeeFlavor == "Nichts" && settings.fruitSelection == "Nichts" {
                    // Nichts ausgewählt
                } else {
                    Section(header: Text("Getränke und Obst").fontWeight(.semibold)) {
                        Picker("Getränk und oder Obst auswählen", selection: $settings.drinkSelection) {
                            Text("Nichts").tag("Nichts")
                            Text("Tee").tag("Tee")
                            if settings.coffeeSelected == true {
                                Text("Kaffee").tag("Kaffee")
                            }
                            Text("Obst").tag("Obst")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if settings.drinkSelection == "Tee" {
                            Picker("Teesorte auswählen", selection: $settings.selectedTeaFlavor) {
                                ForEach(settings.teaOptions, id: \.self) { tea in
                                    Text(tea).tag(tea)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection == "Obst" {
                            Picker("Obst auswählen", selection: $settings.fruitSelection) {
                                ForEach(settings.fruitOptions, id: \.self) { fruit in
                                    Text(fruit).tag(fruit)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection == "Kaffee" {
                            Picker("Kaffee auswählen", selection: $settings.selectedCoffeeFlavor) {
                                ForEach(settings.coffeeOptions, id: \.self) { coffee in
                                    Text(coffee).tag(coffee)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                    }
                }
                
                let extrasOptions = isButtonPressed ? filterOptions(options: settings.extrasOptions, counts: settings.extrasOptionSelection) : settings.extrasOptions
                if extrasOptions.isEmpty && settings.extras.isEmpty {
                    // Keine Extras ausgewählt
                } else {
                    Section(header: Text("Extras").fontWeight(.semibold)) {
                        ForEach(extrasOptions, id: \.self) { extras in
                            Stepper("\(extras) (\(max(0, settings.extrasOptionSelection[extras] ?? 0)))", value: Binding(
                                get: { max(0, settings.extrasOptionSelection[extras] ?? 0) },
                                set: { newValue in
                                    settings.extrasOptionSelection[extras] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.extrasOptionSelection[extras] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteExtrasOption)
                        TextField("Bitte Extras eingeben", text: $settings.extras)
                            .frame(height: 200, alignment: .top)
                            .submitLabel(.done)
                    }
                }
                
                if isButtonPressed == true && settings.restrictions1 == "Keine" && breadOptions.isEmpty && spreadOptions.isEmpty && spread2Options.isEmpty && specialsOptions.isEmpty && settings.selectedTeaFlavor == "Nichts" && settings.selectedCoffeeFlavor == "Nichts" && settings.fruitSelection == "Nichts" && extrasOptions.isEmpty && settings.extras.isEmpty {
                    Button(action: {
                        isButtonPressed.toggle()
                    }, label: {
                            Text("Bestellung ist leer 🙈")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 100)
                                .background(.red)
                                .contentShape(Rectangle())
                                .cornerRadius(12)
                    })
                }
            }
            
            if patientSelection.patientSelection == "P2" {
                let breadOptions = isButtonPressed ? filterOptions(options: settings.breadOptions, counts: settings.selectedBreadCounts2) : settings.breadOptions
                if breadOptions.isEmpty {
                    // Kein Brot ausgewählt
                } else {
                    Section(header: Text("Brot").fontWeight(.semibold)) {
                        ForEach(breadOptions, id: \.self) { bread in
                            Stepper("\(bread) (\(max(0, settings.selectedBreadCounts2[bread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedBreadCounts2[bread] ?? 0) },
                                set: { newValue in
                                    settings.selectedBreadCounts2[bread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                                
                            ))
                            .onAppear(perform: determineColor)
                            .foregroundColor(settings.selectedBreadCounts2[bread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteBreadOption)
                    }
                }
                
                let spreadsOptions = isButtonPressed ? filterOptions(options: settings.spreadsOptions, counts: settings.selectedSpreadsCounts_2) : settings.spreadsOptions
                if spreadsOptions.isEmpty {
                    // Keine Aufstriche ausgewählt
                } else {
                    Section(header: Text("Aufstrich").fontWeight(.semibold)) {
                        ForEach(spreadsOptions, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts_2[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts_2[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts_2[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts_2[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption)
                        
                    }
                }
                
                let spreadsOptions2 = isButtonPressed ? filterOptions(options: settings.spreadsOptions2, counts: settings.selectedSpreadsCounts2_2) : settings.spreadsOptions2
                if spreadsOptions2.isEmpty {
                    // Keine Aufstriche2 ausgewählt
                } else {
                    Section(header: Text("Aufstrich 2").fontWeight(.semibold)) {
                        ForEach(spreadsOptions2, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts2_2[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts2_2[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts2_2[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts2_2[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption2)
                    }
                }
                
                let specialsOptions = isButtonPressed ? filterOptions(options: settings.specialsOptions, counts: settings.selectedSpecialsCounts2) : settings.specialsOptions
                if specialsOptions.isEmpty {
                    // Keine Specials ausgewählt
                } else {
                    Section(header: Text("Specials").fontWeight(.semibold)) {
                        ForEach(specialsOptions, id: \.self) { specials in
                            Stepper("\(specials) (\(max(0, settings.selectedSpecialsCounts2[specials] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpecialsCounts2[specials] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpecialsCounts2[specials] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpecialsCounts2[specials] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpecialsOption)
                    }
                }
                
                if isButtonPressed == true && settings.selectedTeaFlavor2 == "Nichts" && settings.selectedCoffeeFlavor2 == "Nichts" && settings.fruitSelection2 == "Nichts" {
                    // Nichts ausgewählr
                } else {
                    Section(header: Text("Getränke und Obst").fontWeight(.semibold)) {
                        Picker("Getränk und oder Obst auswählen", selection: $settings.drinkSelection2) {
                            Text("Nichts").tag("Nichts")
                            Text("Tee").tag("Tee")
                            if settings.coffeeSelected == true {
                                Text("Kaffee").tag("Kaffee")
                            }
                            Text("Obst").tag("Obst")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if settings.drinkSelection2 == "Tee" {
                            Picker("Teesorte auswählen", selection: $settings.selectedTeaFlavor2) {
                                ForEach(settings.teaOptions, id: \.self) { tea in
                                    Text(tea).tag(tea)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection2 == "Obst" {
                            Picker("Obst auswählen", selection: $settings.fruitSelection2) {
                                ForEach(settings.fruitOptions, id: \.self) { fruit in
                                    Text(fruit).tag(fruit)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection2 == "Kaffee" {
                            Picker("Kaffee auswählen", selection: $settings.selectedCoffeeFlavor2) {
                                ForEach(settings.coffeeOptions, id: \.self) { coffee in
                                    Text(coffee).tag(coffee)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                    }
                }
                
                let extrasOptions = isButtonPressed ? filterOptions(options: settings.extrasOptions, counts: settings.extrasOptionSelection2) : settings.extrasOptions
                if extrasOptions.isEmpty && settings.extras2.isEmpty {
                    // Keine Extras ausgewählt
                } else {
                    Section(header: Text("Extras").fontWeight(.semibold)) {
                        ForEach(extrasOptions, id: \.self) { extras in
                            Stepper("\(extras) (\(max(0, settings.extrasOptionSelection2[extras] ?? 0)))", value: Binding(
                                get: { max(0, settings.extrasOptionSelection2[extras] ?? 0) },
                                set: { newValue in
                                    settings.extrasOptionSelection2[extras] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.extrasOptionSelection2[extras] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteExtrasOption)
                        TextField("Bitte Extras eingeben", text: $settings.extras2)
                            .frame(height: 200, alignment: .top)
                            .submitLabel(.done)
                    }
                }
                if isButtonPressed == true && settings.restrictions2 == "Keine" && breadOptions.isEmpty && spreadsOptions.isEmpty && spreadsOptions2.isEmpty && specialsOptions.isEmpty && settings.selectedTeaFlavor2 == "Nichts" && settings.selectedCoffeeFlavor2 == "Nichts" && settings.fruitSelection2 == "Nichts" && extrasOptions.isEmpty && settings.extras2.isEmpty {
                    Button(action: {
                        isButtonPressed.toggle()
                    }, label: {
                            Text("Bestellung ist leer 🙈")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 100)
                                .background(.red)
                                .contentShape(Rectangle())
                                .cornerRadius(12)
                    })
                }
            }
            
            if patientSelection.patientSelection == "P3" {
                let breadOptions = isButtonPressed ? filterOptions(options: settings.breadOptions, counts: settings.selectedBreadCounts3) : settings.breadOptions
                if breadOptions.isEmpty {
                    // Kein Brot ausgewählt
                } else {
                    Section(header: Text("Brot").fontWeight(.semibold)) {
                        ForEach(breadOptions, id: \.self) { bread in
                            Stepper("\(bread) (\(max(0, settings.selectedBreadCounts3[bread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedBreadCounts3[bread] ?? 0) },
                                set: { newValue in
                                    settings.selectedBreadCounts3[bread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .onAppear(perform: determineColor)
                            .foregroundColor(settings.selectedBreadCounts3[bread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteBreadOption)
                    }
                }
                
                let spreadsOptions = isButtonPressed ? filterOptions(options: settings.spreadsOptions, counts: settings.selectedSpreadsCounts_3) : settings.spreadsOptions
                if spreadsOptions.isEmpty {
                    // Keine Aufstriche ausgewählt
                } else {
                    Section(header: Text("Aufstrich").fontWeight(.semibold)) {
                        ForEach(spreadsOptions, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts_3[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts_3[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts_3[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts_3[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption)
                    }
                }
                
                let spreadsOptions2 = isButtonPressed ? filterOptions(options: settings.spreadsOptions2, counts: settings.selectedSpreadsCounts2_3) : settings.spreadsOptions2
                if spreadsOptions2.isEmpty {
                    // Keine Aufstriche2 ausgewählt
                } else {
                    Section(header: Text("Aufstrich 2").fontWeight(.semibold)) {
                        ForEach(spreadsOptions2, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts2_3[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts2_3[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts2_3[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts2_3[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption2)
                    }
                }
                
                let specialsOptions = isButtonPressed ? filterOptions(options: settings.specialsOptions, counts: settings.selectedSpecialsCounts3) : settings.specialsOptions
                if specialsOptions.isEmpty {
                    // Keine Specials ausgewählt
                } else {
                    Section(header: Text("Specials").fontWeight(.semibold)) {
                        ForEach(specialsOptions, id: \.self) { specials in
                            Stepper("\(specials) (\(max(0, settings.selectedSpecialsCounts3[specials] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpecialsCounts3[specials] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpecialsCounts3[specials] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpecialsCounts3[specials] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpecialsOption)
                    }
                }
                
                if isButtonPressed == true && settings.selectedTeaFlavor3 == "Nichts" && settings.selectedCoffeeFlavor3 == "Nichts" && settings.fruitSelection3 == "Nichts" {
                    // Nichts ausgewählt
                } else {
                    Section(header: Text("Getränke und Obst").fontWeight(.semibold)) {
                        Picker("Getränk und oder Obst auswählen", selection: $settings.drinkSelection3) {
                            Text("Nichts").tag("Nichts")
                            Text("Tee").tag("Tee")
                            if settings.coffeeSelected == true {
                                Text("Kaffee").tag("Kaffee")
                            }
                            Text("Obst").tag("Obst")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if settings.drinkSelection3 == "Tee" {
                            Picker("Teesorte auswählen", selection: $settings.selectedTeaFlavor3) {
                                ForEach(settings.teaOptions, id: \.self) { tea in
                                    Text(tea).tag(tea)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection3 == "Obst" {
                            Picker("Obst auswählen", selection: $settings.fruitSelection3) {
                                ForEach(settings.fruitOptions, id: \.self) { fruit in
                                    Text(fruit).tag(fruit)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection3 == "Kaffee" {
                            Picker("Kaffee auswählen", selection: $settings.selectedCoffeeFlavor3) {
                                ForEach(settings.coffeeOptions, id: \.self) { coffee in
                                    Text(coffee).tag(coffee)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                    }
                }
                
                let extrasOptions = isButtonPressed ? filterOptions(options: settings.extrasOptions, counts: settings.extrasOptionSelection3) : settings.extrasOptions
                if extrasOptions.isEmpty && settings.extras3.isEmpty {
                    // Keine Extras ausgewählt
                } else {
                    Section(header: Text("Extras").fontWeight(.semibold)) {
                        ForEach(extrasOptions, id: \.self) { extras in
                            Stepper("\(extras) (\(max(0, settings.extrasOptionSelection3[extras] ?? 0)))", value: Binding(
                                get: { max(0, settings.extrasOptionSelection3[extras] ?? 0) },
                                set: { newValue in
                                    settings.extrasOptionSelection3[extras] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.extrasOptionSelection3[extras] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteExtrasOption)
                        TextField("Bitte Extras eingeben", text: $settings.extras3)
                            .frame(height: 200, alignment: .top)
                            .submitLabel(.done)
                    }
                }
                if isButtonPressed == true && settings.restrictions3 == "Keine" && breadOptions.isEmpty && spreadsOptions.isEmpty && spreadsOptions2.isEmpty && specialsOptions.isEmpty && settings.selectedTeaFlavor3 == "Nichts" && settings.selectedCoffeeFlavor3 == "Nichts" && settings.fruitSelection3 == "Nichts" && extrasOptions.isEmpty && settings.extras3.isEmpty {
                    Button(action: {
                        isButtonPressed.toggle()
                    }, label: {
                            Text("Bestellung ist leer 🙈")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 100)
                                .background(.red)
                                .contentShape(Rectangle())
                                .cornerRadius(12)
                    })
                }
            }
            
            if patientSelection.patientSelection == "P4" {
                let breadOptions = isButtonPressed ? filterOptions(options: settings.breadOptions, counts: settings.selectedBreadCounts4) : settings.breadOptions
                if breadOptions.isEmpty {
                    // Kein Brot ausgewählt
                } else {
                    Section(header: Text("Brot").fontWeight(.semibold)) {
                        ForEach(breadOptions, id: \.self) { bread in
                            Stepper("\(bread) (\(max(0, settings.selectedBreadCounts4[bread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedBreadCounts4[bread] ?? 0) },
                                set: { newValue in
                                    settings.selectedBreadCounts4[bread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .onAppear(perform: determineColor)
                            .foregroundColor(settings.selectedBreadCounts4[bread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteBreadOption)
                    }
                }
                
                let spreadsOptions = isButtonPressed ? filterOptions(options: settings.spreadsOptions, counts: settings.selectedSpreadsCounts_4) : settings.spreadsOptions
                if spreadsOptions.isEmpty {
                    // Keine Aufstriche ausgewählt
                } else {
                    Section(header: Text("Aufstrich").fontWeight(.semibold)) {
                        ForEach(spreadsOptions, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts_4[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts_4[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts_4[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts_4[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption)
                    }
                }
                
                let spreadsOptions2 = isButtonPressed ? filterOptions(options: settings.spreadsOptions2, counts: settings.selectedSpreadsCounts2_4) : settings.spreadsOptions2
                if spreadsOptions2.isEmpty {
                    // Keine Aufstriche2 ausgewählt
                } else {
                    Section(header: Text("Aufstrich 2").fontWeight(.semibold)) {
                        ForEach(spreadsOptions2, id: \.self) { spread in
                            Stepper("\(spread) (\(max(0, settings.selectedSpreadsCounts2_4[spread] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpreadsCounts2_4[spread] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpreadsCounts2_4[spread] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpreadsCounts2_4[spread] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpreadOption2)
                    }
                }
                
                let specialsOptions = isButtonPressed ? filterOptions(options: settings.specialsOptions, counts: settings.selectedSpecialsCounts4) : settings.specialsOptions
                if specialsOptions.isEmpty {
                    // Keine Specials ausgewählt
                } else {
                    Section(header: Text("Specials").fontWeight(.semibold)) {
                        ForEach(specialsOptions, id: \.self) { specials in
                            Stepper("\(specials) (\(max(0, settings.selectedSpecialsCounts4[specials] ?? 0)))", value: Binding(
                                get: { max(0, settings.selectedSpecialsCounts4[specials] ?? 0) },
                                set: { newValue in
                                    settings.selectedSpecialsCounts4[specials] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.selectedSpecialsCounts4[specials] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteSpecialsOption)
                    }
                }
                
                if isButtonPressed == true && settings.selectedTeaFlavor4 == "Nichts" && settings.selectedCoffeeFlavor4 == "Nichts" && settings.fruitSelection4 == "Nichts" {
                    // Keine Auswahl
                } else {
                    Section(header: Text("Getränke und Obst").fontWeight(.semibold)) {
                        Picker("Getränk und oder Obst auswählen", selection: $settings.drinkSelection4) {
                            Text("Nichts").tag("Nichts")
                            Text("Tee").tag("Tee")
                            if settings.coffeeSelected == true {
                                Text("Kaffee").tag("Kaffee")
                            }
                            Text("Obst").tag("Obst")
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        if settings.drinkSelection4 == "Tee" {
                            Picker("Teesorte auswählen", selection: $settings.selectedTeaFlavor4) {
                                ForEach(settings.teaOptions, id: \.self) { tea in
                                    Text(tea).tag(tea)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection4 == "Obst" {
                            Picker("Obst auswählen", selection: $settings.fruitSelection4) {
                                ForEach(settings.fruitOptions, id: \.self) { fruit in
                                    Text(fruit).tag(fruit)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                        } else if settings.drinkSelection4 == "Kaffee" {
                            Picker("Kaffee auswählen", selection: $settings.selectedCoffeeFlavor4) {
                                ForEach(settings.coffeeOptions, id: \.self) { coffee in
                                    Text(coffee).tag(coffee)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                        }
                    }
                }
                
                let extrasOptions = isButtonPressed ? filterOptions(options: settings.extrasOptions, counts: settings.extrasOptionSelection4) : settings.extrasOptions
                if extrasOptions.isEmpty {
                    // Keine Extras ausgewählt
                } else {
                    Section(header: Text("Extras").fontWeight(.semibold)) {
                        ForEach(extrasOptions, id: \.self) { extras in
                            Stepper("\(extras) (\(max(0, settings.extrasOptionSelection4[extras] ?? 0)))", value: Binding(
                                get: { max(0, settings.extrasOptionSelection4[extras] ?? 0) },
                                set: { newValue in
                                    settings.extrasOptionSelection4[extras] = max(0, newValue)
                                    // Vibration hinzufügen
                                    let generator = UINotificationFeedbackGenerator()
                                    generator.notificationOccurred(.success)
                                }
                            ))
                            .foregroundColor(settings.extrasOptionSelection4[extras] ?? 0 >= 1 ? color : .primary)
                        }
                        .onDelete(perform: settings.deleteExtrasOption)
                        TextField("Bitte Extras eingeben", text: $settings.extras4)
                            .frame(height: 200, alignment: .top)
                            .submitLabel(.done)
                    }
                }
                if isButtonPressed == true && settings.restrictions4 == "Keine" && breadOptions.isEmpty && spreadsOptions.isEmpty && spreadsOptions2.isEmpty && specialsOptions.isEmpty && settings.selectedTeaFlavor4 == "Nichts" && settings.selectedCoffeeFlavor4 == "Nichts" && settings.fruitSelection4 == "Nichts" && extrasOptions.isEmpty && settings.extras4.isEmpty {
                    Button(action: {
                        isButtonPressed.toggle()
                    }, label: {
                            Text("Bestellung ist leer 🙈")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 100)
                                .background(.red)
                                .contentShape(Rectangle())
                                .cornerRadius(12)
                    })
                }
            }
                        
            // MARK: Button Bestellungsview
            if isButtonPressed == false {
                Button(action: {
                    isButtonPressed.toggle()
                }, label: {
                    Text("Bestellübersicht anzeigen")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(Color.accentColor)
                        .contentShape(Rectangle())
                        .cornerRadius(12)
                })
            }
            
            Section("") {
            }
            .frame(height: 50)
        }
        .navigationBarTitle("Bestellung \(patientSelection.patientSelection)")
        .foregroundColor(color)
        .navigationBarItems(leading: Button(action: {
            // Erzeuge eine leichte Vibration
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
            isButtonPressed.toggle()
        }) {
            Image(systemName: "list.bullet.clipboard")
                .fontWeight(.bold)
        }, trailing: Button(action: {
            isResetConfirmationPresented.toggle()
        }) {
            Image(systemName: "trash")
                .fontWeight(.bold)
        })
        .actionSheet(isPresented: $isResetConfirmationPresented) {
            ActionSheet(title: Text("Welche Bestellung möchtest Du zurücksetzen?"), buttons: [
                .default(Text("Bestellung 1")) { resetSelections1() // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning) },
                .default(Text("Bestellung 2")) { resetSelections2() // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning) },
                .default(Text("Bestellung 3")) { resetSelections3() // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning) },
                .default(Text("Bestellung 4")) { resetSelections4() // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning) },
                .default(Text("Alle Bestellungen")) { resetAllSelections() // Vibration hinzufügen
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.warning) },
                .cancel(Text("Abbrechen"))
            ])
        }
        .accentColor(color) // Farbe auch vom Picker jetzt in der richtigen Patientenfarbe anzeigen
        .background(validateBackgroundColor())
    }
    
    
    func resetAllSelections() {
        
        settings.restrictions1 = "Keine"
        settings.restrictions2 = "Keine"
        settings.restrictions3 = "Keine"
        settings.restrictions4 = "Keine"
        
        patientSelection.patientSelection = "P1"
        patientSelection.foodIntolerance1 = "WK1"
        patientSelection.foodIntolerance2 = "WK2"
        patientSelection.foodIntolerance3 = "WK3"
        patientSelection.foodIntolerance4 = "WK4"
        
        settings.selectedBreadCounts.removeAll()
        settings.selectedBreadCounts2.removeAll()
        settings.selectedBreadCounts3.removeAll()
        settings.selectedBreadCounts4.removeAll()
        
        settings.selectedSpreadsCounts.removeAll()
        settings.selectedSpreadsCounts_2.removeAll()
        settings.selectedSpreadsCounts_3.removeAll()
        settings.selectedSpreadsCounts_4.removeAll()
        
        settings.selectedSpreadsCounts2.removeAll()
        settings.selectedSpreadsCounts2_2.removeAll()
        settings.selectedSpreadsCounts2_3.removeAll()
        settings.selectedSpreadsCounts2_4.removeAll()
        
        settings.selectedSpecialsCounts.removeAll()
        settings.selectedSpecialsCounts2.removeAll()
        settings.selectedSpecialsCounts3.removeAll()
        settings.selectedSpecialsCounts4.removeAll()
        
        settings.selectedTeaFlavor = "Nichts"
        settings.selectedTeaFlavor2 = "Nichts"
        settings.selectedTeaFlavor3 = "Nichts"
        settings.selectedTeaFlavor4 = "Nichts"
        
        settings.selectedCoffeeFlavor = "Nichts"
        settings.selectedCoffeeFlavor2 = "Nichts"
        settings.selectedCoffeeFlavor3 = "Nichts"
        settings.selectedCoffeeFlavor4 = "Nichts"
        
        settings.selectedFruitComposition = "Nichts"
        settings.selectedFruitComposition2 = "Nichts"
        settings.selectedFruitComposition3 = "Nichts"
        settings.selectedFruitComposition4 = "Nichts"
        
        settings.drinkSelection = "Nichts"
        settings.drinkSelection2 = "Nichts"
        settings.drinkSelection3 = "Nichts"
        settings.drinkSelection4 = "Nichts"
        
        settings.fruitSelection = "Nichts"
        settings.fruitSelection2 = "Nichts"
        settings.fruitSelection3 = "Nichts"
        settings.fruitSelection4 = "Nichts"
        
        settings.extrasOptionSelection.removeAll()
        settings.extrasOptionSelection2.removeAll()
        settings.extrasOptionSelection3.removeAll()
        settings.extrasOptionSelection4.removeAll()
        
        settings.extras = ""
        settings.extras2 = ""
        settings.extras3 = ""
        settings.extras4 = ""
        
        isButtonPressed = false
    }
    
    func resetSelections1() {
        
        settings.restrictions1 = "Keine"
        
        patientSelection.foodIntolerance1 = "WK1"
        
        settings.selectedBreadCounts.removeAll()
        
        settings.selectedSpreadsCounts.removeAll()
        
        settings.selectedSpreadsCounts2.removeAll()
        
        settings.selectedSpecialsCounts.removeAll()
        
        settings.selectedTeaFlavor = "Nichts"
        
        settings.selectedCoffeeFlavor = "Nichts"
        
        settings.selectedFruitComposition = "Nichts"
        
        settings.drinkSelection = "Nichts"
        
        settings.fruitSelection = "Nichts"
        
        settings.extrasOptionSelection.removeAll()
        
        settings.extras = ""
        
    }
    
    func resetSelections2() {
        
        settings.restrictions2 = "Keine"
        
        patientSelection.foodIntolerance2 = "WK2"
        
        settings.selectedBreadCounts2.removeAll()
        
        settings.selectedSpreadsCounts_2.removeAll()
        
        settings.selectedSpreadsCounts2_2.removeAll()
        
        settings.selectedSpecialsCounts2.removeAll()
        
        settings.selectedTeaFlavor2 = "Nichts"
        
        settings.selectedCoffeeFlavor2 = "Nichts"
        
        settings.selectedFruitComposition2 = "Nichts"
        
        settings.drinkSelection2 = "Nichts"
        
        settings.fruitSelection2 = "Nichts"
        
        settings.extrasOptionSelection2.removeAll()
        
        settings.extras2 = ""
        
    }
    
    func resetSelections3() {
        
        settings.restrictions3 = "Keine"
        
        patientSelection.foodIntolerance3 = "WK3"
        
        settings.selectedBreadCounts3.removeAll()
        
        settings.selectedSpreadsCounts_3.removeAll()
        
        settings.selectedSpreadsCounts2_3.removeAll()
        
        settings.selectedSpecialsCounts3.removeAll()
        
        settings.selectedTeaFlavor3 = "Nichts"
        
        settings.selectedCoffeeFlavor3 = "Nichts"
        
        settings.selectedFruitComposition3 = "Nichts"
        
        settings.drinkSelection3 = "Nichts"
        
        settings.fruitSelection3 = "Nichts"
        
        settings.extrasOptionSelection3.removeAll()
        
        settings.extras3 = ""
        
    }
    
    func resetSelections4() {
        
        settings.restrictions4 = "Keine"
        
        patientSelection.foodIntolerance4 = "WK4"
        
        settings.selectedBreadCounts4.removeAll()
        
        settings.selectedSpreadsCounts_4.removeAll()
        
        settings.selectedSpreadsCounts2_4.removeAll()
        
        settings.selectedSpecialsCounts4.removeAll()
        
        settings.selectedTeaFlavor4 = "Nichts"
        
        settings.selectedCoffeeFlavor4 = "Nichts"
        
        settings.selectedFruitComposition4 = "Nichts"
        
        settings.drinkSelection4 = "Nichts"
        
        settings.fruitSelection4 = "Nichts"
        
        settings.extrasOptionSelection4.removeAll()
        
        settings.extras4 = ""
        
    }
    
    func determineColor() {
        if patientSelection.patientSelection == "P1" {
            color = Color.accent
        }
        
        if patientSelection.patientSelection == "P2" {
            color = Color.purple
        }
        
        if patientSelection.patientSelection == "P3" {
            color = Color.red
        }
        
        if patientSelection.patientSelection == "P4" {
            color = Color.green
        }
    }
    
    func validateBackgroundColor() -> Color {
        return settings.validateSelections() ? Color.purple.opacity(0.2) : Color.white
    }
}

#Preview {
    OrderFormView(settings: Settings(), patientSelection: patientSelectionManager())
}


