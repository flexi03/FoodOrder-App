//
//  Toast.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 07.06.25.
//

import SwiftUI

// MARK: - Toast Model
struct Toast: Identifiable, Equatable {
    let id = UUID()
    let message: String
    let type: ToastType
    let timestamp = Date()
    
    static func == (lhs: Toast, rhs: Toast) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Toast Types
enum ToastType: CaseIterable {
    case error
    case warning
    case success
    case info
    case debug
    
    var color: Color {
        switch self {
        case .error:
            return .red
        case .warning:
            return .orange
        case .success:
            return .green
        case .info:
            return .blue
        case .debug:
            return .purple
        }
    }
    
    var icon: String {
        switch self {
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .success:
            return "checkmark.circle.fill"
        case .info:
            return "info.circle.fill"
        case .debug:
            return "wrench.and.screwdriver.fill"
        }
    }
}

// MARK: - Toast Manager
class ToastManager: ObservableObject {
    @Published var toasts: [Toast] = []
    private var timers: [UUID: Timer] = [:]
    
    static let shared = ToastManager()
    
    private init() {}
    
    func show(message: String, type: ToastType) {
        let toast = Toast(message: message, type: type)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.append(toast)
        }
        
        // Auto-dismiss nach 10 Sekunden
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
            self.dismiss(toast)
        }
        timers[toast.id] = timer
    }
    
    func dismiss(_ toast: Toast) {
        timers[toast.id]?.invalidate()
        timers.removeValue(forKey: toast.id)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.removeAll { $0.id == toast.id }
        }
    }
    
    func dismissAll() {
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.removeAll()
        }
    }
}

// MARK: - Toast View
struct ToastView: View {
    let toast: Toast
    let index: Int
    let onDismiss: () -> Void
    
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: toast.type.icon)
                .font(.title2)
                .foregroundColor(toast.type.color)
            
            // Message
            Text(toast.message)
                .font(.body)
                .foregroundColor(.primary)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
            
            Spacer()
            
            // Close Button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(toast.type.color.opacity(0.3), lineWidth: 1)
        )
        .scaleEffect(scaleForIndex)
        .offset(y: offsetForIndex)
        .opacity(opacityForIndex)
//        .gesture(
//            DragGesture()
//                .onChanged { value in
//                    if value.translation.height > 0 {
//                        dragOffset = value.translation
//                        isDragging = true
//                    }
//                }
//                .onEnded { value in
//                    if value.translation.height > 50 {
//                        onDismiss()
//                    } else {
//                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
//                            dragOffset = .zero
//                        }
//                    }
//                    isDragging = false
//                }
//        )
    }
    
    private var scaleForIndex: CGFloat {
        let baseScale: CGFloat = 1.0
        let scaleReduction: CGFloat = 0.02
        return max(baseScale - (CGFloat(index) * scaleReduction), 0.8)
    }
    
    private var offsetForIndex: CGFloat {
        let baseOffset: CGFloat = 0
        let offsetIncrease: CGFloat = -22
        return baseOffset + (CGFloat(index) * offsetIncrease)
    }
    
    private var opacityForIndex: Double {
        let baseOpacity: Double = 1.0
        let opacityReduction: Double = 0.05
        return max(baseOpacity - (Double(index) * opacityReduction), 0.3)
    }
}

// MARK: - Toast Container
struct ToastContainer: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            
            VStack(spacing: 0) {
                ForEach(Array(toastManager.toasts.enumerated().reversed()), id: \.element.id) { index, toast in
                    ToastView(
                        toast: toast,
                        index: toastManager.toasts.count - 1 - index
                    ) {
                        toastManager.dismiss(toast)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, index == 0 ? 16 : 4)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                }
            }
        }
        .allowsHitTesting(true)
    }
}

// MARK: - View Extension für einfache Verwendung
extension View {
    func withToasts() -> some View {
        ZStack {
            self
            ToastContainer()
        }
    }
}

// MARK: - Convenience Extensions
extension ToastManager {
    func showError(_ message: String) {
        show(message: message, type: .error)
    }
    
    func showWarning(_ message: String) {
        show(message: message, type: .warning)
    }
    
    func showSuccess(_ message: String) {
        show(message: message, type: .success)
    }
    
    func showInfo(_ message: String) {
        show(message: message, type: .info)
    }
    
    func showDebug(_ message: String) {
        show(message: message, type: .debug)
    }
}

// MARK: - Demo View
struct ToastTesterView: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Toast Notification Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 15) {
                    Button("Error Toast") {
                        toastManager.showError("Dies ist eine Fehlermeldung!")
                    }
                    .buttonStyle(ToastButtonStyle(color: .red))
                    
                    Button("Warning Toast") {
                        toastManager.showWarning("Achtung: Dies ist eine Warnung!")
                    }
                    .buttonStyle(ToastButtonStyle(color: .orange))
                    
                    Button("Success Toast") {
                        toastManager.showSuccess("Erfolgreich gespeichert!")
                    }
                    .buttonStyle(ToastButtonStyle(color: .green))
                    
                    Button("Info Toast") {
                        toastManager.showInfo("Hier ist eine Information für dich.")
                    }
                    .buttonStyle(ToastButtonStyle(color: .blue))
                    
                    Button("Debug Toast") {
                        toastManager.showDebug("Debug: Wert = 42")
                    }
                    .buttonStyle(ToastButtonStyle(color: .purple))
                    
                    Divider()
                        .padding(.vertical)
                    
                    Button("Mehrere Toasts") {
                        toastManager.showError("Fehler 1")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            toastManager.showWarning("Warnung 1")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            toastManager.showSuccess("Erfolg 1")
                        }
                    }
                    .buttonStyle(ToastButtonStyle(color: .gray))
                    
                    Button("Alle schließen") {
                        toastManager.dismissAll()
                    }
                    .buttonStyle(ToastButtonStyle(color: .red))
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Toast Demo")
        }
        .withToasts()
    }
}

// MARK: - Custom Button Style
struct ToastButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color)
                    .opacity(configuration.isPressed ? 0.8 : 1.0)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ToastTesterView()
    }
}
