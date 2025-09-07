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
    //@State private var isButtonPressed = false
    @State private var showingPatientCountPicker = false
    @State private var restrictionRingRotation: Double = 0
    @State private var isDeleteAllConfirmationPresented: Bool = false
    
    var body: some View {
        let _ = Self._printChanges()
        VStack {
            HStack {
                Text("Patient \(patientSelection.patientSelection) von \(settings.numberOfPatients)")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .frame(width: 160)
                    .background {
                        ZStack {
                            // Animated color wheel, masked to rounded rect like the tab bar
                            AnimatedColorWheelOverlay()
                                .mask(
                                    RoundedRectangle(cornerRadius: 30)
                                        .frame(width: 160, height: 50)
                                )
                                .blur(radius: 10)
                            // Add a subtle material over it to match the tab bar layering
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.ultraThinMaterial)
                                .frame(width: 160, height: 50)
                                .blur(radius: 2)
                        }
                    }
                Spacer()
                Button(action: {
                    showingPatientCountPicker = true
                }) {
                    HStack {
                        Image(systemName: "person.3")
                        Text("Ändern")
                    }
                    .multilineTextAlignment(.leading)
                    .frame(width: 160)
                    .background {
                        ZStack {
                            AnimatedColorWheelOverlay()
                                .mask(
                                    RoundedRectangle(cornerRadius: 30)
                                        .frame(width: 160, height: 50)
                                )
                                .blur(radius: 10)
                            RoundedRectangle(cornerRadius: 30)
                                .fill(.ultraThinMaterial)
                                .frame(width: 160, height: 50)
                                .blur(radius: 2)
                        }
                    }
                }
            }
            .padding()
            .padding(.horizontal, 4)
            
            HStack {
//                Spacer(minLength: 1)
                Image(systemName: "trash")
					.frame(width: 160)
                    .background {
                        RoundedRectangle(cornerRadius: 30).fill(Color.red)
                            .frame(width: 160, height: 50)
                            .blur(radius: 2)
                            .padding(.horizontal)
                            .onTapGesture {
                                isResetConfirmationPresented.toggle()
                            }
                    }
                    .padding(.all)
                    .actionSheet(isPresented: $isResetConfirmationPresented) {
                        createResetActionSheet()
                    }
                
                Spacer()
                Image(systemName: "checkmark.circle")
					.frame(width: 160)
                    .background {
                        RoundedRectangle(cornerRadius: 30).fill(Color.green)
                            .frame(width: 160, height: 50)
                            .blur(radius: 2)
                            .padding(.horizontal)
                            .onTapGesture {
                                // When toggling summary, ensure any pending delete confirmation is cleared
                                isDeleteAllConfirmationPresented = false
                                settings.toggleSummary.toggle()
                            }
                    }
                    .padding(.all)
                
//                Spacer(minLength: 1)
            }
			.padding()
			.padding(.horizontal, 4)
			
			
            if settings.showPatientTypePicker {
                Picker("Patientenart", selection: $settings.isPrivatePatient) {
                    Text("Normal").tag(false)
                    Text("Privatpatient*in").tag(true)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
            }
            
            TabView(selection: $patientSelection.patientSelection) {
                ForEach(1...settings.numberOfPatients, id: \.self) { patientNumber in
                    patientView(for: patientNumber)
                        .tag(patientNumber)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        }
        .ignoresSafeArea(edges: .bottom)
        .onChange(of: settings.numberOfPatients) { newValue in
            if patientSelection.patientSelection > newValue {
                patientSelection.patientSelection = newValue
            }
        }
        .sheet(isPresented: $showingPatientCountPicker) {
            PatientCountPickerView(numberOfPatients: $settings.numberOfPatients)
        }
        .onAppear {
            // drive continuous rotation
            restrictionRingRotation = 0
            withAnimation(.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                restrictionRingRotation = 360
            }
        }
    }
    
    @ViewBuilder
    private func patientView(for patientNumber: Int) -> some View {
        Form {
            createRestrictionsSection(patientNumber: patientNumber)
            createSection(name: "Brot", category: "bread", patientNumber: patientNumber)
            if settings.isPrivatePatient {
                createSection(name: "Vorbestellungen", category: "preordered", patientNumber: patientNumber)
            }
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
            .frame(height: 240)
        }
        //        .navigationBarItems(leading: orderSummaryButton(), trailing: resetButton())
        .onChange(of: patientSelection.patientSelection) { _ in
            triggerHapticFeedback(.medium)
        }
        .background(validateBackgroundColor())
    }
    
    private func createSection(name: String, category: String, patientNumber: Int) -> some View {
        let sortedOptions = settings.getSortedOptions(for: category, isPrivate: settings.isPrivatePatient)
        let counts = getCounts(for: category, patientNumber: patientNumber)
        let filteredOptions = settings.toggleSummary ? filterOptions(options: sortedOptions, counts: counts) : sortedOptions
        
        return Group {
            if !settings.toggleSummary || !filteredOptions.isEmpty || (category == "extras" && !(settings.extras[patientNumber] ?? "").isEmpty) {
                Section(header: Text(name).fontWeight(.semibold)) {
                    ForEach(filteredOptions, id: \.0) { option, _ in
                        createStepper(for: option, counts: counts, category: category, patientNumber: patientNumber)
                    }
                    if category == "extras" {
                        TextEditor(text: Binding<String>(
                            get: { settings.extras[patientNumber] ?? "" },
                            set: { newValue in
                                settings.extras[patientNumber] = newValue
                                settings.saveSelections()
                            }
                        ))
                        .frame(height: 100)
                        .overlay(
                            Group {
                                if settings.extras[patientNumber]?.isEmpty ?? true {
                                    Text("Bitte Extras eingeben")
                                        .foregroundColor(Color(.placeholderText))
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                        .allowsHitTesting(false)
                                }
                            },
                            alignment: .topLeading
                        )
                        .autocorrectionDisabled(true)
                        .toolbar {
                            ToolbarItemGroup(placement: .keyboard) {
                                Spacer()
                                Button("Fertig") {
                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                                    to: nil,
                                                                    from: nil,
                                                                    for: nil)
                                }
                            }
                        }
                    }
                }
            } else {
                EmptyView()
            }
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
        let minValue = 0
        let maxValue = 10
        
        // Compute radius in a non-view expression, then return a single View expression
//        let radius: CGFloat = {
//            if #available(iOS 26.0, *) {
////                print("iOS 26.0")
//                return 24
//            } else {
////                print("iOS not 26.0")
//                return 11
//            }
//        }()
        
        Group {
            Stepper(
                onIncrement: count < maxValue ? {
                    updateCount(for: option, in: category, patientNumber: patientNumber, increment: true)
                } : nil,
                onDecrement: count > minValue ? {
                    updateCount(for: option, in: category, patientNumber: patientNumber, increment: false)
                } : nil
            ) {
                Text("\(option) (\(count))")
                    .fontWeight(count >= 1 ? .semibold : .regular)
            }
            .padding(.vertical, 2)
            .background(
                Group {
                    if #available(iOS 26.0, *) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(count >= 1 ? Color.accentColor.opacity(0.3) : Color.clear)
                            // iOS 26+
                            .padding(-10)
                            .padding(.trailing, 1)
                    } else {
                        RoundedRectangle(cornerRadius: 11)
                            .fill(count >= 1 ? Color.accentColor.opacity(0.3) : Color.clear)
                            // iOS 18 and below
                            .padding(.leading, -14)
                            .padding(.trailing, -3)
                    }
                }
            )
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
        
        triggerHapticFeedback(.light)
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
            if !settings.toggleSummary || restriction != "Keine" {
                Section(header: Text("Einschränkungen").bold()) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(["Keine", "Schnabelbecher", "Schmieren", "SB & Schmieren"], id: \.self) { option in
                                Button(action: {
                                    settings.restrictions[patientNumber] = option
                                    triggerHapticFeedback(.light)
                                }) {
                                    if settings.toggleSummary {
                                        VStack(spacing: 8) {
                                            Image(systemName: iconForRestriction(option))
                                                .font(.system(size: 20))
                                                .bold()
                                            Text(option == "Schnabelbecher" ? "Schnabel-becher" : option)
                                                .multilineTextAlignment(.center)
                                                .bold()
                                                .font(.caption)
                                        }
                                        .frame(width: 70, height: 80)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(restriction == option ? .red.opacity(0.25) : Color.secondary.opacity(0.2))
                                        )
                                        .foregroundColor(restriction == option ? .primary : .primary.opacity(0.2))
                                        .overlay(
                                            // Base red border (as before) only for selected & not "Keine"
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(
                                                    (restriction == option && option != "Keine") ? Color.red : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                    } else {
                                        VStack(spacing: 8) {
                                            Image(systemName: iconForRestriction(option))
                                                .font(.system(size: 20))
                                                .bold()
                                            Text(option == "Schnabelbecher" ? "Schnabel-becher" : option)
                                                .multilineTextAlignment(.center)
                                                .bold()
                                                .font(.caption)
                                        }
                                        .frame(width: 70, height: 80)
                                        .background(
                                            RoundedRectangle(cornerRadius: 15)
                                                .fill(Color.secondary.opacity(0.2))
                                        )
										.foregroundColor(.primary)
                                        .overlay(
                                            // Keep the non-summary border behavior minimal (no spinning)
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(
                                                    (restriction == option) ? Color.accentColor : Color.clear,
                                                    lineWidth: 3
                                                )
                                        )
                                    }
                                }
                                .padding(3)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func iconForRestriction(_ restriction: String) -> String {
        switch restriction {
        case "Keine":
            return "xmark.circle"
        case "Schnabelbecher":
            return "cup.and.heat.waves"
        case "Schmieren":
            return "hand.raised.fill"
        case "SB & Schmieren":
            return "takeoutbag.and.cup.and.straw"
        default:
            return "questionmark.circle"
        }
    }
    
    @ViewBuilder
    func createDrinkAndFruitSection(patientNumber: Int) -> some View {
        let teaOptions = settings.getSortedOptions(for: "tea", isPrivate: settings.isPrivatePatient)
        let coffeeOptions = settings.getSortedOptions(for: "coffee", isPrivate: settings.isPrivatePatient)
        let fruitOptions = settings.getSortedOptions(for: "fruit", isPrivate: settings.isPrivatePatient)
        
        let teaQuantities = settings.teaQuantities[patientNumber] ?? [:]
        let coffeeQuantities = settings.coffeeQuantities[patientNumber] ?? [:]
        let fruitQuantities = settings.fruitQuantities[patientNumber] ?? [:]
        
        if settings.toggleSummary && !teaQuantities.contains(where: { $0.value > 0 }) && !coffeeQuantities.contains(where: { $0.value > 0 }) && !fruitQuantities.contains(where: { $0.value > 0 }) {
            // nothing in summary
        } else {
            Section(header: Text("Getränke und Obst")) {
                createQuantitySelectionPicker(
                    for: "tea",
                    options: teaOptions,
                    quantities: Binding<[String: Int]>(
                        get: { teaQuantities },
                        set: { settings.teaQuantities[patientNumber] = $0 }
                    ),
                    title: "Tee auswählen",
                    isFiltered: settings.toggleSummary
                )
                
                if settings.coffeeSelected {
                    createQuantitySelectionPicker(
                        for: "coffee",
                        options: coffeeOptions,
                        quantities: Binding<[String: Int]>(
                            get: { coffeeQuantities },
                            set: { settings.coffeeQuantities[patientNumber] = $0 }
                        ),
                        title: "Kaffee auswählen",
                        isFiltered: settings.toggleSummary
                    )
                }
                
                createQuantitySelectionPicker(
                    for: "fruit",
                    options: fruitOptions,
                    quantities: Binding<[String: Int]>(
                        get: { fruitQuantities },
                        set: { settings.fruitQuantities[patientNumber] = $0 }
                    ),
                    title: "Obst auswählen",
                    isFiltered: settings.toggleSummary
                )
            }
        }
    }
    
    
    @ViewBuilder
    func createQuantitySelectionPicker(for category: String, options: [(String, Int)], quantities: Binding<[String: Int]>, title: String, isFiltered: Bool) -> some View {
        let filteredOptions = isFiltered ? options.filter { quantities.wrappedValue[$0.0, default: 0] > 0 } : options
        
        if !isFiltered || !filteredOptions.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(filteredOptions, id: \.0) { option, _ in
                            VStack {
                                Text(option)
                                    .bold(quantities.wrappedValue[option, default: 0] > 0 ? true : false)
                                let count = quantities.wrappedValue[option, default: 0]
                                let minValue = 0
                                let maxValue = 10
                                
                                Stepper(
                                    onIncrement: count < maxValue ? {
                                        updateDrinkAndFruitCount(for: option, in: category, patientNumber: patientSelection.patientSelection, increment: true)
                                    } : nil,
                                    onDecrement: count > minValue ? {
                                        updateDrinkAndFruitCount(for: option, in: category, patientNumber: patientSelection.patientSelection, increment: false)
                                    } : nil
                                ) {
                                    Text("\(quantities.wrappedValue[option, default: 0])")
                                        .bold(quantities.wrappedValue[option, default: 0] > 0 ? true : false)
                                }
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(quantities.wrappedValue[option, default: 0] > 0 ? Color.accentColor.opacity(0.3) : Color.secondary.opacity(0.2))
                            .foregroundColor(.white)
                            .cornerRadius(20)
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
        triggerHapticFeedback(.light)
    }
    
    private func updateCount(in counts: inout [String: Int], for option: String, increment: Bool) {
        let currentCount = counts[option, default: 0]
        if increment {
            counts[option] = min(currentCount + 1, 10)
        } else {
            counts[option] = max(currentCount - 1, 0)
        }
    }
    
//    @ViewBuilder
//    func createQuantitySummary(for quantities: [String: Int]) -> some View {
//        let selectedItems = quantities.filter { $0.value > 0 }
//        if !selectedItems.isEmpty {
//            VStack(alignment: .leading) {
//                Text("Zusammenfassung:")
//                    .font(.subheadline)
//                    .fontWeight(.semibold)
//                ForEach(selectedItems.sorted(by: { $0.key < $1.key }), id: \.key) { item, quantity in
//                    Text("\(item): \(quantity)")
//                        .font(.footnote)
//                }
//            }
//            .padding(.top, 5)
//            .padding(.bottom, 10)
//        }
//    }
    
    @ViewBuilder
    func createExtrasSection(patientNumber: Int) -> some View {
        let sortedOptions = settings.getSortedOptions(for: "extras", isPrivate: settings.isPrivatePatient)
        let counts = settings.extrasCounts[patientNumber] ?? [:]
        let extraText = settings.extras[patientNumber] ?? ""
        let filteredOptions = settings.toggleSummary ? filterOptions(options: sortedOptions, counts: counts) : sortedOptions
        
        if !settings.toggleSummary || !filteredOptions.isEmpty || !extraText.isEmpty {
            Section(header: Text("Extras").fontWeight(.semibold)) {
                ForEach(filteredOptions, id: \.0) { option, _ in
                    createStepper(for: option, counts: counts, category: "extras", patientNumber: patientNumber)
                }
                
                TextField("Bitte Extras eingeben", text: Binding<String>(
                    get: { extraText },
                    set: { newValue in
                        settings.extras[patientNumber] = newValue
                        settings.saveSelections()
                    }
                ))
                .submitLabel(.done)
                .frame(height: 100, alignment: .top)
            }
        }
    }
    
    @ViewBuilder
    func toggleOrderSummaryButton() -> some View {
        if settings.toggleSummary {
            HStack(spacing: 12) {
                Button(action: {
                    // Hide summary and clear any pending alert
                    isDeleteAllConfirmationPresented = false
                    settings.toggleSummary = false
                    triggerHapticFeedback(.light)
                }, label: {
                    Text("Übersicht aus")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 25)
                        .background(Color.orange)
                        .contentShape(Rectangle())
                        .cornerRadius(12)
                })
            }
        } else {
            Button(action: {
                // Show summary and clear any pending alert state first
                isDeleteAllConfirmationPresented = false
                settings.toggleSummary.toggle()
                triggerHapticFeedback(.light)
            }, label: {
                Text("Bestellübersicht einblenden")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 25)
                    .background(Color.green)
                    .contentShape(Rectangle())
                    .cornerRadius(12)
            })
        }
        
    }
    
    func orderSummaryButton() -> some View {
        Button(action: {
            settings.toggleSummary.toggle()
            triggerHapticFeedback(.light)
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
                    triggerHapticFeedback(.rigid)
                }
        }
        buttons.append(.default(Text("Alle Bestellungen")) {
            settings.resetAllSelections()
            patientSelection.patientSelection = 1
            settings.toggleSummary = false
            triggerHapticFeedback(.heavy)
        })
        buttons.append(.cancel(Text("Abbrechen")))
        
        return ActionSheet(title: Text("Welche Bestellung möchtest Du zurücksetzen?"), buttons: buttons)
    }
    
    private func filterOptions(options: [(String, Int)], counts: [String: Int]) -> [(String, Int)] {
        return options.filter { counts[$0.0] ?? 0 > 0 }
    }
    
    func triggerHapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    func validateBackgroundColor() -> Color {
        return settings.validateSelections() ? Color.purple.opacity(0.2) : Color.white
    }
}

struct MultiSelectionPicker: View {
    let title: String
    let options: [String: Int]
    @Binding var selection: [String]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(Array(options.keys), id: \.self) { option in
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
        NavigationStack {
            Form {
                Picker("Anzahl der Patienten", selection: $numberOfPatients) {
                    ForEach(1...100, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .onChange(of: numberOfPatients) { _ in
                    ToastManager.shared.showInfo("Anzahl der Patienten wurde auf \(numberOfPatients) geändert")
                }
            }
            .navigationTitle("Patienten Anzahl")
            .navigationBarItems(trailing: Button("Fertig") {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .withToasts()
    }
}

struct OrderFormView2_Previews: PreviewProvider {
    static var previews: some View {
        OrderFormView(settings: Settings(), patientSelection: patientSelectionManager())
			.preferredColorScheme(.dark)
    }
}
