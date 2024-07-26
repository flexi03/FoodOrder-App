////
////  OverViewView.swift
////  HospitalFoodOrder
////
////  Created by Felix Kircher on 13.11.23.
////
//
//import SwiftUI
//
//extension Settings {
//    func selectedBreadOptions() -> [String] {
//        let selectedBreads = selectedBreadCounts.keys.filter { selectedBreadCounts[$0] ?? 0 > 0 }
//        return selectedBreads.sorted()
//    }
//}
//
//struct OverViewView: View {
//    
//    @ObservedObject var patientSelection = patientSelectionManager()
//    @StateObject var settings = Settings()
//    
//    var body: some View {
//        VStack {
////            PatientSelectionView(selectionManager: SelectionManager())
////                .frame(height: 120)
//            List {
//                Section {
//                    Picker("Patientenauswahl", selection: $patientSelection.patientSelection) {
//                        Text("1").tag("P1")
//                        Text("2").tag("P2")
//                        Text("3").tag("P3")
//                        Text("4").tag("P4")
//                    }
//                    .frame(height: 50)
//                    .pickerStyle(SegmentedPickerStyle())
//                    .scaledToFill()
//                    .onChange(of: patientSelection.patientSelection) { _ in
//                        // Vibration hinzufügen
//                        let generator = UINotificationFeedbackGenerator()
//                        generator.notificationOccurred(.success) }
//                    
//                    Text(settings.selectedBreadCounts.description)
//                }
//                
//                Section(header: Text("Aufstrich")) {
//                    Text("")
//                }
//                
//                Section(header: Text("Aufstrich 2")) {
//                    Text("")
//                }
//                
//                Section(header: Text("Specials")) {
//                    Text("")
//                }
//                
//                Section(header: Text("Getränke und Obst")) {
//                    Text(settings.selectedTeaFlavor.description)
//                }
//                
//                Section(header: Text("Extras")) {
//                    Text("")
//                }
//                
//                            
//                         
//            }
//        }
//        .navigationTitle("Übersicht")
//        .navigationBarItems(trailing: NavigationLink(destination: InfoView()) {
//            Image(systemName: "lightbulb.max")
//                .fontWeight(.bold)
//        })
//    }
//}
//
//#Preview {
//    OverViewView()
//}
