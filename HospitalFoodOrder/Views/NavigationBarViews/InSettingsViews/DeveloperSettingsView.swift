//
//  DeveloperSettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 15.12.23.
//

import SwiftUI

struct DeveloperSettingsView: View {
    
    @StateObject var settings = Settings()
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = false
    
    var body: some View {
        Form {
            NavigationLink(destination: WorkingTimeView()) {
                Text("Arbeitszeiterfassung")
                
            }
            
            Button(action: {
                isFirstLaunch = true
            }, label: {
                Text("SplashScreen")
            })
            
            Toggle("iPhone Layout", isOn: $settings.forceiPhoneLayout)
            Toggle("iPad Layout", isOn: $settings.forceiPadLayout)
        }
        .navigationTitle("Entwickler")
    }
}

#Preview {
    NavigationView {
        DeveloperSettingsView()
    }
    .navigationViewStyle(.stack)
}

#Preview {
    NavigationView {
        SettingsView(colorScheme: ColorSchemeModel(), settings: Settings())
    }
    .navigationViewStyle(.stack)
}
