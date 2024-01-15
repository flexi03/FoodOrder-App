//
//  WorkingDetailView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 16.12.23.
//

import SwiftUI

struct WorkingTimeDetailsView: View {
    var workingTime: WorkingTime
    
    var onDelete: () -> Void // Closure für Löschaktion
        @State private var isDeleteAlertPresented = false


    var body: some View {
        Form {
            ScrollView {
                Text("Startzeit: \(formattedTime(workingTime.startTime))")
                    .padding()
                Text("Endzeit: \(formattedTime(workingTime.endTime))")
                    .padding()
                Text("Reguläre Arbeitszeit: \(workingTime.regularHours, specifier: "%.1f") Stunden")
                    .padding()
                Text("Überstunden: \(workingTime.overtimeHours) h \(workingTime.overtimeMinutes) min")
                    .foregroundColor(workingTime.overtimeHours < 0 || workingTime.overtimeMinutes < 0 ? .red : .primary)
                    .padding()
                
                Button(action: {
                               isDeleteAlertPresented = true
                           }, label: {
                               Text("Auswahl löschen")
                                   .fontWeight(.bold)
                                   .foregroundColor(.white)
                                   .frame(maxWidth: .infinity)
                                   .padding(.vertical, 14)
                                   .background(Color.red)
                                   .contentShape(Rectangle())
                                   .cornerRadius(12)
                           })
                           .alert(isPresented: $isDeleteAlertPresented) {
                               Alert(
                                   title: Text("Arbeitszeit löschen"),
                                   message: Text("Möchten Sie diese Arbeitszeit wirklich löschen?"),
                                   primaryButton: .destructive(Text("Löschen")) {
                                       onDelete() // Aufruf der Löschaktion
                                   },
                                   secondaryButton: .cancel()
                               )
                           }
                
            }
            .navigationTitle("Details zum \(formattedDate(workingTime.date))")
//            .padding()
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }

    private func formattedTime(_ time: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: time)
    }
}
