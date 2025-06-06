//
//  LayoutSettingsSection.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 07.06.25.
//


import SwiftUI

struct LayoutSettingsSection: View {
    @ObservedObject var settings: Settings
    
    var body: some View {
        Section(header: Text("Layout"), 
                footer: Text("Wählen Sie das gewünschte Layout für die App. Die Änderung wird sofort angewendet.")) {
            
            // Layout Mode Picker
            Picker("Layout Mode", selection: $settings.layoutMode) {
                ForEach(Settings.LayoutMode.allCases, id: \.self) { mode in
                    HStack {
                        Image(systemName: layoutIcon(for: mode))
                            .foregroundColor(.accentColor)
                        Text(mode.displayName)
                    }
                    .tag(mode)
                }
            }
            .pickerStyle(.menu)
            
            // Aktuelle Geräte-Info anzeigen
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Aktuelles Gerät: \(currentDeviceType)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("Verwendetes Layout: \(currentLayoutDescription)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 2)
            
            // Zusätzliche Informationen basierend auf aktuellem Layout
            if settings.layoutMode != .automatic {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundColor(.orange)
                    
                    Text("Layout wird erzwungen und passt sich nicht automatisch an das Gerät an.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                }
                .padding(.vertical, 2)
            }
        }
    }
    
    // MARK: - Helper Properties
    
    /// Bestimmt das aktuell verwendete Layout basierend auf Einstellungen und Gerät
    private var currentLayoutDescription: String {
        let isiPad = UIDevice.current.userInterfaceIdiom == .pad
        
        switch settings.layoutMode {
        case .automatic:
            return isiPad ? "iPad Layout (automatisch)" : "iPhone Layout (automatisch)"
        case .forceiPhone:
            return "iPhone Layout (erzwungen)"
        case .forceiPad:
            return "iPad Layout (erzwungen)"
        }
    }
    
    /// Gibt den aktuellen Gerätetyp zurück
    private var currentDeviceType: String {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return "iPad"
        case .phone:
            return "iPhone"
        case .mac:
            return "Mac"
        case .tv:
            return "Apple TV"
        case .carPlay:
            return "CarPlay"
        case .vision:
            return "Vision Pro"
        default:
            return "Unbekannt"
        }
    }
    
    // MARK: - Helper Functions
    
    /// Gibt das passende SF Symbol für den Layout-Modus zurück
    private func layoutIcon(for mode: Settings.LayoutMode) -> String {
        switch mode {
        case .automatic:
            return "rectangle.2.swap"
        case .forceiPhone:
            return "iphone"
        case .forceiPad:
            return "ipad"
        }
    }
}
