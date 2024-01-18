//
//  WorkingTimeView.swift
//  HospitalFoodOrder
//
//  Created by Felix Kircher on 12.12.23.
//

import SwiftUI
import PDFKit
import Charts

struct WorkingTimeView: View {
    @State private var selectedDate = Date()
    @State private var selectedStartTime = Date()
    @State private var selectedEndTime = Date()
    @State private var regularHours = 3.0
    @State private var overtimeHours = 0
    @State private var overtimeMinutes = 0
    
    @State private var userName: String = ""
    
    @State private var workingTimes: [WorkingTime] = []
    
    @State private var isDeleteActionSheetPresented = false
    @State private var isExportActionSheetPresented = false
    @State private var isMonthPickerPresented = false
    
    @State private var isNoteSelected = false
    @State private var notes: String = ""
    
    var sortedWorkingTimes: [WorkingTime] {
        return workingTimes.sorted { $0.date < $1.date }
    }
    
    @State private var selectedMonth: Date = Date()
    
    @State private var selectedExportOption: ExportOption = .specificMonth
    @State private var selectedExportMonth: Date = Date()
    
    enum ExportOption: String, CaseIterable, Identifiable {
        case allEntries = "Alle Einträge"
        case specificMonth = "Spezifischer Monat"
        
        var id: String { self.rawValue }
    }
    
    
    var filteredWorkingTimes: [WorkingTime] {
        let calendar = Calendar.current
        let monthComponents = calendar.dateComponents([.year, .month], from: selectedMonth)
        let startOfMonth = calendar.date(from: monthComponents)!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        
        return workingTimes.filter { startOfMonth <= $0.date && $0.date <= endOfMonth }
    }
    
