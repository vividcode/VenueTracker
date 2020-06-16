//
//  Venue.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 28/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreData

struct Venue:Updating, Equatable
{
    public var venueId: String
    public var venueName: String
    public var venueDescription: String
    public var listImageURLStr: String
    public var isFavorite: Bool
    
    init(venueId: String, venueName: String, venueDescription:String, listImageURLStr: String, isFavorite:Bool) {
        self.venueId = venueId
        self.venueName = venueName
        self.venueDescription = venueDescription
        self.listImageURLStr = listImageURLStr
        self.isFavorite = isFavorite
    }
    
    func updateDataModel()
    {
        VenueModel.updateVenueModel(venue: self)
    }
    
    static func venueFromModel(venueModel: VenueModel)->Venue?
    {
        let venue = Venue(venueId: venueModel.venueId!, venueName: venueModel.venueName!, venueDescription: venueModel.venueDescription!, listImageURLStr: venueModel.listImageURLStr!, isFavorite: venueModel.isFavorite)

        return venue
    }
}
