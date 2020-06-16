//
//  FakeLocationProvider.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreLocation

struct FakeLocationProvider: LocationProvider
{
    private var centerCoordinate: CLLocationCoordinate2D
    
    init(centerCoordinate: CLLocationCoordinate2D)
    {
        self.centerCoordinate = centerCoordinate
    }
    
    func getCurrentLocation() -> (CLLocationDegrees, CLLocationDegrees)
    {
        //let (lat, lon) = self.fixedLocation()
        let (lat, lon) = self.createRandomLocation()
        return (lat, lon)
    }
    
    func fixedLocation()->(CLLocationDegrees, CLLocationDegrees)
    {
        //Coordinates of Kamppi, Helsinki
        let lat = self.centerCoordinate.latitude // 
        let lon = self.centerCoordinate.longitude// 
                
        return (lat, lon)
    }
    
    func createRandomLocation()->(CLLocationDegrees, CLLocationDegrees)
    {
        //Coordinates of Kamppi, Helsinki
        let centerLat = 60.1697
        let centerLon = 24.9304
        
        let lat = Double.random(in: centerLat...(centerLat+0.02))
        let lon = Double.random(in: centerLon...(centerLon+0.02))
        
        return (lat, lon)
    }
}
