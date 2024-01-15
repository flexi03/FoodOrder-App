//
//  PatientSelectionView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 11.11.23.
//

import SwiftUI

class SelectionManager: ObservableObject {
    @Published var activeCard: Int?

    init() {
        setActiveCard()
    }

    func setActiveCard() {
        // Setze die activeCard auf den Wert der ersten Karte, wenn keine Karte ausgewählt ist
        if activeCard == nil, let firstCard = cards.first {
            activeCard = firstCard.balance
        }
    }
}

//let cards = CardManager.shared.cards

//struct PatientSelectionView: View {
//    
//    @ObservedObject var selectionManager: SelectionManager
//
//    var body: some View {
//        ScrollView(.horizontal) {
//            LazyHStack(spacing: 0) {
//                ForEach(cards) { card in
//                    CardView(card)
//                        .id(card.id)
//                        .containerRelativeFrame(.horizontal)
//                        .onAppear {
//                            selectionManager.activeCard = card.balance
//                        }
//                        .onTapGesture {
//                            selectionManager.activeCard = card.balance
//                        }
//                }
//            }
//            .frame(maxHeight: 150)
//            .scrollTargetLayout()
////            .onChange(of: selectionManager.activeCard) { newValue in
////                // Hier kannst du bei Bedarf weitere Anpassungen vornehmen
////                print("Selected card changed to \(newValue!)")
////                
////            }
//            
//        }
//        .onAppear {
//            selectionManager.setActiveCard()
//        }
//        .scrollPosition(id: $selectionManager.activeCard)
//        .scrollTargetBehavior(.paging)
//        .scrollIndicators(ScrollIndicatorVisibility.hidden)
//        
//    }
//
//    @ViewBuilder
//    func CardView(_ card: Card) -> some View {
//            ZStack {
//                Rectangle()
//                    .fill(card.bgColor)
//                    .frame(maxHeight: 100)
//                    .overlay(alignment: .leading) {
//                        Circle()
//                            .fill(card.bgColor)
//                            .overlay {
//                                Circle()
//                                    .fill(.white.opacity(0.2))
//                            }
//                            .scaleEffect(2.5, anchor: .topLeading)
//                            .offset(x: -20, y: -50)
//                    }
//                    .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
//                VStack(alignment: .leading, spacing: 4) {
//                    Text("Patient \(card.balance)")
//                        .font(.title.bold())
//                }
//                .foregroundStyle(.black)
//            }
//
//            .padding(25)
//            
//            
//        }
//    }


#Preview {
    ContentView(colorScheme: ColorSchemeModel())
}
