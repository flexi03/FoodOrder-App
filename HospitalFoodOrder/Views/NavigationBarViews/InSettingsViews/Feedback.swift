//
//  OrdersTest.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 09.11.23.
//

import SwiftUI

struct FeedbackView: View {
    @State private var email = "fk.testflight@icloud.com"
    @State private var emailText = "Mail zur Kopie"
    @State private var showPopup = false
    
    var body: some View {
        Form {
            Section {
                Text("FeedBack immer gerne per \(Text("TestFlight").bold().underline()) hinterlassen. \nUnd Screenshots nicht vergessen.")
            }
            
            Section {
                Text("Sonst gibt es hier noch meine E-Mail für FeedBack.")
                Link(destination: URL(string: "mailto:fk.testflight@icloud.com")!) {
                    Text("Direktlink zu Mail")
                }
                Button(action: {
                    UIPasteboard.general.string = self.email
                    showPopup = true
                    // Erzeuge eine leichte Vibration
                    let generator = UIImpactFeedbackGenerator(style: .light)
                    generator.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        showPopup = false
                    }
                }) {
                    TextField("E-Mail-Adresse", text: $emailText)
                        .disabled(true)
                        .offset(x: -15)
                        .padding()
                        .overlay(
                            Image(systemName: "square.on.square")
                                .foregroundColor(.blue)
                                .padding(.horizontal, 8),
                            alignment: .trailing
                        )
                }
                .overlay(
                    Group {
                        if showPopup {
                            ZStack {
                                Color.white
                                    .opacity(0.9)
                                    .cornerRadius(10)
                                Text("E-Mail kopiert")
                                    .foregroundColor(.black)
                            }
                            .transition(.opacity.animation(.easeInOut(duration: 1)))                            .zIndex(1)
                        }
                    }
                )
            }
            
        }
        .navigationTitle("Feedback")
    }
}


#Preview {
    FeedbackView()
}

