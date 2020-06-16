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
    class func createVenueModel(venueJson: [String:Any])->VenueModel?
    {
        let coreData = CoreDataManager.sharedInstance
        let context = coreData.mutationContext
        
        guard let venueId = venueJson["location_id"] as? String
        else
        {
            return nil
        }
        
        guard let venueName = venueJson["name"] as? String
        else
        {
            return nil
        }
        
        let venueModel = NSEntityDescription.insertNewObject(forEntityName: "VenueModel", into: context) as! VenueModel
        venueModel.venueId = venueId
        venueModel.venueName = venueName
        
        if let shortDescription =  venueJson["ranking_subcategory"] as? String
        {
            venueModel.venueDescription = shortDescription
        }
        else
        {
            venueModel.venueDescription = ""
        }
        
        if let photoJson = venueJson ["photo"] as? [String:Any],
            let imageJson = photoJson["images"] as? [String:Any],
            let listImage = imageJson["small"] as? [String:Any],
            let listImageStr = listImage["url"] as? String
        {
            venueModel.listImageURLStr = listImageStr
        }
        else
        {
            venueModel.listImageURLStr = ""
        }
        
        venueModel.isFavorite = false
        
        do
        {
            try context.save()
            return venueModel
        }
        catch let err
        {
            print("Could not save Venue: \(venueName) - \(err)")
            return nil
        }
    }
    
    class func getVenueForVenueJson(venueJson: [String:Any])->VenueModel?
    {
        guard let venueId = venueJson["location_id"] as? String
        else
        {
            return nil
        }
        
        let fetchRequest = NSFetchRequest<VenueModel>(entityName: "VenueModel")
        let context = CoreDataManager.sharedInstance.queryContext
        
        do
        {
            fetchRequest.predicate = NSPredicate(format: "venueId == %@", venueId)
            let result = try context.fetch(fetchRequest) 
            let venueModel = result.first
            return venueModel
        }
        catch let err
        {
            print("Could not get Venue for Id: \(venueId) \(err)")
            return nil
        }
    }
    
    class func updateVenueModel(venue: Venue)
    {
        let fetchRequest = NSFetchRequest<VenueModel>(entityName: "VenueModel")
        let context = CoreDataManager.sharedInstance.queryContext
        
        do
        {
            fetchRequest.predicate = NSPredicate(format: "venueId == %@", venue.venueId)
            let result = try context.fetch(fetchRequest)
            guard let venueModel = result.first
            else
            {
                throw CoreDataCustomError.ObjectNotFound
            }
            
            venueModel.venueId = venue.venueId
            venueModel.venueName = venue.venueName
            venueModel.venueDescription = venue.venueDescription
            venueModel.listImageURLStr = venue.listImageURLStr
            venueModel.isFavorite = venue.isFavorite
            
            try CoreDataManager.sharedInstance.mutationContext.save()
            
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
    
    class func getOrCreateVenueForVenueJson(venueJson: [String:Any])->VenueModel?
    {
        if let venueModel = VenueModel.getVenueForVenueJson(venueJson: venueJson)
        {
            return venueModel
        }
        
        if let venueModel = VenueModel.createVenueModel(venueJson: venueJson)
        {
            return venueModel
        }
        
        return nil
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


