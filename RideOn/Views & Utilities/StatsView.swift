//
//  StatsView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 02/11/2025.
//

// StatsView.swift
import SwiftUI
import SwiftData

struct StatsView: View {
    
    @StateObject private var viewModel = StatsViewModel()
    @Query private var records: [TrackingRecord]
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.stats?.totalRides == 0 {
                    ContentUnavailableView("Brak danych historycznych", systemImage: "chart.bar.fill")
                } else if let stats = viewModel.stats {
                    List {
                        // ... (Statystyki)
                        StatsRow(title: "Liczba przejazdów", value: "\(stats.totalRides)")
                        StatsRow(title: "Całkowity dystans", value: stats.totalDistance)
                            .foregroundColor(.green)
                        StatsRow(title: "Łączny czas trwania", value: stats.totalDuration)
                            .foregroundColor(.orange)
                        StatsRow(title: "Średnia prędkość (ogólna)", value: stats.overallAverageSpeed)
                            .foregroundColor(.blue)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Statystyki")
            
            // NOWA LOGIKA ZMIAN W iOS 17: Używamy nowego API onChange
            .onChange(of: records.count, initial: true) { // initial: true - WYWOŁUJE SIĘ PRZY PIERWSZYM ZAŁADOWANIU
                // Wywołujemy obliczenia, używając aktualnej tablicy records
                viewModel.calculateStatistics(from: records)
            }
        }
    }
}

// Uproszczony komponent wiersza statystyk
private struct StatsRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.headline)
        }
    }
}
