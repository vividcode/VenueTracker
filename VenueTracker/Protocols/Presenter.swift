//
//  Presenter.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

//Classes that implement Presenter hold data items for their Presenting View Controllers.
protocol Presenter
{
    var presentingVCs: [Presenting] {  get  }

    var dataItems : [Any] {  get set  }
    
    var errorMessage: String? { get set }
}

