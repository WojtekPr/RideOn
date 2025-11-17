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
    
    // 1. Wstrzykujemy obiekt AuthViewModel, który kontroluje stan logowania
    @EnvironmentObject var authViewModel: AuthViewModel
    
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
            
            // 2. Dodajemy przycisk Wyloguj w pasku nawigacji
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        authViewModel.signOut() // Wywołanie metody wylogowania
                    } label: {
                        Text("Wyloguj")
                        Image(systemName: "person.crop.circle.badge.xmark")
                    }
                    .tint(.red)
                }
            }
            
            // NOWA LOGIKA ZMIAN w iOS 17
            .onChange(of: records.count, initial: true) {
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
