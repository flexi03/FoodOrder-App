//
//  OrderFormView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 23.11.23.
//

import SwiftUI


struct OrderFormView2: View {
    
    @ObservedObject var settings: Settings
    @ObservedObject var patientSelection: patientSelectionManager
    
    @State private var isResetConfirmationPresented: Bool = false
    @State private var isResetAllConfirmationPresented: Bool = false
        
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
                    ForEach(1..<5, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
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
            
            if patientSelection.patientSelection == 1 {
                createRestrictionsSection(restrictionSelection: $settings.restrictions1)
                createSection(name: "Brot", options: settings.breadOptions, counts: $settings.selectedBreadCounts2)
                createSection(name: "Aufstrich", options: settings.spreadsOptions, counts: $settings.selectedSpreadsCounts2)
                createSection(name: "Aufstrich 2", options: settings.spreadsOptions2, counts: $settings.selectedSpreadsCounts2_2)
                createSection(name: "Specials", options: settings.specialsOptions, counts: $settings.selectedSpecialsCounts2)
                if isButtonPressed && settings.selectedTeaFlavor == "Nichts" && settings.selectedCoffeeFlavor == "Nichts" && settings.fruitSelection == "Nichts" {
                    
                } else {
                    Section {
                        Text("Getränke und Obst")
                            .font(.headline)
                            .bold()
                            .padding(.leading)
                            .frame(alignment: .center)
                        Picker("Getränk und Obst", selection: $settings.drinkSelection) {
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
                createSection(name: "Extras", options: settings.extrasOptions, counts: $settings.extrasOptionSelection)
            }
            
            if patientSelection.patientSelection == 2 {
                createRestrictionsSection(restrictionSelection: $settings.restrictions2)
                createSection(name: "Brot", options: settings.breadOptions, counts: $settings.selectedBreadCounts)
                createSection(name: "Aufstrich", options: settings.spreadsOptions, counts: $settings.selectedSpreadsCounts)
                createSection(name: "Aufstrich 2", options: settings.spreadsOptions2, counts: $settings.selectedSpreadsCounts2)
                createSection(name: "Specials", options: settings.specialsOptions, counts: $settings.selectedSpecialsCounts)
                Section {
                    Text("Getränke und Obst ")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                        .frame(alignment: .center)
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
                createSection(name: "Extras", options: settings.extrasOptions, counts: $settings.extrasOptionSelection2)
            }
            
            if patientSelection.patientSelection == 3 {
                createRestrictionsSection(restrictionSelection: $settings.restrictions3)
                createSection(name: "Brot", options: settings.breadOptions, counts: $settings.selectedBreadCounts3)
                createSection(name: "Aufstrich", options: settings.spreadsOptions, counts: $settings.selectedSpreadsCounts_3)
                createSection(name: "Aufstrich 2", options: settings.spreadsOptions2, counts: $settings.selectedSpreadsCounts2_3)
                createSection(name: "Specials", options: settings.specialsOptions, counts: $settings.selectedSpecialsCounts3)
                Section {
                    Text("Getränke und Obst ")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                        .frame(alignment: .center)
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
                createSection(name: "Extras", options: settings.extrasOptions, counts: $settings.extrasOptionSelection3)
            }

            if patientSelection.patientSelection == 4 {
                createRestrictionsSection(restrictionSelection: $settings.restrictions4)
                createSection(name: "Brot", options: settings.breadOptions, counts: $settings.selectedBreadCounts4)
                createSection(name: "Aufstrich", options: settings.spreadsOptions, counts: $settings.selectedSpreadsCounts_4)
                createSection(name: "Aufstrich 2", options: settings.spreadsOptions2, counts: $settings.selectedSpreadsCounts2_4)
                createSection(name: "Specials", options: settings.specialsOptions, counts: $settings.selectedSpecialsCounts4)
                Section {
                    Text("Getränke und Obst ")
                        .font(.headline)
                        .bold()
                        .padding(.leading)
                        .frame(alignment: .center)
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
                createSection(name: "Extras", options: settings.extrasOptions, counts: $settings.extrasOptionSelection4)
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
                        .padding(.vertical, 25)
                        .background(Color.accentColor)
                        .contentShape(Rectangle())
                        .cornerRadius(12)
                })
            } else {
                Button(action: {
                    isButtonPressed.toggle()
                }, label: {
                    Text("Bestellübersicht ausblenden")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 25)
                        .background(Color.red)
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
    
    // MARK: Funktionen
    
    @ViewBuilder
    func createSection(name: String, options: [String], counts: Binding<[String: Int]>) -> some View {
        let filteredOptions = isButtonPressed ? filterOptions(options: options, counts: counts.wrappedValue) : options
        
        // Nur Section anzeigen, wenn filteredOptions nicht leer ist
        if !filteredOptions.isEmpty {
            Section(header: Text(name).fontWeight(.semibold)) {
                ForEach(filteredOptions.indices, id: \.self) { index in
                    let option = filteredOptions[index]
                    Stepper("\(option) (\(counts.wrappedValue[option] ?? 0))", value: Binding(
                        get: { counts.wrappedValue[option] ?? 0 },
                        set: { newValue in
                            var updatedCounts = counts.wrappedValue
                            updatedCounts[option] = newValue
                            counts.wrappedValue = updatedCounts
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                        }), in: 0...10)
                    .fontWeight(counts.wrappedValue[option] ?? 0 >= 1 ? .semibold : .regular)
                    .onAppear(perform: determineColor)
                    .foregroundColor(counts.wrappedValue[option] ?? 0 >= 1 ? color : .primary)
                }
                .onChange(of: counts.wrappedValue) { newValue in
                    determineColor()
                }
                // Geht noch nicht
//                if name == "Extras" {
//                    if counts ==  Binding<[settings.extrasOptionSelection]>.wrappedValue {
//                        TextField("Bitte Extras eingeben", text: $settings.extras)
//                            .frame(height: 200, alignment: .top)
//                            .submitLabel(.done)
//                    } else if Text(counts == $settings.extrasOptionSelection2) {
//                        TextField("Bitte Extras eingeben", text: $settings.extras2)
//                            .frame(height: 200, alignment: .top)
//                            .submitLabel(.done)
//                    } else if Text(counts == $settings.extrasOptionSelection3) {
//                        TextField("Bitte Extras eingeben", text: $settings.extras3)
//                            .frame(height: 200, alignment: .top)
//                            .submitLabel(.done)
//                    } else if Text(counts == $settings.extrasOptionSelection4) {
//                        TextField("Bitte Extras eingeben", text: $settings.extras4)
//                            .frame(height: 200, alignment: .top)
//                            .submitLabel(.done)
//                    }
//                }
            }
            //                .onDelete(perform: settings.deleteBreadOption)
        } else {
            // Wenn filteredOptions leer ist, eine leere View zurückgeben
            EmptyView()
        }
    }
    
    @ViewBuilder
    func createRestrictionsSection(restrictionSelection: Binding<String>) -> some View {
        if settings.showRestrictions == true {
            if isButtonPressed == false {
                Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                    Picker ("Einschränkungen", selection: restrictionSelection) {
                        Text("Keine").tag("Keine")
                        Text("Schnabelbecher").tag("Schnabelbecher")
                        Text("Schmieren").tag("Schmieren")
                        Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                    }
                }
            }
            if isButtonPressed == true && restrictionSelection.wrappedValue == "Keine" {
                // Nichts anzeigen
            } else if isButtonPressed == true && restrictionSelection.wrappedValue != "Keine" {
                Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                    Picker ("Einschränkungen", selection: restrictionSelection) {
                        Text("Keine").tag("Keine")
                        Text("Schnabelbecher").tag("Schnabelbecher")
                        Text("Schmieren").tag("Schmieren")
                        Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                    }
                }
            }
        }
    }
    
    
    func resetAllSelections() {
        
        resetSelections1()
        resetSelections2()
        resetSelections3()
        resetSelections4()
        
        patientSelection.patientSelection = 1
        
        isButtonPressed = false
    }
    
    func resetSelections1() {
        
        settings.restrictions1 = "Keine"
        
//        patientSelection.foodIntolerance1 = "WK1"
        
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
        
//        patientSelection.foodIntolerance2 = "WK2"
        
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
        
//        patientSelection.foodIntolerance3 = "WK3"
        
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
        
//        patientSelection.foodIntolerance4 = "WK4"
        
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
        if patientSelection.patientSelection == 1 {
            color = Color.accent
        }
        
        if patientSelection.patientSelection == 2 {
            color = Color.purple
        }
        
        if patientSelection.patientSelection == 3 {
            color = Color.red
        }
        
        if patientSelection.patientSelection == 4 {
            color = Color.green
        }
    }
    
    func validateBackgroundColor() -> Color {
        return settings.validateSelections() ? Color.purple.opacity(0.2) : Color.white
    }
}

#Preview {
    ContentView(colorScheme: ColorSchemeModel())
}


