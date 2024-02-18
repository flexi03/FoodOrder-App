//
//  ColorSettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 04.12.23.
//

import SwiftUI

struct ColorSettingsView: View {
    @State var color1: Color = .primary
    @State var color2: Color = .primary
    @State var color3: Color = .primary
    @State var color4: Color = .primary
    
    var body: some View {
        Form {
            Section {
                Text("Funktion folgt noch...")
                
            }
            
            Section {
                ColorPicker("Farbe Patient 1", selection: $color1)
                ColorPicker("Farbe Patient 2", selection: $color2)
                ColorPicker("Farbe Patient 3", selection: $color3)
                ColorPicker("Farbe Patient 4", selection: $color4)
            }
            
        }
        .navigationTitle("Farbauswahl")
    }
}
