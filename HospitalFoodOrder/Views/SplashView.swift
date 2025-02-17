//
//  SplashView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 14.12.23.
//

import SwiftUI

struct SplashView: View {
    @Binding var isFirstLaunch: Bool
    @State private var selectedSplashItem: SplashItem = SplashItems.first!
    @State private var introItems: [SplashItem] = SplashItems
    @State private var activeIndex: Int = 0

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isFirstLaunch = false
            }) {
                Image(systemName: "multiply")
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
                    .background {
                        Circle()
                            .frame(width: 32, height: 32)
                            .opacity(0.2)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding(.trailing ,25)
            .padding(.top, 25)
            
            ZStack {
                /// Animated Icons
                ForEach(introItems) { item in
                    AnimatedIconsView(item)
                }
            }
            .frame(height: 250)
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 6) {
                /// Progress Indicator View
                HStack(spacing: 4) {
                    ForEach(introItems) { item in
                        Capsule()
                            .fill(selectedSplashItem.id == item.id ? Color.accentColor : .gray)
                            .frame(width: selectedSplashItem.id == item.id ? 25 : 4, height: 4)
                    }
                }
                .padding(.bottom, 15)
                
                Text(selectedSplashItem.title)
                    .font(.title.bold())
                    .contentTransition(.numericText())
                
                Text(selectedSplashItem.caption)
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                /// Next/Continue Button
                HStack {
//                        /// Only visible from second item

                    if selectedSplashItem.id != introItems.first?.id {
                        /// Back Button
                        Button {
                            updateItem(isForward: false)
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.semibold)
                                .foregroundStyle(.white)
                                .frame(width: 50)
                                .padding(.vertical, 12)
                                .background(Color.accentColor.gradient, in: .capsule)
                        }
                        .padding(.top, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Button {
                        updateItem(isForward: true)
                        if selectedSplashItem.id == introItems.last?.id {
                            isFirstLaunch = false
                        }
                    } label: {
                        Text(selectedSplashItem.id == introItems.last?.id ? "Fertig" : "Weiter ")
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(width: 250)
                            .padding(.vertical, 12)
                            .background(Color.accentColor.gradient, in: .capsule)
                    }
                    .padding(.top, 25)
                }

            }
            .multilineTextAlignment(.center)
            .frame(width: 300)
            .frame(maxHeight: .infinity)
        }
//        VStack {
////            Section {
////                LottieAnimationView2()
////                    .frame(height: 200)
////            }
//            Text("Willkommen bei Food Order")
//                .font(.title)
//                .fontWeight(.heavy)
//            Text("")
//            Text("Was kann die App?")
//                .font(.title2)
//                .fontWeight(.bold)
//            HStack {
//                VStack {
//                    Image(systemName: "cart.badge.plus")
//                        .resizable()
//                        .frame(maxWidth: 120, maxHeight: 100)
//                        .foregroundColor(.green)
//                        .padding()
//                        .fontWeight(.semibold)
//                    Image(systemName: "clock.arrow.circlepath")
//                        .resizable()
//                        .frame(maxWidth: 90, maxHeight: 80)
//                        .foregroundColor(.purple)
//                        .fontWeight(.semibold)
//                    Image(systemName: "figure.run")
//                        .resizable()
//                        .frame(maxWidth: 80, maxHeight: 100)
//                        .foregroundColor(.accentColor)
//                        .padding()
//                        .fontWeight(.semibold)
//                }
//                
//                
//                VStack {
//                    Text("Bestellungen aufnehmen")
//                        .frame(maxHeight: 140)
//                    
//                    Text("Arbeitszeiten erfassen und einfach exportieren")
//                        .frame(maxHeight: 100)
//                    
//                    Text("Entspannter arbeiten und weniger Stress")
//                        .frame(maxHeight: 120)
//                }
//                .fontWeight(.semibold)
//            }
//            .padding()
//            
//            Button(action: {
//                isFirstLaunch = false
//            }, label: {
//                Text("Los geht's")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .bottom)
//                    .padding(.vertical, 14)
//                    .background(Color.accentColor)
//                    .contentShape(Rectangle())
//                    .cornerRadius(12)
//            })
//            .padding()
//        }
    }
    
    @ViewBuilder
    func AnimatedIconsView(_ item: SplashItem) -> some View {
        let isSelected = selectedSplashItem.id == item.id
        // when item.image is first index another value
//        let image = item.image == "AppIcon" ? "AppIcon" : item.image

        Image(systemName: item.image)
                    .font(.system(size: 64))
                    .foregroundStyle(.white.shadow(.drop(radius: 10)))
                    .blendMode(.overlay)
                    .frame(width: 120, height: 120)
                    .background(Color.accentColor.gradient, in: .rect(cornerRadius: 32))
                    .background {
                        RoundedRectangle(cornerRadius: 35)
                            .fill(.secondary)
                            .shadow(color: Color.accentColor.opacity(1), radius: 2, x: 2, y: 2)
                            .shadow(color: Color.accentColor.opacity(1), radius: 2, x: -2, y: -2)
                            .padding(-3)
                            .opacity(selectedSplashItem.id == item.id ? 1 : 0)
                    }
                    // Resetting rotation
                    .rotationEffect(.init(degrees: -item.rotation))
                    .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
                    .offset(x: item.offset)
                    .rotationEffect(.init(degrees: item.rotation))
                    // Placing active item at top
                    .zIndex(isSelected ? 2 : item.zindex)
//        if item.image == "AppIcon" {
//            Image("appstore1024")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 120, height: 120)
//                .clipShape(.rect(cornerRadius: 35))
//                .shadow(color: Color.accentColor.opacity(selectedSplashItem.id == item.id ? 1 : 0), radius: 2, x: 2, y: 2)
//                .shadow(color: Color.accentColor.opacity(selectedSplashItem.id == item.id ? 1 : 0), radius: 2, x: -2, y: -2)
//                .padding(-3)
//                .overlay(content: {
//                    RoundedRectangle(cornerRadius: 32)
//                        .fill(Color.accentColor.opacity(0.8))
//                        .padding(-3)
//                })
//                
//            // Resetting rotation
//                .rotationEffect(.init(degrees: -item.rotation))
//                .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
//                .offset(x: item.offset)
//                .rotationEffect(.init(degrees: item.rotation))
//            // Placing active item at top
//                .zIndex(isSelected ? 2 : item.zindex)
//        } else {
//            Image(systemName: item.image)
//                        .font(.system(size: 80))
//                        .foregroundStyle(.white.shadow(.drop(radius: 10)))
//                        .blendMode(.overlay)
//                        .frame(width: 120, height: 120)
//                        .background(Color.accentColor.gradient, in: .rect(cornerRadius: 32))
//                        .background {
//                            RoundedRectangle(cornerRadius: 35)
//                                .fill(.secondary)
//                                .shadow(color: Color.accentColor.opacity(1), radius: 2, x: 2, y: 2)
//                                .shadow(color: Color.accentColor.opacity(1), radius: 2, x: -2, y: -2)
//                                .padding(-3)
//                                .opacity(selectedSplashItem.id == item.id ? 1 : 0)
//                        }
//                        // Resetting rotation
//                        .rotationEffect(.init(degrees: -item.rotation))
//                        .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
//                        .offset(x: item.offset)
//                        .rotationEffect(.init(degrees: item.rotation))
//                        // Placing active item at top
//                        .zIndex(isSelected ? 2 : item.zindex)
//        }
        
    }
    
    func updateItem(isForward: Bool) {
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else { return }
        var fromIndex: Int
        var extraOffset: CGFloat
        // To Index
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }

        // From Index
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        } else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1
        }
        
        
        /// Resetting ZIndex
        for index in introItems.indices {
            introItems[index].zindex = 0
        }
        
        Task { [fromIndex, extraOffset] in
            // Shifting from and to icon locations
            withAnimation(.bouncy(duration: 1)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                /// Temporary Adjustment
                introItems[activeIndex].offset = extraOffset
                /// The moment the selected item is updated, it pushes the from card all the way to the back in terms of the zIndex
                /// To solve this we can make use of ZIndex property to just place the from card below the to card
                /// EG: To card position: 2
                /// From card position: 1
                /// Others 0
                introItems[fromIndex].zindex = 1
            }
            
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.9)) {
                // To location is always at the center
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero

                // Updating selected Item
                selectedSplashItem = introItems[activeIndex]
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView(isFirstLaunch: .constant(true))
    }
}
