//
//  SummaryView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// SummaryView.swift
import SwiftUI
import MapKit

struct SummaryView: View {
    
    let session: TrackingSession
    @State private var mapRegion: MKCoordinateRegion
    
    init(session: TrackingSession) {
        self.session = session
        
        if session.allCoordinates.count > 1 {
            let polyline = MKPolyline(coordinates: session.allCoordinates, count: session.allCoordinates.count)
            let rect = polyline.boundingMapRect
            _mapRegion = State(initialValue: MKCoordinateRegion(rect))
        } else {
            _mapRegion = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                // Mapa podsumowująca
                Map(coordinateRegion: $mapRegion, interactionModes: [.pan, .zoom])                    .overlay(
                        // Używamy RouteOverlay do rysowania trasy
                        RouteOverlay(coordinates: session.allCoordinates)
                    )
                    .frame(height: 350)
                
                // Wyniki
                VStack(spacing: 15) {
                    Text("Zakończono Przejazd 🎉")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    MetricView(title: "Czas Trwania", value: session.formattedDuration())
                        .padding(.horizontal)
                    
                    HStack {
                        MetricView(title: "Całkowity Dystans", value: session.distanceInKilometers)
                        
                        MetricView(title: "Max Prędkość", value: session.maxSpeedInKmH)
                            .foregroundColor(.red)
                    }
                    .padding(.horizontal)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .navigationTitle("Podsumowanie")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Zamknij") {
                        // Automatycznie zamyka widok .sheet
                    }
                }
            }
        }
    }
}
