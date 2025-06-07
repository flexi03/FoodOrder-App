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
    let details: String?
    
    init(message: String, type: ToastType, details: String? = nil) {
        self.message = message
        self.type = type
        self.details = details
    }
    
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
    @Published var expandedToastId: UUID? {
        didSet {
            if expandedToastId != nil {
                pauseCurrentTimer()
            } else {
                resumeCurrentTimer()
            }
        }
    }
    private var currentTimer: Timer?
    private var currentTimerToastId: UUID?
    private var pausedTimerInfo: (toastId: UUID, remainingTime: TimeInterval)?
    private var timers: [UUID: Timer] = [:]
    private var pausedTimers: [UUID: (startTime: Date, duration: TimeInterval)] = [:]
    
    static let shared = ToastManager()
    
    private init() {}
    
    func show(message: String, type: ToastType, details: String? = nil) {
        let toast = Toast(message: message, type: type, details: details)
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.insert(toast, at: 0) // Insert at beginning to make newest on top
        }
        
        // Start timer for the new topmost toast (5 seconds for new toast)
        if expandedToastId == nil {
            startTimerForTopmostToast(duration: 5.0)
        }
    }
    
    func dismiss(_ toast: Toast) {
        timers[toast.id]?.invalidate()
        timers.removeValue(forKey: toast.id)
        pausedTimers.removeValue(forKey: toast.id)
        
        // If this toast was expanded, collapse it
        if expandedToastId == toast.id {
            expandedToastId = nil
        }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.removeAll { $0.id == toast.id }
        }
    }
    
    func dismissAll() {
        timers.values.forEach { $0.invalidate() }
        timers.removeAll()
        pausedTimers.removeAll()
        expandedToastId = nil
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            toasts.removeAll()
        }
    }
    
    func toggleExpanded(_ toastId: UUID) {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            if expandedToastId == toastId {
                expandedToastId = nil
            } else {
                expandedToastId = toastId
            }
        }
    }
    
    // MARK: - Timer Management
    private func startTimerForTopmostToast(duration: TimeInterval) {
        // Clear any existing timer
        currentTimer?.invalidate()
        currentTimer = nil
        currentTimerToastId = nil
        
        // Get the topmost toast (first in array)
        guard let topmostToast = toasts.first else { return }
        
        // Start new timer for topmost toast
        currentTimerToastId = topmostToast.id
        currentTimer = Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { _ in
            self.dismiss(topmostToast)
        }
    }
    
    private func pauseCurrentTimer() {
        guard let timer = currentTimer,
              let toastId = currentTimerToastId,
              let toast = toasts.first(where: { $0.id == toastId }) else { return }
        
        // Calculate remaining time
        let elapsed = Date().timeIntervalSince(toast.timestamp)
        let totalDuration: TimeInterval = (toastId == toasts.first?.id) ? 5.0 : 1.5
        let remaining = max(0, totalDuration - elapsed)
        
        // Store paused info
        pausedTimerInfo = (toastId: toastId, remainingTime: remaining)
        
        // Stop current timer
        timer.invalidate()
        currentTimer = nil
        currentTimerToastId = nil
    }
    
    private func resumeCurrentTimer() {
        guard let pausedInfo = pausedTimerInfo else {
            // No paused timer, start new one for topmost toast
            if !toasts.isEmpty {
                startTimerForTopmostToast(duration: 5.0)
            }
            return
        }
        
        // Check if the paused toast still exists and is still the topmost
        guard let toast = toasts.first(where: { $0.id == pausedInfo.toastId }),
              toast.id == toasts.first?.id else {
            // Paused toast is no longer topmost, start new timer for current topmost
            pausedTimerInfo = nil
            if !toasts.isEmpty {
                startTimerForTopmostToast(duration: 1.5)
            }
            return
        }
        
        // Resume timer with remaining time
        currentTimerToastId = pausedInfo.toastId
        currentTimer = Timer.scheduledTimer(withTimeInterval: pausedInfo.remainingTime, repeats: false) { _ in
            self.dismiss(toast)
        }
        
        pausedTimerInfo = nil
    }
}

// MARK: - Toast View
struct ToastView: View {
    let toast: Toast
    let index: Int
    let onDismiss: () -> Void
    
    @StateObject private var toastManager = ToastManager.shared
    @State private var dragOffset: CGSize = .zero
    @State private var isDragging = false
    
