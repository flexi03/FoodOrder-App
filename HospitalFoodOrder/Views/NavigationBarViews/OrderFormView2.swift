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
    @State private var isButtonPressed = false
    @State private var showingPatientCountPicker = false

    var body: some View {
        VStack {
            HStack {
                Text("Patient \(patientSelection.patientSelection) von \(settings.numberOfPatients)")
                    .font(.headline)
                Spacer()
                Button(action: {
                    showingPatientCountPicker = true
                }) {
                    Image(systemName: "person.3")
                    Text("Ändern")
                }
            }
            .padding()

            TabView(selection: $patientSelection.patientSelection) {
                ForEach(1...settings.numberOfPatients, id: \.self) { patientNumber in
                    patientView(for: patientNumber)
                        .tag(patientNumber)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .onChange(of: settings.numberOfPatients) { newValue in
            if patientSelection.patientSelection > newValue {
                patientSelection.patientSelection = newValue
            }
        }
        .sheet(isPresented: $showingPatientCountPicker) {
            PatientCountPickerView(numberOfPatients: $settings.numberOfPatients)
        }
    }
    
    @ViewBuilder
    private func patientView(for patientNumber: Int) -> some View {
        Form {
            createRestrictionsSection(patientNumber: patientNumber)
            createSection(name: "Brot", category: "bread", patientNumber: patientNumber)
            createSection(name: "Aufstrich", category: "spreads", patientNumber: patientNumber)
            createSection(name: "Aufstrich 2", category: "spreads2", patientNumber: patientNumber)
            createSection(name: "Specials", category: "specials", patientNumber: patientNumber)
            createDrinkAndFruitSection(patientNumber: patientNumber)
            createSection(name: "Extras", category: "extras", patientNumber: patientNumber)
            
            Section {
                toggleOrderSummaryButton()
            }
            Section("") {
            }
            .frame(height: 50)
        }
        .navigationBarItems(leading: orderSummaryButton(), trailing: resetButton())
        .actionSheet(isPresented: $isResetConfirmationPresented) {
            createResetActionSheet()
        }
        .onChange(of: patientSelection.patientSelection) { _ in
            triggerHapticFeedback()
        }
        .background(validateBackgroundColor())
    }
    
    
    
    @ViewBuilder
    func createSection(name: String, category: String, patientNumber: Int) -> some View {
        let counts = getCounts(for: category, patientNumber: patientNumber)
        let options = settings.optionCategories[category] ?? []
        let filteredOptions = isButtonPressed ? filterOptions(options: options, counts: counts) : options
        
        if !isButtonPressed || !filteredOptions.isEmpty || (category == "extras" && !(settings.extras[patientNumber] ?? "").isEmpty) {
            Section(header: Text(name).fontWeight(.semibold)) {
                ForEach(filteredOptions, id: \.self) { option in
                    createStepper(for: option, counts: counts, category: category, patientNumber: patientNumber)
                }
                
                if category == "extras" {
                    TextField("Bitte Extras eingeben", text: Binding<String>(
                        get: { settings.extras[patientNumber] ?? "" },
                        set: { newValue in
                            settings.extras[patientNumber] = newValue
                            settings.saveSelections()
                        }
                    ))
                    .frame(height: 100, alignment: .top)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
        } else {
            EmptyView()
        }
    }

    private func getCounts(for category: String, patientNumber: Int) -> [String: Int] {
        switch category {
        case "bread":
            return settings.breadCounts[patientNumber] ?? [:]
        case "spreads":
            return settings.spreadsCounts[patientNumber] ?? [:]
        case "spreads2":
            return settings.spreadsCounts2[patientNumber] ?? [:]
        case "specials":
            return settings.specialsCounts[patientNumber] ?? [:]
        case "extras":
            return settings.extrasCounts[patientNumber] ?? [:]
        default:
            return [:]
        }
    }

    
    @ViewBuilder
    func createStepper(for option: String, counts: [String: Int], category: String, patientNumber: Int) -> some View {
        let count = counts[option] ?? 0
        Stepper(onIncrement: {
            updateCount(for: option, in: category, patientNumber: patientNumber, increment: true)
        }, onDecrement: {
            updateCount(for: option, in: category, patientNumber: patientNumber, increment: false)
        }) {
            Text("\(option) (\(count))")
                .fontWeight(count >= 1 ? .semibold : .regular)
                .foregroundColor(count >= 1 ? .accentColor : .primary)
        }
    }
    
    private func updateCount(for option: String, in category: String, patientNumber: Int, increment: Bool) {
        var counts = getCounts(for: category, patientNumber: patientNumber)
        let currentCount = counts[option] ?? 0
        if increment {
            counts[option] = min(currentCount + 1, 10)
        } else {
            counts[option] = max(currentCount - 1, 0)
        }
        
        setCounts(counts, for: category, patientNumber: patientNumber)
        
        triggerHapticFeedback()
    }

    private func setCounts(_ counts: [String: Int], for category: String, patientNumber: Int) {
        switch category {
        case "bread":
            settings.breadCounts[patientNumber] = counts
        case "spreads":
            settings.spreadsCounts[patientNumber] = counts
        case "spreads2":
            settings.spreadsCounts2[patientNumber] = counts
        case "specials":
            settings.specialsCounts[patientNumber] = counts
        case "extras":
            settings.extrasCounts[patientNumber] = counts
        default:
            break
        }
        settings.saveSelections()
    }
    
    @ViewBuilder
    func createRestrictionsSection(patientNumber: Int) -> some View {
        if settings.showRestrictions {
            let restriction = settings.restrictions[patientNumber] ?? "Keine"
            if !isButtonPressed || restriction != "Keine" {
                Section(header: Text("Einschränkungen").fontWeight(.semibold)) {
                    Picker("Einschränkungen", selection: Binding<String>(
                        get: { restriction },
                        set: { settings.restrictions[patientNumber] = $0 }
                    )) {
                        Text("Keine").tag("Keine")
                        Text("Schnabelbecher").tag("Schnabelbecher")
                        Text("Schmieren").tag("Schmieren")
                        Text("Schnabelbecher & Schmieren").tag("Schnabelbecher & Schmieren")
                    }
                }
            }
        }
    }
    

    @ViewBuilder
    func createDrinkAndFruitSection(patientNumber: Int) -> some View {
        let teaQuantities = settings.teaQuantities[patientNumber] ?? [:]
        let coffeeQuantities = settings.coffeeQuantities[patientNumber] ?? [:]
        let fruitQuantities = settings.fruitQuantities[patientNumber] ?? [:]
        
        // Tea Section
        createQuantitySelectionPicker(
            for: "tea",
            quantities: Binding<[String: Int]>(
                get: { teaQuantities },
                set: { settings.teaQuantities[patientNumber] = $0 }
            ),
            title: "Tee auswählen",
            isFiltered: isButtonPressed
        )
        
        // Coffee Section (only if coffee is selected)
        if settings.coffeeSelected {
            createQuantitySelectionPicker(
                for: "coffee",
                quantities: Binding<[String: Int]>(
                    get: { coffeeQuantities },
                    set: { settings.coffeeQuantities[patientNumber] = $0 }
                ),
                title: "Kaffee auswählen",
                isFiltered: isButtonPressed
            )
        }
        
        // Fruit Section
        createQuantitySelectionPicker(
            for: "fruit",
            quantities: Binding<[String: Int]>(
                get: { fruitQuantities },
                set: { settings.fruitQuantities[patientNumber] = $0 }
            ),
            title: "Obst auswählen",
            isFiltered: isButtonPressed
        )
    }

    @ViewBuilder
    func createQuantitySelectionPicker(for category: String, quantities: Binding<[String: Int]>, title: String, isFiltered: Bool) -> some View {
        let options = settings.optionCategories[category] ?? []
        let filteredOptions = isFiltered ? options.filter { quantities.wrappedValue[$0, default: 0] > 0 } : options
        
        if !isFiltered || !filteredOptions.isEmpty {
            Section(header: Text("Getränke und Obst")) {
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(filteredOptions, id: \.self) { option in
                                if option != "Nichts" {
                                    VStack {
                                        Text(option)
                                        Stepper(
                                            onIncrement: {
                                                updateDrinkAndFruitCount(for: option, in: category, patientNumber: patientSelection.patientSelection, increment: true)
                                            },
                                            onDecrement: {
                                                updateDrinkAndFruitCount(for: option, in: category, patientNumber: patientSelection.patientSelection, increment: false)
                                            }
                                        ) {
                                            Text("\(quantities.wrappedValue[option, default: 0])")
                                        }
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(quantities.wrappedValue[option, default: 0] > 0 ? Color.accentColor : Color.secondary.opacity(0.2))
                                    .foregroundColor(quantities.wrappedValue[option, default: 0] > 0 ? .white : .primary)
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func updateDrinkAndFruitCount(for option: String, in category: String, patientNumber: Int, increment: Bool) {
        switch category {
        case "tea":
            var counts = settings.teaQuantities[patientNumber] ?? [:]
            updateCount(in: &counts, for: option, increment: increment)
            settings.teaQuantities[patientNumber] = counts
        case "coffee":
            var counts = settings.coffeeQuantities[patientNumber] ?? [:]
            updateCount(in: &counts, for: option, increment: increment)
            settings.coffeeQuantities[patientNumber] = counts
        case "fruit":
            var counts = settings.fruitQuantities[patientNumber] ?? [:]
            updateCount(in: &counts, for: option, increment: increment)
            settings.fruitQuantities[patientNumber] = counts
        default:
            break
        }
        settings.saveSelections()
        triggerHapticFeedback()
    }

    private func updateCount(in counts: inout [String: Int], for option: String, increment: Bool) {
        let currentCount = counts[option, default: 0]
        if increment {
            counts[option] = min(currentCount + 1, 10)
        } else {
            counts[option] = max(currentCount - 1, 0)
        }
    }
        @ViewBuilder
        func createQuantitySummary(for quantities: [String: Int]) -> some View {
            let selectedItems = quantities.filter { $0.value > 0 }
            if !selectedItems.isEmpty {
                VStack(alignment: .leading) {
                    Text("Zusammenfassung:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    ForEach(selectedItems.sorted(by: { $0.key < $1.key }), id: \.key) { item, quantity in
                        Text("\(item): \(quantity)")
                            .font(.footnote)
                    }
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
            }
        }

    
    @ViewBuilder
    func createExtrasSection(patientNumber: Int) -> some View {
        let options = settings.optionCategories["extras"] ?? []
        let counts = settings.extrasCounts[patientNumber] ?? [:]
        let extraText = settings.extras[patientNumber] ?? ""
        let filteredOptions = isButtonPressed ? filterOptions(options: options, counts: counts) : options
        
        if !isButtonPressed || !filteredOptions.isEmpty || !extraText.isEmpty {
            Section(header: Text("Extras").fontWeight(.semibold)) {
                ForEach(filteredOptions, id: \.self) { option in
                    createStepper(for: option, counts: counts, category: "extras", patientNumber: patientNumber)
                }
                
                TextField("Bitte Extras eingeben", text: Binding<String>(
                    get: { extraText },
                    set: { settings.extras[patientNumber] = $0 }
                ))
                .frame(height: 200, alignment: .top)
                .submitLabel(.done)
            }
        }
    }
    
    @ViewBuilder
    func toggleOrderSummaryButton() -> some View {
        Button(action: {
            isButtonPressed.toggle()
        }, label: {
            Text(isButtonPressed ? "Bestellübersicht ausblenden" : "Bestellübersicht anzeigen")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 25)
                .background(isButtonPressed ? Color.red : Color.accentColor)
                .contentShape(Rectangle())
                .cornerRadius(12)
        })
    }
    
    func orderSummaryButton() -> some View {
        Button(action: {
            triggerHapticFeedback()
            isButtonPressed.toggle()
        }) {
            Image(systemName: "list.bullet.clipboard")
                .fontWeight(.bold)
        }
    }
    
    func resetButton() -> some View {
        Button(action: {
            isResetConfirmationPresented.toggle()
        }) {
            Image(systemName: "trash")
                .fontWeight(.bold)
        }
    }
    
    func createResetActionSheet() -> ActionSheet {
        var buttons: [ActionSheet.Button] = (1...settings.numberOfPatients).map { patientNumber in
            .default(Text("Bestellung \(patientNumber)")) {
                settings.resetSelections(for: patientNumber)
                triggerHapticFeedback(.warning)
            }
        }
        buttons.append(.default(Text("Alle Bestellungen")) {
            settings.resetAllSelections()
            patientSelection.patientSelection = 1
            isButtonPressed = false
            triggerHapticFeedback(.warning)
        })
        buttons.append(.cancel(Text("Abbrechen")))
        
        return ActionSheet(title: Text("Welche Bestellung möchtest Du zurücksetzen?"), buttons: buttons)
    }
    
    func filterOptions(options: [String], counts: [String: Int]) -> [String] {
        return options.filter { counts[$0] ?? 0 > 0 }
    }
    
    func triggerHapticFeedback(_ style: UINotificationFeedbackGenerator.FeedbackType = .success) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(style)
    }
    
    func validateBackgroundColor() -> Color {
        return settings.validateSelections() ? Color.purple.opacity(0.2) : Color.white
    }
    
    @ViewBuilder
    func createMultiSelectionPicker(for category: String, selection: Binding<[String]>, title: String) -> some View {
        let options = settings.optionCategories[category] ?? []
        
        MultiSelectionPicker(title: title, options: options, selection: selection)
    }
}

struct MultiSelectionPicker: View {
    let title: String
    let options: [String]
    @Binding var selection: [String]

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(options, id: \.self) { option in
                        if option != "Nichts" {
                            Button(action: {
                                if selection.contains(option) {
                                    selection.removeAll { $0 == option }
                                } else {
                                    selection.append(option)
                                }
                            }) {
                                Text(option)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(selection.contains(option) ? Color.accentColor : Color.secondary.opacity(0.2))
                                    .foregroundColor(selection.contains(option) ? .white : .primary)
                                    .cornerRadius(15)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct PatientCountPickerView: View {
    @Binding var numberOfPatients: Int
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Picker("Anzahl der Patienten", selection: $numberOfPatients) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
            }
            .navigationTitle("Patienten Anzahl")
            .navigationBarItems(trailing: Button("Fertig") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct OrderFormView2_Previews: PreviewProvider {
    static var previews: some View {
        OrderFormView2(settings: Settings(), patientSelection: patientSelectionManager())
    }
}
