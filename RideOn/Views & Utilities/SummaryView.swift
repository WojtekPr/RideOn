//
//  SummaryView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

/// SummaryView.swift
import SwiftUI
import MapKit

struct SummaryView: View {
    
    // Używamy @Environment, aby przycisk "Zamknij" działał
    @Environment(\.dismiss) var dismiss
    
    let session: TrackingSession
    @State private var mapRegion: MKCoordinateRegion
    
    // STAN KONTROLUJĄCY: Otwiera FullscreenMapView
    @State private var isShowingFullscreenMap = false
    
    init(session: TrackingSession) {
        self.session = session
        
        let coords = session.allCoordinates
        
        if coords.count > 1 {
            let polyline = MKPolyline(coordinates: coords, count: coords.count)
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
                
                // 1. MAPA Z WIDOKIEM PODSUMOWANIA I PRZYCISKIEM FULLSCREEN
                Map(coordinateRegion: $mapRegion)
                    .overlay(
                        // Używamy RouteOverlay, który rysuje linię, ale ma wyłączone interakcje
                        RouteOverlay(coordinates: session.allCoordinates)
                    )
                // Nakładka z przyciskiem powiększenia
                    .overlay(alignment: .topTrailing) {
                        Button {
                            isShowingFullscreenMap = true // Aktywuje pełny ekran
                        } label: {
                            Image(systemName: "arrow.up.left.and.arrow.down.right")
                                .padding(8)
                                .background(.thinMaterial)
                                .clipShape(Circle())
                        }
                        .padding(10)
                    }
                    .frame(height: 350)
                
                // 2. Wyniki i Statystyki
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
                        dismiss() // Używamy dismiss, aby zamknąć modal
                    }
                }
            }
            // 3. WIDOK MODALNY PEŁNOEKRANOWEJ MAPY
            .fullScreenCover(isPresented: $isShowingFullscreenMap) {
                FullscreenMapView(session: session)
            }
        }
    }
}