    var body: some View {
        Form {
            //            ScrollView {
            Section {
                ScrollView {
                    DatePicker("Datum", selection: $selectedDate, displayedComponents: [.date])
                        .onChange(of: selectedDate) { _ in
                            calculateOvertime()
                        }
                    DatePicker("Startzeit", selection: $selectedStartTime, displayedComponents: [.hourAndMinute])
                        .onChange(of: selectedStartTime) { _ in
                            calculateOvertime()
                        }
                    DatePicker("Endzeit", selection: $selectedEndTime, displayedComponents: [.hourAndMinute])
                        .onChange(of: selectedEndTime) { _ in
                            calculateOvertime()
                        }
                    Text("")
                    
                    HStack {
                        Text("Reguläre Arbeitszeit:")
                        Spacer()
                        TextField("Stunden", value: $regularHours, formatter: createNumberFormatter())
                            .keyboardType(.numbersAndPunctuation)
                            .submitLabel(.done)
                            .padding()
                            .onChange(of: regularHours) { _ in
                                calculateOvertime()
                            }
                    }
                    
                    Toggle("Anmerkungen auf PDF", isOn: $isNoteSelected)
                        .padding(.trailing, 5)
                    if isNoteSelected {
                        TextEditor(text: $notes)
                        //                                   .padding()
                            .frame(height: 150)
                            .cornerRadius(12)
                            .onChange(of: notes, perform: { _ in
                                saveNotes()
                            })
                            .submitLabel(.done)
                    }
                    
                    TextField("Name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .submitLabel(.done)
                        .onChange(of: userName, perform: { _ in
                            saveUserName()
                        })
//                        .cornerRadius(12)
                    
                    
                    Text("Überstunden: \(String(format: "%01d h %02d min", overtimeHours, overtimeMinutes))")
                        .foregroundColor(overtimeHours < 0 || overtimeMinutes < 0 ? .red : .white)                    .padding()
                    Text("Reguläre Arbeitszeit: \(formattedRegularHours)")
                        .padding()
                    
                    Spacer()
//                    AnimatedChart() // MARK: Chart
                    
                    Button(action: {
                        saveWorkingTime()
                        calculateOvertime()
                    }, label: {
                        Text("Auswahl speichern")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.accentColor)
                            .contentShape(Rectangle())
                            .cornerRadius(12)
                    })
                    Spacer()
                    Spacer()
                    
                    Picker("Monat", selection: $selectedMonth) {
                        ForEach(generateMonthRange(), id: \.self) { month in
                            Text(formattedMonth(month))
                        }
                    }
                    .onChange(of: selectedMonth) { _ in
                        // Filtern Sie die Arbeitszeiten, wenn sich der ausgewählte Monat ändert
                        calculateOvertime()
                    }
                    
                    ForEach(filteredWorkingTimes, id: \.id) { workingTime in
                        NavigationLink(destination: WorkingTimeDetailsView(workingTime: workingTime, onDelete: { deleteWorkingTime(workingTime) })) {
                            Text("\(formattedDate(workingTime.date)):  \(workingTime.overtimeHours) h \(workingTime.overtimeMinutes) min")
                        }
                        .foregroundColor(workingTime.overtimeHours < 0 || workingTime.overtimeMinutes < 0 ? .red : .primary)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                        .cornerRadius(12)
                    }
                }
                
            }
            Section("") {
            }
            .frame(height: 50)
        }
        .onAppear {
            UIDatePicker.appearance().minuteInterval = 5
            calculateOvertime()
            restoreWorkingTimes() // Arbeitszeiten beim Start wiederherstellen
            loadUserName() // Benutzernamen beim Start laden
            loadNotes()
        }
        //        }
        .navigationBarItems(
            leading:
                Button(action: {
                    isDeleteActionSheetPresented = true
                }) {
                    Image(systemName: "trash")
                        .fontWeight(.bold)
                }
            ,
            trailing:
                Button(action: {
                    isExportActionSheetPresented = true
                    //                    print("Jetzt gehts zum Exportieren bzw der Auswahl.")
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .fontWeight(.bold)
                }
            
        )
        
        .actionSheet(isPresented: $isDeleteActionSheetPresented) {
            ActionSheet(
                title: Text("Arbeitszeiten löschen"),
                message: Text("Möchten Sie alle Arbeitszeiten oder nur die aus dem unten ausgewählten Monat löschen?"),
                buttons: [
                    .default(Text("Alle löschen")) {
                        deleteAllWorkingTimes()
                    },
                    .default(Text("Nur aus ausgewähltem Monat löschen")) {
                        deleteWorkingTimesInSelectedMonth()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $isExportActionSheetPresented) {
            VStack {
                Text("")
                
                Picker("Exportoption auswählen", selection: $selectedExportOption) {
                    ForEach(ExportOption.allCases) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                if selectedExportOption == .specificMonth {
                    Spacer(minLength: 60)
                    Picker("Monat", selection: $selectedMonth) {
                        ForEach(generateMonthRange(), id: \.self) { month in
                            Text(formattedMonthOnly(month))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .onChange(of: selectedMonth) { _ in
                        // Filtern Sie die Arbeitszeiten, wenn sich der ausgewählte Monat ändert
                        calculateOvertime()
                    }
                    Spacer(minLength: 60)
                    
                    Button("Export von \(formattedMonthOnly(selectedMonth))") {
                        // Initiiere den PDF-Export auf dem Hauptthread
                        DispatchQueue.main.async {
                            exportAsPDF()
                        }
                        // isExportActionSheetPresented = false // Je nach gewünschtem Verhalten
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .contentShape(Rectangle())
                    .cornerRadius(12)
                    
                }
                
                if selectedExportOption == .allEntries {
                    Spacer(minLength: 150)
                    // @ChatGPT: Hier eine Liste von Monaten, die Einträge haben
                    List(generateMonthsForEntries(), id: \.date) { identifiableDate in
                        Text(formattedMonthOnly(identifiableDate.date))
                    }
                    .listStyle(GroupedListStyle())
                    
                    
                    Spacer(minLength: 150)
                    
                    Button("Export von Allen Einträgen") {
                        // Initiiere den PDF-Export auf dem Hauptthread
                        DispatchQueue.main.async {
                            exportAsPDF()
                        }
                        // isExportActionSheetPresented = false // Je nach gewünschtem Verhalten
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.accentColor)
                    .contentShape(Rectangle())
                    .cornerRadius(12)
                }
                
                //                Button("Exportieren") {
                //                    // Initiiere den PDF-Export auf dem Hauptthread
                //                    DispatchQueue.main.async {
                //                        exportAsPDF()
                //                    }
                //                    // isExportActionSheetPresented = false // Je nach gewünschtem Verhalten
                //                }
                ////                .padding()
                //                .foregroundColor(.white)
                //                .background(Color.accentColor)
                //                .cornerRadius(12)
            }
            .padding()
        }
        .navigationTitle("Arbeitszeiterfassung")
        //        .padding()
    }
    
//    // MARK: Chart
//    @ViewBuilder
//    func AnimatedChart() -> some View {
//        Chart {
//            ForEach(sortedWorkingTimes) {item in
//                BarMark(x: .value("Tag", item.date, unit: .day),
//                        y: .value("Überstunden", item.overtimeHours))
//            }
//        }
//        .frame(height: 250)
//    }
    
    private func deleteAllWorkingTimes() {
        workingTimes.removeAll()
        saveWorkingTimes()
    }
    
    private func deleteWorkingTimesInSelectedMonth() {
        workingTimes = workingTimes.filter { workingTime in
            let calendar = Calendar.current
            let monthComponents = calendar.dateComponents([.year, .month], from: selectedMonth)
            let startOfMonth = calendar.date(from: monthComponents)!
            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            
            return !(startOfMonth <= workingTime.date && workingTime.date <= endOfMonth)
        }
        saveWorkingTimes()
        calculateOvertime()
    }
    
    
    private func saveWorkingTime() {
        let newWorkingTime = WorkingTime(
            id: UUID(),
            date: selectedDate,
            startTime: selectedStartTime,
            endTime: selectedEndTime,
            regularHours: regularHours,
            overtimeHours: overtimeHours,
            overtimeMinutes: overtimeMinutes
        )
        workingTimes.append(newWorkingTime)
        
        saveWorkingTimes() // Arbeitszeiten nach dem Hinzufügen speichern
    }
    
    private func saveUserName() {
        UserDefaults.standard.set(userName, forKey: "userName")
    }
    
    private func saveNotes() {
        UserDefaults.standard.set(notes, forKey: "notes")
    }
    
    private func loadNotes() {
        if let storedNotes = UserDefaults.standard.string(forKey: "notes") {
            notes = storedNotes
        }
    }
    
    private func loadUserName() {
        if let storedUserName = UserDefaults.standard.string(forKey: "userName") {
            userName = storedUserName
        }
    }
    
    private func restoreWorkingTimes() {
        if let storedData = UserDefaults.standard.data(forKey: "workingTimes"),
           let decodedWorkingTimes = try? JSONDecoder().decode([WorkingTime].self, from: storedData) {
            workingTimes = decodedWorkingTimes
        }
    }
    
    private func saveWorkingTimes() {
        if let encodedData = try? JSONEncoder().encode(workingTimes) {
            UserDefaults.standard.set(encodedData, forKey: "workingTimes")
        }
    }
    
    private func calculateOvertime() {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: selectedStartTime, to: selectedEndTime)
        
        guard let hours = components.hour, let minutes = components.minute else {
            return
        }
        
        let totalMinutesWorked = hours * 60 + minutes
        let regularMinutes = Int(regularHours * 60)
        let overtimeMinutesValue = totalMinutesWorked - regularMinutes
        
        overtimeHours = overtimeMinutesValue / 60
        overtimeMinutes = overtimeMinutesValue % 60
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Verwenden Sie die aktuelle Gerätesprache
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    private func exportAsPDF() {
        var filteredWorkingTimes: [WorkingTime]
        
        switch selectedExportOption {
            case .allEntries:
                filteredWorkingTimes = sortedWorkingTimes
            case .specificMonth:
                let calendar = Calendar.current
                let monthComponents = calendar.dateComponents([.year, .month], from: selectedExportMonth)
                let startOfMonth = calendar.date(from: monthComponents)!
                let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
                filteredWorkingTimes = sortedWorkingTimes.filter { startOfMonth <= $0.date && $0.date <= endOfMonth }
        }
        
        // Den PDF-Export in einen Hintergrund-Task verschieben
        DispatchQueue.global(qos: .background).async {
            let pdfCreator = PDFCreator(sortedWorkingTimes: filteredWorkingTimes, userName: userName, isNoteSelected: isNoteSelected, notes: notes)
            pdfCreator.createPDF()
        }
    }
    
    
    //    private func exportAsPDF() {
    //        var filteredWorkingTimes: [WorkingTime]
    //
    //        switch selectedExportOption {
    //        case .allEntries:
    //            filteredWorkingTimes = sortedWorkingTimes
    //        case .specificMonth:
    //            let calendar = Calendar.current
    //            let monthComponents = calendar.dateComponents([.year, .month], from: selectedExportMonth)
    //            let startOfMonth = calendar.date(from: monthComponents)!
    //            let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
    //            filteredWorkingTimes = sortedWorkingTimes.filter { startOfMonth <= $0.date && $0.date <= endOfMonth }
    //        }
    //
    //        let pdfCreator = PDFCreator(sortedWorkingTimes: filteredWorkingTimes, userName: userName)
    //        pdfCreator.createPDF()
    //    }
    
    func createNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumIntegerDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        return formatter
    }
    
    var formattedRegularHours: String {
        let hours = Int(regularHours)
        let minutes = Int((regularHours - Double(hours)) * 60)
        return "\(hours) h \(minutes) min"
    }
    
    private func deleteWorkingTime(_ workingTime: WorkingTime) {
        if let index = workingTimes.firstIndex(where: { $0.id == workingTime.id }) {
            workingTimes.remove(at: index)
            saveWorkingTimes() // Nach dem Löschen speichern
        }
    }
    
    // Funktion zum Generieren eines Monatsbereichs für den Picker
    private func generateMonthRange() -> [Date] {
        let calendar = Calendar.current
        var months: [Date] = []
        
        // Erzeugen Sie einen Bereich von 12 Monaten ab dem ausgewählten Monat
        for i in -6..<6 {
            if let month = calendar.date(byAdding: .month, value: i, to: selectedMonth) {
                months.append(month)
            }
        }
        
        return months
    }
    // Funktion zum Formatieren des Monats
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Verwenden Sie die aktuelle Gerätesprache
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func formattedMonthOnly(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func generateMonthsForEntries() -> [IdentifiableDate] {
        var uniqueMonths = Set<String>()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        
        let identifiableDates: [IdentifiableDate] = workingTimes.compactMap { workingTime in
            let monthString = dateFormatter.string(from: workingTime.date)
            guard !uniqueMonths.contains(monthString) else { return nil }
            uniqueMonths.insert(monthString)
            return IdentifiableDate(date: workingTime.date)
        }
        
        return identifiableDates.sorted(by: { $0.date < $1.date })
    }
    
    struct IdentifiableDate: Identifiable, Hashable {
        var id: Date { date }
        let date: Date
    }
    
    
}



struct WorkingTime: Identifiable, Encodable, Decodable {
    var id: UUID
    var date: Date
    var startTime: Date
    var endTime: Date
    var regularHours: Double
    var overtimeHours: Int
    var overtimeMinutes: Int
}

struct PDFCreator {
    let sortedWorkingTimes: [WorkingTime]
    let userName: String
    let isNoteSelected: Bool
    let notes: String

    func createPDF() {
        DispatchQueue.global(qos: .background).async {
            let pdfData = NSMutableData()
            
            UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
            
            let groupedWorkingTimes = Dictionary(grouping: sortedWorkingTimes) { workingTime in
                let components = Calendar.current.dateComponents([.year, .month], from: workingTime.date)
                return Calendar.current.date(from: components)!
            }
            
            // Sortieren Sie die Monate
            let sortedGroupedWorkingTimes = groupedWorkingTimes.sorted { $0.key < $1.key }
            
            if let context = UIGraphicsGetCurrentContext() {
                for (date, workingTimes) in sortedGroupedWorkingTimes {
                    // Neue Seite für jeden Monat
                    UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0, y: 0, width: 612, height: 792), nil)
                    
                    // Überschrift für den Monat (fett)
                    drawText("Monat: \(formattedMonth(date))", isHeading: true, inContext: context, atPoint: CGPoint(x: 50, y: 50))

                    // Benutzername auf jeder Seite anzeigen (fett)
                    if userName == "" {
                        drawText("Name: _____________________", isName: true, inContext: context, atPoint: CGPoint(x: 350, y: 50))
                    } else {
                        drawText("Name: \(userName)", isName: true, inContext: context, atPoint: CGPoint(x: 350, y: 50))

                    }
                    
                    // Tabelle Überschrift
                    drawTableHeader(inContext: context, isBold: true , atPoint: CGPoint(x: 50, y: 80))

                    // Tabelle zeichnen
                    drawTableRow(workingTimes, inContext: context, atPoint: CGPoint(x: 50, y: 100))
                    
                    if isNoteSelected == true {
                        drawText("Anmerkungen:", isBold: true, inContext: context, atPoint: CGPoint(x: 50, y: 650))
                        drawNotes(notes: notes, isNoteSelected: true, inContext: context, atPoint: CGPoint(x: 50, y: 680))
                    }
                    

                    // Gesamtüberstunden zeichnen (fett)
                    drawTotalOvertime(workingTimes, inContext: context, atPoint: CGPoint(x: 400, y: 720))
                    
                    // Erstellt am
                    drawCreatedAt(inContext: context, atPoint: CGPoint(x: 210, y: 750))
                    
                    // Fußzeile zeichnen
                    drawFooter(inContext: context, atPoint: CGPoint(x: 210, y: 770))
                }
            }
            
            UIGraphicsEndPDFContext()
            
            DispatchQueue.main.async {
                if let data = pdfData as Data? {
                    let activityViewController = UIActivityViewController(activityItems: [data], applicationActivities: nil)
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                        let topViewController = windowScene.windows.first?.rootViewController?.topMostViewController {
                        topViewController.present(activityViewController, animated: true, completion: nil)
                    }

                    
                }
            }
        }
    }
    
    private func drawTotalOvertime(_ workingTimes: [WorkingTime], inContext context: CGContext, atPoint point: CGPoint) {
        // Berechnen Sie die Gesamtüberstunden für den Monat
        let totalOvertimeMinutes = workingTimes.reduce(0) { $0 + $1.overtimeHours * 60 + $1.overtimeMinutes }
        
        // Gesamtüberstunden zeichnen
        drawText("Gesamtüberstunden: \(totalOvertimeMinutes / 60) h \(totalOvertimeMinutes % 60) min", isBold: true, inContext: context, atPoint: point)
    }
    
    
    private func drawTableHeader(inContext context: CGContext, isBold: Bool = true, atPoint point: CGPoint) {
        // Kopfzeile für die Tabelle zeichnen
        drawText("Datum", isBold: true, inContext: context, atPoint: CGPoint(x: point.x, y: point.y))
        drawText("Startzeit", isBold: true, inContext: context, atPoint: CGPoint(x: point.x + 150, y: point.y))
        drawText("Endzeit", isBold: true, inContext: context, atPoint: CGPoint(x: point.x + 300, y: point.y))
        drawText("Überstunden", isBold: true, inContext: context, atPoint: CGPoint(x: point.x + 450, y: point.y))
    }

    
    private func drawTableRow(_ workingTimes: [WorkingTime], inContext context: CGContext, atPoint point: CGPoint) {
        // Zeile in der Tabelle zeichnen
        var currentY = point.y
        
        for workingTime in workingTimes {
            drawText(formattedDate(workingTime.date), inContext: context, atPoint: CGPoint(x: point.x, y: currentY))
            drawText(formattedTime(workingTime.startTime), inContext: context, atPoint: CGPoint(x: point.x + 150, y: currentY))
            drawText(formattedTime(workingTime.endTime), inContext: context, atPoint: CGPoint(x: point.x + 300, y: currentY))
            drawText("\(workingTime.overtimeHours) h \(workingTime.overtimeMinutes) min", inContext: context, atPoint: CGPoint(x: point.x + 450, y: currentY))
            
            currentY += 20 // Einen Abstand von 20 Punkten zwischen den Einträgen einfügen
        }
    }
    
    private func drawText(_ text: String, isBold: Bool = false, isHeading: Bool = false, isName: Bool = false, isFooter: Bool = false, isCreation: Bool = false, inContext context: CGContext, atPoint point: CGPoint) {
        let font: UIFont
        let textColor: UIColor
        
        if isHeading {
            font = UIFont.boldSystemFont(ofSize: 18)
            textColor = UIColor.black
        } else if isBold {
            font = UIFont.boldSystemFont(ofSize: 12)
            textColor = UIColor.black
        } else if isName {
            font = UIFont.boldSystemFont(ofSize: 15)
            textColor = UIColor.black
        } else if isFooter {
            font = UIFont.boldSystemFont(ofSize: 6)
            textColor = UIColor.lightText
        } else if isCreation {
            font = UIFont.boldSystemFont(ofSize: 6)
            textColor = UIColor.lightText
        } else {
            font = UIFont.systemFont(ofSize: 12)
            textColor = UIColor.black
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        let attributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.foregroundColor: textColor
        ]
        let attributedString = NSAttributedString(string: text, attributes: attributes)
        let textRect = CGRect(x: point.x, y: point.y, width: 500, height: 50) // Passen Sie die Breite und Höhe nach Bedarf an
        attributedString.draw(in: textRect)
    }
    
    private func drawFooter(isFooter: Bool = true, inContext context: CGContext, atPoint point: CGPoint) {
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {

            let versionText = "Version: \(appVersion) (\(buildNumber))"
            print(versionText)

            // Hier kannst du `versionText` in deiner App verwenden, z.B. es in einer Label anzeigen.
            drawText("FoodOrder App Version: \(appVersion) (\(buildNumber))", inContext: context, atPoint: point)
        }
        
    }
    
    private func drawCreatedAt(isCreation: Bool = true, inContext context: CGContext, atPoint point: CGPoint) {
        
        drawText("Erstellt am: \(formattedDateNow(.now))", inContext: context, atPoint: point)
    }
    
    private func drawNotes(notes: String, isNoteSelected: Bool = true, inContext context: CGContext, atPoint point: CGPoint) {
        drawText(notes, inContext: context, atPoint: point)
    }
    
    private func formattedDateNow(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current // Verwenden Sie die aktuelle Gerätesprache
        formatter.dateFormat = "dd.MM.yyyy HH:mm:ss"
    
        return formatter.string(from: date)
    }
    
//    private func drawText(_ text: String, inContext context: CGContext, atPoint point: CGPoint) {
//        let font = UIFont.systemFont(ofSize: 12)
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = .left
//        let attributes = [
//            NSAttributedString.Key.font: font,
//            NSAttributedString.Key.paragraphStyle: paragraphStyle,
//            NSAttributedString.Key.foregroundColor: UIColor.black
//        ]
//        let attributedString = NSAttributedString(string: text, attributes: attributes)
//        let textRect = CGRect(x: point.x, y: point.y, width: 500, height: 50) // Passen Sie die Breite und Höhe nach Bedarf an
//        attributedString.draw(in: textRect)
//    }
    
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
    
    private func formattedRegularHours(_ hours: Double) -> String {
        let hoursInt = Int(hours)
        let minutesInt = Int((hours - Double(hoursInt)) * 60)
        return "\(hoursInt) h \(minutesInt) min"
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}


struct WorkingTimeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkingTimeView()
    }
}
extension UIViewController {
    var topMostViewController: UIViewController {
        if let presented = presentedViewController {
            return presented.topMostViewController
        }
        if let navigation = self as? UINavigationController {
            return navigation.visibleViewController?.topMostViewController ?? navigation
        }
        if let tab = self as? UITabBarController {
            return tab.selectedViewController?.topMostViewController ?? tab
        }
        return self
    }
}
