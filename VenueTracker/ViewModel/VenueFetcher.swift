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
            
            let venueModels = throttledVenueArray.compactMap { (venueJson) -> VenueModel? in
                let venueModel = VenueModel.getOrCreateVenueForVenueJson(venueJson: venueJson)
                return (venueModel ?? nil)
            }
            
            let venueList = venueModels.compactMap { (venueModel) -> Venue? in
                let venue = Venue.venueFromModel(venueModel: venueModel)
                return (venue ?? nil)
            }
            
            if var presenter = self.presenter
            {
                self.shouldNavigateBlock?()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                {
                    presenter.dataItems = venueList
                }
                
            }
        },
        errorBlock:
        {
            (error) in
            print("API failed to return venues.")
            
            //Show pre-existing venues in DB if there is no preloaded results in the UI already
            let venueList = VenueModel.getVenues(limit: ResultLimit.VenueList)
            
            if var presenter = self.presenter
            {
                self.shouldNavigateBlock?()
                if (venueList.count > 0)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2)
                    {
                        presenter.dataItems = venueList
                    }
                }
                presenter.errorMessage = "Could not refresh Venues.\nPlease check your internet connection."
            }
              
        })
    }
    
    func cancelFetching()
    {
        if let timer = self.timer
        {
            timer.invalidate()
        }
    }
}
