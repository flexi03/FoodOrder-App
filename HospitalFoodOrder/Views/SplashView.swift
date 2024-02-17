//
//  SplashView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 14.12.23.
//

import SwiftUI

struct SplashView: View {
    @Binding var isFirstLaunch: Bool

    var body: some View {
        VStack {
//            Section {
//                LottieAnimationView2()
//                    .frame(height: 200)
//            }
            Text("Willkommen bei Food Order")
                .font(.title2)
                .fontWeight(.heavy)
            Text("")
            Text("Was kann die App?")
                .font(.title3)
                .fontWeight(.semibold)
            HStack {
                VStack {
                    Image(systemName: "cart.badge.plus")
                        .resizable()
                        .frame(maxWidth: 120, maxHeight: 100)
                        .foregroundColor(.green)
                        .padding()
                    Image(systemName: "clock.arrow.circlepath")
                        .resizable()
                        .frame(maxWidth: 90, maxHeight: 80)
                        .foregroundColor(.purple)
                    Image(systemName: "figure.run")
                        .resizable()
                        .frame(maxWidth: 80, maxHeight: 100)
                        .foregroundColor(.accentColor)
                        .padding()
                }
                
                
                VStack {
                    Text("Bestellungen aufnehmen")
                        .frame(maxHeight: 140)
                    
                    Text("Arbeitszeiten erfassen und einfach exportieren")
                        .frame(maxHeight: 100)
                    
                    Text("Entspannter arbeiten und weniger Stress")
                        .frame(maxHeight: 120)
                }
                .fontWeight(.semibold)
            }
            .padding()
            
            Button(action: {
                isFirstLaunch = false
            }, label: {
                Text("Los geht's")
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
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isFirstLaunch: .constant(true))
    }
}
