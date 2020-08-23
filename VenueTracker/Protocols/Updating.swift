//
//  Updating.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 28/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import CoreData

protocol Model {

}

protocol Updating
{
    static func getAll()->[Model]
    static func fromDataModel(_ model: NSManagedObject)->Self
    func toDataModel()
}
