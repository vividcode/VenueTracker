//
//  Options.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/05/2020.
//  Copyright © 2020 IphoneGameZone. All rights reserved.
//

import Foundation
import CoreLocation

enum Currency: String
{
    case usd = "USD"
    case eur = "EUR"
}

enum DistanceUnit: String
{
    case km = "km"
    case mile = "mile"
}

struct URLOptions: URLParamProvider
{
    func urlParametersAsString<T>(fetcher: T) -> String
    {
        if (fetcher is VenueFetcher)
        {
            let pairs = [("lunit", self.distanceUnit.rawValue), ("currency", self.currency.rawValue), ("lang", self.locale.identifier), ("limit", String(self.limit)), ("distance", String(self.distance)),("latitude", String(self.locationProvider.getCurrentLocation().0)), ("longitude", String(self.locationProvider.getCurrentLocation().1))]
            
            let urlPairs = pairs.map { (p) -> String in
                p.0 + "=" + p.1
            }
            
            let urlParamString = urlPairs.joined(separator: "&")
            return urlParamString
        }
        //Add more cases based on fetcher types
        return ""
    }
    
    private var currency: Currency
    private var distanceUnit: DistanceUnit
    private var locale: Locale
    private var limit: Int
    private var distance: Int
    private var locationProvider: LocationProvider
    
    init(currency: Currency, distanceUnit:DistanceUnit, locale: Locale, limit: Int, distance: Int, locationProvider: LocationProvider)
    {
        self.currency = currency
        self.distanceUnit = distanceUnit
        self.locale = locale
        self.limit = limit
        self.distance = distance
        self.locationProvider = locationProvider
    }
    
    //default initializer
    init()
    {
        self.init(currency: .usd, distanceUnit: .km, locale: Locale.init(identifier: "en_US"), limit:30, distance: 5, locationProvider: FakeLocationProvider(centerCoordinate: CLLocationCoordinate2D(latitude: 24.9304, longitude: 60.1697)))
    }
}


