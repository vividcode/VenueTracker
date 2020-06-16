//
//  LocationProvider.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreLocation

//Classes implementing LocationProvider must provide live location data
protocol LocationProvider
{
    func getCurrentLocation()->(CLLocationDegrees, CLLocationDegrees)
}
