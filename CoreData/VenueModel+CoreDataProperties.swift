//
//  VenueModel+CoreDataProperties.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//
//

import Foundation
import CoreData

extension VenueModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<VenueModel> {
        return NSFetchRequest<VenueModel>(entityName: "VenueModel")
    }

    @NSManaged public var venueId: String?
    @NSManaged public var venueName: String?
    @NSManaged public var venueDescription: String?
    @NSManaged public var listImageURLStr: String?
    @NSManaged public var isFavorite: Bool
}
