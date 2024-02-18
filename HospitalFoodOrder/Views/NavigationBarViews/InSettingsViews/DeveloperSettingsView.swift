//
//  DeveloperSettingsView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 15.12.23.
//

import SwiftUI

struct DeveloperSettingsView: View {
    
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = false
    
    var body: some View {
        ScrollView {
            Button(action: {
                isFirstLaunch = true
            }, label: {
                Text("SplashScreen")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .contentShape(Rectangle())
                    .cornerRadius(12)
            })
            .padding()
        }
        .navigationTitle("Entwickler")
    }
}

#Preview {
    DeveloperSettingsView()
}
