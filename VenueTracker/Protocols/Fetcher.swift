//
//  Fetcher.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation

//This protocol should be confirmed by every class that downloads data from REST
protocol Fetcher
{
    var timeInterval: TimeInterval { get set }

    var fetchURL: String { get }
    
    var presenter: Presenter? { get set }
    
    func cancelFetching()
    
    func fetch()
    
    var shouldNavigateBlock: (()->Void)? { get set }
}
