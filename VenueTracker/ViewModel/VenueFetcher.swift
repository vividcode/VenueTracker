//
//  VenueFetcher.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation

class VenueFetcher: Fetcher
{
    var shouldNavigateBlock: (()->Void)?
    var timeInterval: TimeInterval
    var urlOptions: URLOptions
    
    var fetchURL: String
    {
        get
        {
            let paramString = self.urlOptions.urlParametersAsString(fetcher: self)
            return "attractions/list-by-latlng?" + paramString
        }
    }
    
    private var timer: Timer?
    var presenter: Presenter?
    
    init(timeInterval: TimeInterval, presenter: Presenter?, urlOptions: URLOptions, shouldNavigateBlock: (()->Void)?)
    {
        self.timeInterval = timeInterval
        self.presenter = presenter
        self.urlOptions = urlOptions
        self.shouldNavigateBlock = shouldNavigateBlock
    }
    
    func fetch()
    {
        self.timer = Timer.scheduledTimer(withTimeInterval: self.timeInterval, repeats: true, block:
        {
            [weak self]
            (timer) in
            self?.fetchInternal()
        })
        
        self.timer?.fire()
    }
    
    func fetchInternal()
    {
        let urlStr = self.fetchURL
        
        NetworkManager.sharedInstance.fetchFromRest(urlStr: urlStr, timeOut: self.timeInterval, dataDownloadedBlock:
        {
            (venueArray) in
            
            let fetchCount = min(ResultLimit.VenueList, venueArray.count)
            
            print("fetchCount: \(fetchCount)")
            
            let throttledVenueArray = (venueArray as! [[String:Any]]).prefix(fetchCount)
            
            do
            {
                let venues = throttledVenueArray.compactMap { (venueJson) -> Venue? in
                    let venue = Venue(venueJson: venueJson)
                    return (venue)
               }
                
                venues.forEach { (v) in
                    v.toDataModel()
                }
               
                self.updatePresenter(venueList: venues, shouldShowError: false)
            }
        },
        noDataBlock: {
            let venues = Venue.getAll() as! [Venue]
            
            //Show pre-existing venues in DB if there is no preloaded results in the UI already
            self.updatePresenter(venueList: venues, shouldShowError: true)
        },
        errorBlock:
        {
            (error) in
            print("API failed to return venues.")
            let venues = Venue.getAll() as! [Venue]
            //Show pre-existing venues in DB if there is no preloaded results in the UI already
            self.updatePresenter(venueList: venues, shouldShowError: true)
        })
    }
    
    func updatePresenter(venueList: [Venue], shouldShowError: Bool)
    {
        if var presenter = self.presenter
        {
            self.shouldNavigateBlock?()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
            {
                presenter.dataItems = venueList
                if (shouldShowError)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0)
                    {
                        presenter.errorMessage = "Could not refresh Venues.\nPlease check your internet connection."
                    }
                }
            }
        }
    }
    
    func cancelFetching()
    {
        if let timer = self.timer
        {
            timer.invalidate()
        }
    }
}
