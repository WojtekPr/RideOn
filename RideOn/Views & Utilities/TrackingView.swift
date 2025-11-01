//
//  TrackingView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// TrackingView.swift
import SwiftUI
import MapKit
import SwiftData

struct TrackingView: View {
    
    @Environment(\.modelContext) private var modelContext // Kontekst SwiftData
    
    @StateObject var viewModel = TrackingViewModel()
    @State private var showSummary = false
    @State private var finishedSession: TrackingSession?
    
    var body: some View {
        VStack(spacing: 40) {
            
            Text(viewModel.currentSession.isRunning ? "ŚLEDZENIE AKTYWNE..." : "GOTOWY DO STARTU")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(viewModel.currentSession.isRunning ? .green : .gray)
            
            Spacer()
            
            VStack(spacing: 15) {
                MetricView(title: "Czas Trwania", value: viewModel.liveFormattedDuration)
                    .foregroundColor(viewModel.currentSession.isRunning ? .orange : .gray)
                    .padding(.horizontal)
                
                VStack {
                    MetricView(title: "Dystans", value: viewModel.currentSession.distanceInKilometers)
                    MetricView(title: "Prędkość", value: viewModel.currentSession.speedInKmH)
                        .foregroundColor(viewModel.currentSession.isRunning ? .blue : .gray)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button {
                if viewModel.currentSession.isRunning {
                    finishedSession = viewModel.finishSession() // Zapis do SwiftData następuje tutaj
                    showSummary = true
                } else {
                    finishedSession = nil
                    viewModel.toggleTracking()
                }
            } label: {
                Text(viewModel.currentSession.isRunning ? "ZAKOŃCZ PRZEJAZD" : "START")
                    .font(.title2)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.currentSession.isRunning ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding()
        }
        .onAppear {
            viewModel.setModelContext(modelContext) // Przekazanie kontekstu do zapisu
        }
        .sheet(isPresented: $showSummary) {
            if let session = finishedSession {
                SummaryView(session: session)
            }
        }
    }
}
