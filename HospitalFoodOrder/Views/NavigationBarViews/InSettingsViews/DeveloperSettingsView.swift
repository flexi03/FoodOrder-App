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
            
            
            NavigationLink(destination: ToastTesterView()) {
                Text("Toast Tester")
            }
            LayoutSettingsSection(settings: settings)
        }
        .navigationTitle("Entwickler")
    }
}

#Preview {
    NavigationStack {
        DeveloperSettingsView()
    }
}

#Preview {
    NavigationStack {
        SettingsView(colorScheme: ColorSchemeModel(), settings: Settings())
    }
//    .navigationViewStyle(.stack)
}