    private var isExpanded: Bool {
        toastManager.expandedToastId == toast.id
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Main Toast Content
            HStack(spacing: 12) {
                // Icon
                Image(systemName: toast.type.icon)
                    .font(.title2)
                    .foregroundColor(toast.type.color)
                
                // Message
                VStack(alignment: .leading, spacing: 4) {
                    Text(toast.message)
                        .font(.body)
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(isExpanded ? nil : 2)
                    
                    if !isExpanded {
                        Text(DateFormatter.toastTimeFormatter.string(from: toast.timestamp))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                // Expand button (only show if there are details or if message is long)
                if toast.details != nil || toast.message.count > 50 {
                    Button(action: {
                        toastManager.toggleExpanded(toast.id)
                    }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .frame(width: 30, height: 30)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(toast.type.color.opacity(0.3), lineWidth: isExpanded ? 2 : 1)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                // Close Button
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.red.opacity(0.3), lineWidth: isExpanded ? 2 : 1)
                        )
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding()
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 8) {
                    Divider()
                        .background(toast.type.color.opacity(0.3))
                    
                    if let details = toast.details {
                        Text("Details:")
                            .font(.caption.bold())
                            .foregroundColor(.secondary)
                        
                        Text(details)
                            .font(.caption)
                            .foregroundColor(.primary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    HStack {
                        Text("Time: \(DateFormatter.toastDetailTimeFormatter.string(from: toast.timestamp))")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("Type: \(String(describing: toast.type).capitalized)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.regularMaterial)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(toast.type.color.opacity(0.3), lineWidth: isExpanded ? 2 : 1)
        )
        .scaleEffect(isExpanded ? 1.0 : scaleForIndex)
        .offset(y: isExpanded ? 0 : (offsetForIndex + dragOffset.height))
        .opacity(isExpanded ? 1.0 : opacityForIndex)
        .zIndex(isExpanded ? 1000 : Double(toastManager.toasts.count - index - 1)) // Higher index = higher z-index, newest (index 0) gets highest
        .gesture(
            DragGesture()
                .onChanged { value in
                    if !isExpanded && value.translation.height > 0 {
                        dragOffset = value.translation
                        isDragging = true
                    }
                }
                .onEnded { value in
                    if !isExpanded && value.translation.height > 50 {
                        onDismiss()
                    } else {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            dragOffset = .zero
                        }
                    }
                    isDragging = false
                }
        )
        .disabled(isExpanded && index > 0) // Disable interaction for background toasts when one is expanded
    }
    
    private var scaleForIndex: CGFloat {
        let baseScale: CGFloat = 1.0
        let scaleReduction: CGFloat = 0.05
        return max(baseScale - (CGFloat(index) * scaleReduction), 0.8)
    }
    
    private var offsetForIndex: CGFloat {
        let baseOffset: CGFloat = 0
        let offsetIncrease: CGFloat = 8 // Changed to positive to move older toasts up
        return baseOffset + (CGFloat(index) * offsetIncrease)
    }
    
    private var opacityForIndex: Double {
        let baseOpacity: Double = 1.0
        let opacityReduction: Double = 0.15
        return max(baseOpacity - (Double(index) * opacityReduction), 0.3)
    }
}

// MARK: - Toast Container
struct ToastContainer: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack(alignment: .bottom) {
                ForEach(Array(toastManager.toasts.enumerated()), id: \.element.id) { index, toast in
                    ToastView(
                        toast: toast,
                        index: index
                    ) {
                        toastManager.dismiss(toast)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
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
    func showError(_ message: String, details: String? = nil) {
        show(message: message, type: .error, details: details)
    }
    
    func showWarning(_ message: String, details: String? = nil) {
        show(message: message, type: .warning, details: details)
    }
    
    func showSuccess(_ message: String, details: String? = nil) {
        show(message: message, type: .success, details: details)
    }
    
    func showInfo(_ message: String, details: String? = nil) {
        show(message: message, type: .info, details: details)
    }
    
    func showDebug(_ message: String, details: String? = nil) {
        show(message: message, type: .debug, details: details)
    }
}

// MARK: - Date Formatters
extension DateFormatter {
    static let toastTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    static let toastDetailTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()
}

// MARK: - Demo View
struct ToastTesterView: View {
    @StateObject private var toastManager = ToastManager.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Button("Error Toast") {
                    toastManager.showError(
                        "Dies ist eine Fehlermeldung!",
                        details: "Fehlercode: E001\nBeschreibung: Verbindung zum Server fehlgeschlagen\nLösung: Bitte versuchen Sie es später erneut"
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .red))
                
                Button("Warning Toast") {
                    toastManager.showWarning(
                        "Achtung: Dies ist eine Warnung!",
                        details: "Warnung: Niedriger Akkustand erkannt. Bitte laden Sie Ihr Gerät auf."
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .orange))
                
                Button("Success Toast") {
                    toastManager.showSuccess(
                        "Erfolgreich gespeichert!",
                        details: "Datei wurde erfolgreich in der Cloud gespeichert.\nGröße: 2.5 MB\nSpeicherort: /Documents/wichtige_datei.pdf"
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .green))
                
                Button("Info Toast") {
                    toastManager.showInfo(
                        "Hier ist eine Information für dich.",
                        details: "Die App wurde auf Version 2.1.0 aktualisiert.\nNeue Features:\n• Verbesserte Performance\n• Neue Benutzeroberfläche\n• Bug-Fixes"
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .blue))
                
                Button("Debug Toast") {
                    toastManager.showDebug(
                        "Debug: Wert = 42",
                        details: "Debug-Information:\nMemory Usage: 45.2 MB\nCPU Usage: 12%\nNetwork Status: Connected\nLast API Call: 200 OK"
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .purple))
                
                Button("Long Message Toast") {
                    toastManager.showInfo(
                        "Dies ist eine sehr lange Nachricht, die zeigt, wie Toasts mit viel Text umgehen. Sie sollte expandierbar sein, auch ohne explizite Details, da der Text sehr lang ist und mehr Platz benötigt.",
                        details: "Zusätzliche Details können hier angezeigt werden, wenn der Toast erweitert wird."
                    )
                }
                .buttonStyle(ToastButtonStyle(color: .teal))
                
                Divider()
                    .padding(.vertical)
                
                Button("Mehrere Toasts") {
                    toastManager.showError("Fehler 1", details: "Erster Fehler mit Details")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        toastManager.showWarning("Warnung 1", details: "Erste Warnung mit Details")
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        toastManager.showSuccess("Erfolg 1", details: "Erster Erfolg mit Details")
                    }
                }
                .buttonStyle(ToastButtonStyle(color: .gray))
                
                Button("Alle schließen") {
                    toastManager.dismissAll()
                }
                .buttonStyle(ToastButtonStyle(color: .red))
                
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
struct ToastTesterView_Previews: PreviewProvider {
    static var previews: some View {
        ToastTesterView()
    }
}
