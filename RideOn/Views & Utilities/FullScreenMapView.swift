//
//  FullScreenMapView.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 09/11/2025.
//

// FullscreenMapView.swift
import SwiftUI
import MapKit

struct FullscreenMapView: View {
    
    @Environment(\.dismiss) var dismiss
    let session: TrackingSession
    
    // Musimy ponownie obliczyć region, aby View był samodzielny
    @State private var mapRegion: MKCoordinateRegion
    
    init(session: TrackingSession) {
        self.session = session
        
        let coords = session.allCoordinates
        
        if coords.count > 1 {
            let polyline = MKPolyline(coordinates: coords, count: coords.count)
            let rect = polyline.boundingMapRect
            
            // Dodajemy duży bufor, aby użytkownik mógł oddalać!
            let paddingRatio = 1.2
            var paddedRect = rect
            paddedRect.size.width *= paddingRatio
            paddedRect.size.height *= paddingRatio
            paddedRect.origin.x -= (paddedRect.size.width - rect.size.width) / 2
            paddedRect.origin.y -= (paddedRect.size.height - rect.size.height) / 2
            
            _mapRegion = State(initialValue: MKCoordinateRegion(paddedRect))
        } else {
            _mapRegion = State(initialValue: MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 52.2297, longitude: 21.0122),
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            ))
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            
            // MAPA Z PEŁNĄ INTERAKCJĄ I POKRYCIEM CAŁEGO EKRANU
            Map(coordinateRegion: $mapRegion, interactionModes: [.all])
                .overlay(
                    // Używamy RouteOverlay (dla rysowania linii)
                    RouteOverlay(coordinates: session.allCoordinates)
                )
                .ignoresSafeArea() // Wypełnia bezpieczne obszary
            
            // PRZYCISK ZAMKNIJ (w lewym górnym rogu)
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.secondary)
                    .padding(4)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .padding(.top, 40) // Odsunięcie od krawędzi (safe area)
            .padding(.leading, 10)
        }
    }
}
