//
//  VenuePresenter.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

class VenuePresenter: Presenter
{
    var errorMessage: String?
    {
        didSet(newVal)
        {
            guard let newValue = newVal
            else
            {
                return
            }
            
            DispatchQueue.main.async
            {
                for presentingVC in self.presentingVCs
                {
                    presentingVC.showErrorMessage(errorMessage: newValue)
                }
            }
        }
    }
    
    var presentingVCs: [Presenting]
    
    var dataItems: [Any]
    {
        didSet(newVal)
        {
            DispatchQueue.main.async
            {
                for presentingVC in self.presentingVCs
                {
                    presentingVC.updateUIWithDataItems(dataItems: self.dataItems)
                }
            }
        }
    }
    
    init(presentingVCs: [Presenting], dataItems: [VenueModel])
    {
        self.presentingVCs = presentingVCs
        self.dataItems = dataItems
    }
}
