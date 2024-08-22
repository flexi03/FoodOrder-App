//
//  ColorSettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 04.12.23.
//

import SwiftUI

struct ContentView2: View {
    @State private var accentColor: Color = Color("AccentColor")
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World!")
                    .padding()
                    .accentColor(accentColor)
                
                NavigationLink("Change Accent Color") {
                    ColorPickerView(selectedColor: $accentColor)
                }
                .padding()
                .accentColor(accentColor)
            }
            .onAppear {
                if let savedColor = UserDefaults.standard.color(forKey: "AccentColor") {
                    accentColor = savedColor
                }
            }
            .onChange(of: accentColor) { newColor in
                UserDefaults.standard.setColor(newColor, forKey: "AccentColor")
            }
            .navigationTitle("Accent Color Picker")
        }
        .background(Color("AccentColor"))
    }
}

extension UserDefaults {
    func color(forKey key: String) -> Color? {
        guard let data = data(forKey: key),
              let uiColor = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return nil
        }
        return Color(uiColor)
    }

    func setColor(_ color: Color, forKey key: String) {
        let uiColor = UIColor(color)
        guard let data = try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false) else {
            return
        }
        set(data, forKey: key)
    }
}

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    
    var body: some View {
        VStack {
            Text("Pick a color for Accent")
                .font(.headline)
            
            ColorPicker("Accent Color", selection: $selectedColor)
                .padding()
            
            Spacer()
        }
        .padding()
        .navigationTitle("Select Accent Color")
    }
}
#Preview {
    ContentView2()
}
