//
//  LottieAnimationView2.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 08.12.23.
//

import SwiftUI
import Lottie

struct LottieAnimationView2: UIViewRepresentable {
        
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        

        DotLottieFile.loadedFrom(url: Bundle.main.url(forResource: "foodAnimation", withExtension: "lottie")!) { result in
            switch result {
                case.success(let success):
                    animationView.loadAnimation(from: success)
                    animationView.loopMode = .loop
                    animationView.animationSpeed = 1.3
                    animationView.play()

                case.failure(let failure):
                    print(failure)
            }
        }
    }
}
