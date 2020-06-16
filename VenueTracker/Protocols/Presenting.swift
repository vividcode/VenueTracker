//
//  Presenting.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation

//Classes that implement Presenting deal with UI, i.e. views and view controllers.
protocol Presenting
{
    func updateUIWithDataItems(dataItems : [Any])
    func showErrorMessage(errorMessage: String)
}

