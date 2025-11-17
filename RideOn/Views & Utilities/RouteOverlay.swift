//
//  RouteOverlay.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

// RouteOverlay.swift
import SwiftUI
import MapKit

struct RouteOverlay: UIViewRepresentable {
    
    let coordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        
        // KLUCZOWE: Usuwamy blokady interakcji, aby widok pełnoekranowy działał,
        // a skalowanie było stabilne.
        mapView.isScrollEnabled = true
        mapView.isZoomEnabled = true
        mapView.isUserInteractionEnabled = true
        mapView.showsUserLocation = false
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        
        guard coordinates.count > 1 else { return }
        
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        uiView.addOverlay(polyline, level: .aboveRoads)
        
        // Logika centrowania widoku
        if context.coordinator.firstUpdate {
            let polylineBoundingBox = polyline.boundingMapRect
            
            // Dodajemy marginesy wokół trasy
            let edgeInsets = UIEdgeInsets(top: max(50, polylineBoundingBox.size.height * 0.1),
                                          left: max(50, polylineBoundingBox.size.width * 0.1),
                                          bottom: max(50, polylineBoundingBox.size.height * 0.1),
                                          right: max(50, polylineBoundingBox.size.width * 0.1))
            
            uiView.setVisibleMapRect(polylineBoundingBox, edgePadding: edgeInsets, animated: false)
            context.coordinator.firstUpdate = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RouteOverlay
        var firstUpdate = true
        
        init(_ parent: RouteOverlay) {
            self.parent = parent
        }
        
        // RENDERER: FUNKCJA KONTROLUJĄCA WYGLĄD LINII
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = UIColor.systemBlue
                renderer.lineWidth = 5.0
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
