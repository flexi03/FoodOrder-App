//
//  SettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 21.11.23.
//

import SwiftUI

struct SettingsView: View {
//    @State var colorScheme
    @ObservedObject var colorScheme: ColorSchemeModel
    @ObservedObject var settings: Settings
    @AppStorage("showWorkingTime") var showWorkingTime: Bool = true
    
    var body: some View {
            Form {
                Section("App Farbe") {
                    Picker("Color", selection: $colorScheme.mode) {
                        Text("Dunkel").tag("Dunkel")
                        Text("Hell").tag("Hell")
                    }
                    .pickerStyle(.segmented)
                    .frame(height: 50)
                }
                Section(header: Text("Optionen")) {
                    Toggle(isOn: $settings.coffeeSelected) {
                        Text("Kaffee auswählbar")
                    }
                    Toggle(isOn: $settings.showRestrictions) {
                        Text("Einschränkungen anzeigen")
                    }
                    NavigationLink("Auswahl Optionen", destination: OptionView(settings: Settings()))
                }
                
                Section(header: Text("Entwickler")) {
                    Toggle(isOn: $showWorkingTime, label: {
                        Text("Arbeitszeiterfassung")
                    })
                    NavigationLink("Entwickler", destination: DeveloperSettingsView())
                }
                            
        }
        .navigationTitle("Einstellungen")
        .navigationBarItems(trailing: NavigationLink(destination: FeedbackView()) {
            Image(systemName: "bubble.left.and.exclamationmark.bubble.right")
                .fontWeight(.bold)
        })
    }
}

#Preview {
    SettingsView(colorScheme: ColorSchemeModel(), settings: Settings())
}
