//
//  Venue+CoreDataClass.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Venue)
public class VenueModel: NSManagedObject
{
    class func createOrUpdateVenueModel(venue: Venue)
    {
        let coreData = CoreDataManager.sharedInstance
        let context = coreData.queryContext
        if let venueModel = VenueModel.getVenueModelForVenue(venue: venue)
        {
            self.updateVenueModel(venue: venue, venueModel: venueModel, context: context)
            return
        }
        
        self.createVenueModel(venue: venue)
    }
    
    class func createVenueModel(venue: Venue)
    {
        let coreData = CoreDataManager.sharedInstance
        let context = coreData.mutationContext
        
        let venueModel = NSEntityDescription.insertNewObject(forEntityName: "VenueModel", into: context) as! VenueModel
        venueModel.venueId = venue.venueId
        venueModel.venueName = venue.venueName
        
       
        venueModel.venueDescription = venue.venueDescription
        venueModel.listImageURLStr = venue.listImageURLStr
        venueModel.isFavorite = venue.isFavorite
        
        do
        {
            try context.save()
        }
        catch let err
        {
            print("Could not save Venue: \(venue.venueName) - \(err)")
        }
    }
    
    class func getVenueModelForVenue(venue: Venue)->VenueModel?
    {
        let fetchRequest = NSFetchRequest<VenueModel>(entityName: "VenueModel")
        let context = CoreDataManager.sharedInstance.queryContext
        
        do
        {
            fetchRequest.predicate = NSPredicate(format: "venueId == %@", venue.venueId)
            let result = try context.fetch(fetchRequest) 
            let venueModel = result.first
            return venueModel
        }
        catch let err
        {
            print("Could not get Venue for Id: \(venue.venueId) \(err)")
            return nil
        }
    }
    
    class func updateVenueModel(venue: Venue, venueModel: VenueModel, context: NSManagedObjectContext = CoreDataManager.sharedInstance.mutationContext)
    {
        do
        {
            venueModel.venueId = venue.venueId
            venueModel.venueName = venue.venueName
            venueModel.venueDescription = venue.venueDescription
            venueModel.listImageURLStr = venue.listImageURLStr
            venueModel.isFavorite = venue.isFavorite
            
            try context.save()
            
        }
        catch let customErr as CoreDataCustomError
        {
            print("Venue Object does not exist in DB: \(customErr)")
        }
        catch let err
        {
            print("Error saving Venue:\(venue.venueId) : \(err)")
        }
    }
    
    class func getVenues(limit: Int)->[VenueModel]
    {
        let fetchRequest = NSFetchRequest<VenueModel>(entityName: "VenueModel")
        let context = CoreDataManager.sharedInstance.queryContext
        
        do
        {
            fetchRequest.fetchLimit = limit
            let result = try context.fetch(fetchRequest)

            return result
        }
        catch let err
        {
            print("Could not get Venues: \(err)")
            return []
        }
    }
}


