//
//  SettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 21.11.23.
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    @ObservedObject var colorScheme: ColorSchemeModel
    @ObservedObject var settings: Settings
    
    var body: some View {
        Form {
            Section(header: Text("Aussehen")) {
                Picker("Farbschema", selection: $colorScheme.mode) {
                    Text("Dunkel").tag("Dunkel")
                    Text("Hell").tag("Hell")
                }
                .pickerStyle(.segmented)
            }
            
            Section(header: Text("Bestelloptionen")) {
                Toggle(isOn: $settings.coffeeSelected) {
                    Text("Kaffee auswählbar")
                }
                Toggle(isOn: $settings.showRestrictions) {
                    Text("Einschränkungen anzeigen")
                }
//                HStack {
//                    Text("Standardanzahl Patienten")
//                    Spacer()
//                    Picker("", selection: $settings.numberOfPatients) {
//                        ForEach(1...100, id: \.self) { number in
//                            Text("\(number)").tag(number)
//                        }
//                    }
//                    .pickerStyle(.wheel)
//                    .frame(width: 100, height: 100)
//                    .clipped()
//                }
                NavigationLink("Auswahl Optionen anpassen", destination: OptionView(settings: settings))
            }
            
            Section(header: Text("Über")) {
                NavigationLink("Feedback geben", destination: FeedbackView())
                Link("Datenschutzerklärung", destination: URL(string: "https://example.com/privacy")!)
                Link("Nutzungsbedingungen", destination: URL(string: "https://example.com/terms")!)
                // Version number and Build
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
                let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
                Text("Version \(version) (Build \(buildNumber))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
                    .padding()
            }
            Section("") {
                
            }
            .frame(height: 50)
        }
        .navigationTitle("Einstellungen")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SettingsView(colorScheme: ColorSchemeModel(), settings: Settings())
        }
    }
}
