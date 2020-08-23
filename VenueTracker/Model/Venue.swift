//
//  Venue.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 28/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreData

struct Venue:Updating, Equatable, Model
{
    public var venueId: String
    public var venueName: String
    public var venueDescription: String
    public var listImageURLStr: String
    public var isFavorite: Bool
    
    public init(venueJson: [String:Any])
    {
        guard let venueId = venueJson["location_id"] as? String
            else
        {
            fatalError()
        }
        
        let venueName = (venueJson["name"] as? String) ?? "No Venue Name"
        let venueDesc = (venueJson["ranking_subcategory"] as? String) ?? "No Venue Description"
        
        var venueURLStr = ""
        if let photoJson = venueJson ["photo"] as? [String:Any],
            let imageJson = photoJson["images"] as? [String:Any],
            let listImage = imageJson["small"] as? [String:Any],
            let listImageStr = listImage["url"] as? String
        {
            venueURLStr = listImageStr
        }
        
        let isFavorite = (venueJson["isFavorite"] as? Bool) ?? false
        
        self.init(venueId: venueId, venueName: venueName, venueDescription: venueDesc, listImageURLStr: venueURLStr, isFavorite: isFavorite)
    }
    
    private init(venueId: String, venueName: String, venueDescription:String, listImageURLStr: String, isFavorite:Bool) {
        self.venueId = venueId
        self.venueName = venueName
        self.venueDescription = venueDescription
        self.listImageURLStr = listImageURLStr
        self.isFavorite = isFavorite
    }
    
    func toDataModel()
    {
        VenueModel.createOrUpdateVenueModel(venue: self)
    }
    
    static func fromDataModel(_ model: NSManagedObject) -> Venue
    {
        let venueModel = model as! VenueModel
        let venue = Venue(venueId: venueModel.venueId!, venueName: venueModel.venueName!, venueDescription: venueModel.venueDescription!, listImageURLStr: venueModel.listImageURLStr!, isFavorite: venueModel.isFavorite)
        
        return venue
    }
    
    static func getAll()->[Model]
    {
        let venueModels = VenueModel.getVenues(limit: ResultLimit.VenueList)
        let venues = venueModels.map { (vModel) -> Venue in
            return Venue.fromDataModel(vModel)
        }
        
        return venues
    }
}
