//
//  Updater.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreData

//Classes that implement Updater saves mutated data to data storage.
protocol Updater
{
    func updateData(updatedObjects: [Updating])
    func postDataToAPI(dataToPost: [Any])
}

//Custom overrides could include special business logic for NSManagedObjects involved
//Error logs inside catch could also use them.
//Here, they are already received in mutated state here, so context.save() should be enough
extension Updater
{
    func updateData(updatedObjects: [Updating])
    {
        for updatingObj in updatedObjects
        {
            updatingObj.toDataModel()
        }
    }
}
