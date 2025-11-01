//
//  HistoryView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

import SwiftUI
import SwiftData
import MapKit // Wymagane dla typów map i konwersji

struct HistoryView: View {
    
    // Zapytanie pobierające wszystkie zapisane rekordy, sortowane od najnowszego
    @Query(sort: \TrackingRecord.date, order: .reverse)
    private var records: [TrackingRecord]
    
    @State private var selectedRecord: TrackingRecord?
    
    var body: some View {
        NavigationView {
            List {
                if records.isEmpty {
                    ContentUnavailableView("Brak zapisanych przejazdów", systemImage: "car.fill")
                } else {
                    // Wyświetlanie listy rekordów
                    ForEach(records) { record in
                        VStack(alignment: .leading) {
                            Text(record.date.formatted(date: .abbreviated, time: .shortened))
                                .font(.headline)
                            
                            HStack {
                                Text("Dystans: \(record.distanceInKilometers)")
                                Spacer()
                                Text("Czas: \(record.formattedDuration)")
                                    .foregroundColor(.orange)
                            }
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                        // Po kliknięciu wiersza, ustawiamy wybrany rekord
                        .onTapGesture {
                            self.selectedRecord = record
                        }
                    }
                    // Obsługa usuwania poprzez gest swipe
                    .onDelete(perform: deleteRecords)
                }
            }
            .navigationTitle("Historia Przejazdów")
            // Wyświetlamy SummaryRecordView jako modal (sheet)
            .sheet(item: $selectedRecord) { record in
                SummaryRecordView(record: record)
            }
        }
    }
    
    // Metoda do usuwania rekordów z bazy danych
    private func deleteRecords(offsets: IndexSet) {
        // Poprawne użycie kontekstu modelu do usunięcia
        offsets.forEach { index in
            let record = records[index]
            // Rekordy są automatycznie bindowane do kontekstu, używamy operatora opcjonalnego
            record.modelContext?.delete(record)
        }
    }
}

// MARK: - Konwerter Danych dla SummaryView

// Ta struktura jest potrzebna, ponieważ oryginalny SummaryView oczekuje 'TrackingSession' (struct),
// a my chcemy przekazać zapisany 'TrackingRecord' (@Model).
struct SummaryRecordView: View {
    let record: TrackingRecord
    
    private var tempSession: TrackingSession {
        var session = TrackingSession()
        session.startTime = record.date
        
        // KLUCZOWA ZMIANA: Ustawienie endTime na podstawie durationSeconds
        // Zapisany rekord nie ma endTime, ma tylko durationSeconds.
        // Użyjemy durationSeconds do obliczenia endTime, aby logika 'duration' w struct działała poprawnie.
        
        // Jeśli chcemy użyć logiki daty, musimy to zrobić jawnie:
        session.endTime = record.date.addingTimeInterval(record.durationSeconds)
        session.isRunning = false // Ustawiamy na false, aby wymusić użycie endTime!
        
        session.totalDistance = record.totalDistance
        session.maxSpeed = record.maxSpeed
        session.allCoordinates = record.allCoordinates.map { $0.toCLLocationCoordinate2D }
        return session
    }
    
    var body: some View {
        SummaryView(session: tempSession)
    }
}
