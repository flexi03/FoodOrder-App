//
//  LottieView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 07.12.23.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    
//    let url: URL
    
    func makeUIView(context: Context) -> some UIView {
        UIView()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let animationView = LottieAnimationView()
        let animationView1 = LottieAnimationView(name: "timeTracking");
//        let animationView2 = LottieAnimationView(name: "toggle");
//        let animationView3 = LottieAnimationView(name: "toggle");
//        let animationView4 = LottieAnimationView(name: "toggle");

        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        animationView1.translatesAutoresizingMaskIntoConstraints = false
        uiView.addSubview(animationView1)
        NSLayoutConstraint.activate([
            animationView1.widthAnchor.constraint(equalTo: uiView.widthAnchor),
            animationView1.heightAnchor.constraint(equalTo: uiView.heightAnchor)
        ])
        
        uiView.addSubview(animationView1)
        animationView.play()

//        DotLottieFile.loadedFrom(url: url) { result in
//            switch result {
//                case.success(let success):
//                    animationView.loadAnimation(from: success)
//                    animationView.loopMode = .loop
//                    animationView.animationSpeed = 1.3
//                    animationView.play()
//                    
//                case.failure(let failure):
//                    print(failure)
//            }
//        }
        
        DotLottieFile.loadedFrom(url: Bundle.main.url(forResource: "timeTracking", withExtension: "lottie")!) { result in
            switch result {
                case.success(let success):
//                    animationView1.layer.position = CGPoint(x: 200, y: 150)
                    animationView1.loadAnimation(from: success)
                    animationView1.loopMode = .loop
                    animationView1.animationSpeed = 1.0
                    animationView1.play()
                    
                case.failure(let failure):
                    print(failure)
            }
        }
        
//        DotLottieFile.loadedFrom(url: Bundle.main.url(forResource: "addPlus", withExtension: "lottie")!) { result in
//            switch result {
//                case.success(let success):
//                    animationView1.layer.position = CGPoint(x: 200, y: 150)
//                    animationView1.loadAnimation(from: success)
//                    animationView1.loopMode = .autoReverse
//                    animationView1.animationSpeed = 2.0
//                    animationView1.play()
//                    
//                case.failure(let failure):
//                    print(failure)
//            }
//        }
        
        
    }
    
//    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
//        let view = UIView(frame: .zero)
//        
//        var animationView = LottieAnimationView()
//        animationView.contentMode = .scaleAspectFit
//        animationView.loopMode = .loop
//        
//        animationView = .init(name: "foodAnimation")
//        animationView.translatesAutoresizingMaskIntoConstraints = false
//        animationView.frame = view.bounds
//        animationView.play()
//        LottieAnimation.filepath("foodAnimation.json")
//        LottieView(animation: LottieAnimation)
//        view.addSubview(animationView)
//        
//        return view
//    }
//    
//    func updateUIView(_ uiView: UIView, context: Context) {
//        
//    }
}
