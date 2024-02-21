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

            createSection("Brot", settings.breadOptions, &settings.selectedBreadCounts)
            
                        
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
    
    func createSection(_ name: String, _ options: [String], _ counts: inout [String: Int]) -> some View {
        let filteredOptions = isButtonPressed ? filterOptions(options: options, counts: counts) : options
        
//        var destination = counts // help needed
        return Section(header: Text(name)) {
            ForEach(filteredOptions, id: \.self) { option in
                Stepper("\(option) (\(counts[option] ?? 0))", value: Binding(
                    get: { counts[option] ?? 0 },
                    set: { newValue in
                        counts[option] = newValue
                        // Vibration hinzufügen
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                    }
                ), in: 0...10)
            }
        }
    }
    
    
    func resetAllSelections() {
        
        resetSelections1()
        resetSelections2()
        resetSelections3()
        resetSelections4()
        
        patientSelection.patientSelection = "P1"
        
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
    ContentView(colorScheme: ColorSchemeModel())
}


