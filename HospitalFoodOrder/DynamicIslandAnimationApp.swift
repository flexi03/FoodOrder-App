////
////  DynamicIslandAnimationApp.swift
////  HospitalFoodOrder
////
////  Created by Felix Kircher on 02.11.23.
////
//
//import SwiftUI
//
//struct DynamicIslandAnimationApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
//    var body: some Scene {
//        WindowGroup {
//            OrderFormView(settings: Settings(), card: Card(bgColor: .purple, balance: 1))
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .overlay(alignment: .top) {
//                    GeometryReader{proxy in
//                        let size = proxy.size
//                        
//                        NotificationPreview(size: size)
//                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
//                    }
//                    .ignoresSafeArea()
//                }
//        }
//    }
//}
//
//struct NotificationPreview: View {
//    var size: CGSize
//    @State var show: Bool = false
//    var body: some View {
//        HStack{
//            
//        }
//        .frame(width: show ? -22 : 126, height: show ? 100 : 37.33)
//        .background {
//            RoundedRectangle(cornerRadius: 63, style: .continuous)
//                .fill(.black)
//        }
//        .offset(y: 11)
//    }
//}
//
//
//class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        UNUserNotificationCenter.current().delegate = self
//        return true
//    }
//    
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
//        if UIApplication.shared.haveDynamicIsland {
//            print("DO ANIMATION")
//            return [.sound]
//        } else {
//            return [.sound,.banner]
//        }
//    }
//}
//
//extension UIApplication {
//    var haveDynamicIsland: Bool {
//        return deviceName == "iPhone 14 Pro" || deviceName == "iPhone 14 Pro Max" || deviceName == "iPhone 15 Pro" || deviceName == "iPhone 15 Pro Max"
//    }
//    
//    var deviceName: String {
//        return UIDevice.current.name
//    }
//}
