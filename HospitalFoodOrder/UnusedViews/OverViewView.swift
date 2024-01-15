//
//  OverViewView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 13.11.23.
//

import SwiftUI

extension Settings {
    func selectedBreadOptions() -> [String] {
        let selectedBreads = selectedBreadCounts.keys.filter { selectedBreadCounts[$0] ?? 0 > 0 }
        return selectedBreads.sorted()
    }

    // Füge ähnliche Funktionen für andere Optionen hinzu (z.B., selectedSpreadOptions, selectedSpecialsOptions, etc.)
}

// In der anderen Datei, in der du auf die Settings-Klasse zugreifen möchtest


struct OverViewView: View {
    
    @ObservedObject var patientSelection = patientSelectionManager()
    @StateObject var settings = Settings()
    
    var body: some View {
        VStack {
//            PatientSelectionView(selectionManager: SelectionManager())
//                .frame(height: 120)
            List {
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
                        // Vibration hinzufügen
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success) }
                    
//                    .scaleEffect(CGSize(width: 2.5, height: 2.5))
//                    .offset(x: 92)
//                }
//                Section {
//                    Text("Selected Bread Counts:")
//                    Text("Bread 1: \(settings.selectedBreadCounts)")
//                    Text("Bread 2: \(settings.selectedBreadCounts2)")
//                    Text("Bread 3: \(settings.selectedBreadCounts3)")
//                    Text("Bread 4: \(settings.selectedBreadCounts4)")
//                }
                

                
//                Text("Hier gibts bald eine Übersicht der gesamten Bestellung")
                
//                Section(header: Text("Brot").fontWeight(.semibold)) {
////                    Text(selectedBreads)
//                    
//                    ForEach(settings.breadOptions, id: \.self) { bread in
//                        Stepper("\(bread) (\(max(0, settings.selectedBreadCounts[bread] ?? 0)))", value: Binding(
//                            get: { max(0, settings.selectedBreadCounts[bread] ?? 0) },
//                            set: { newValue in
//                                settings.selectedBreadCounts[bread] = max(0, newValue)
//                                // Vibration hinzufügen
//                                let generator = UINotificationFeedbackGenerator()
//                                generator.notificationOccurred(.success)
//                            }
//                        ))
//                    }
                    Text(settings.selectedBreadCounts.description)
                }
//                .onAppear(perform: {
//                    print(settings.$selectedTeaFlavor.print())})
                
                Section(header: Text("Aufstrich")) {
                    Text("")
                }
                
                Section(header: Text("Aufstrich 2")) {
                    Text("")
                }
                
                Section(header: Text("Specials")) {
                    Text("")
                }
                
                Section(header: Text("Getränke und Obst")) {
                    Text(settings.selectedTeaFlavor.description)
                }
                
                Section(header: Text("Extras")) {
                    Text("")
                }
                
                            
                         
            }
//            Image(systemName: "figure.walk.diamond")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .offset(y: -230)
//                .frame(width: 200, height: 200) // Passe die Größe nach Bedarf an
//                .foregroundStyle(.accent)
        }
        .navigationTitle("Übersicht")
        .navigationBarItems(trailing: NavigationLink(destination: InfoView()) {
            Image(systemName: "lightbulb.max")
                .fontWeight(.bold)
        })
    }
}

#Preview {
    OverViewView()
}
