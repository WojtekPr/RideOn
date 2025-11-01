//
//  Coordinate.swift
//  RideOn
//
//  Created by Wojciech Prabucki on 01/11/2025.
//

import Foundation
import SwiftData
import CoreLocation

@Model
final class Coordinate {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var toCLLocationCoordinate2D: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
