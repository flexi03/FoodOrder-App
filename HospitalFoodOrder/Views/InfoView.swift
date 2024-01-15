//
//  InfoView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 21.11.23.
//

import SwiftUI

struct InfoView: View {
    
    @State private var email = "fk.testflight@icloud.com"
    @State private var emailText = "Mail zur Kopie"
    @State private var showPopup = false
    
    var body: some View {
        VStack {
            Form {
                Section("Bestellungen aufnehmen und löschen") {
                    Text("Oben kannst Du die Bestellung auswählen, welche Du gerade aufnehmen möchtest. Wenn Du eine andere Bestellung aufnehmen möchtest kannst Du auf eine beliebige Zahl klicken und dann diese aufnehmen.\n\n\(Text("Tipp:").bold().underline()) Alle Bestellungen haben eine andere Farbe, welche Du bei den Kategoriebezeichnungen siehst. (Wenn Du z.B. Grau Brot auswählst, dann wird dies auch in der entsprechenden Farbe gekennzeichnet.)")
                    Text("Wenn Du eine oder alle Bestellung/en zurücksetzen möchtest kannst Du einfach auf den Mülleimer oben rechts klicken und dort dann auswählen, was zurückgesetzt werden soll.")
                }
                Section("Einstellungen") {
                    Text("In den Einstellungen kannst du anpassen, welche Optionen es bei den entsprechenden Kategorien gibt. \n\n\(Text("Tipp:").bold().underline()) Du kannst dort auch die Reihenfolge der Optionen ändern und diese auch durch einen Linksswipe löschen. (Die Swipe-Funktion funktioniert auch in der Bestellung) \n\nWenn Du die \(Text("Auswahloptionen komplett zurücksetzen").fontWeight(.bold)) möchtest, kannst du dort den Button oben links benutzen.")
                }
                
                Section("Hilfe") {
                    Text("Benötigst Du weiterhin Hilfe oder hast Fragen, wende Dich doch gerne per Mail an mich und ich melde mich schnellstmöglichst bei Dir. ^^ \nPS: FeedBack auch gerne per TestFlight oder Mail.")
                    
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
    //                            .padding(8)
                                .transition(.opacity.animation(.easeInOut(duration: 1)))                            
                                .zIndex(1)
                            }
                        }
                    )
                    
                }
                Section("") {
//                    Text("")
                }
                    .frame(height: 100)
                
            
            }
//            Image(systemName: "figure.walk.diamond")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .offset(y: -230)
//                .frame(width: 200, height: 200) // Passe die Größe nach Bedarf an
//                .foregroundStyle(.accent)
        }
        .navigationTitle("Infos & Tipps")
    }
}

#Preview {
    InfoView()
}
