//
//  Navigator.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 30/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit
import Speech

//This class will have helpers to create view controllers from storyboard on the fly, and handle navigation
//App delegate will have reference to this so it can be accessed by any view controller
//This could be extended to keep track of every nav controller in the app for easy push-pop-present operation
open class Navigator
{
    private var fetchers: [Fetcher] = []
    private var presenter: [Presenter] = []
    
    func prepareVenueListVC()
    {
        guard let splashListVC = UIViewController.viewControllerWithIdentifier(identifier: "SplashVC") as? SplashViewController
        else
        {
            return
        }
        
        guard let venueListNav = UIViewController.viewControllerWithIdentifier(identifier: "VenueListNav") as? UINavigationController
        else
        {
            return
        }
        
        let venueListVC = venueListNav.viewControllers.first as! VenueListViewController
        
        let venuePresenter = VenuePresenter(presentingVCs: [venueListVC], dataItems: [])
        let venueFetcher = VenueFetcher(timeInterval: RestFetchInterval.VenueList, presenter: venuePresenter, urlOptions: URLOptions(), shouldNavigateBlock:
        {
            DispatchQueue.main.async {
                self.replaceKeyWindow(withNav: venueListNav, fromVC: splashListVC)
            }
        })
        
        self.fetchers.append(venueFetcher)
        self.presenter.append(venuePresenter)
        
        venueListVC.venueFetcher = venueFetcher
        venueFetcher.fetch()
    }
    
    private func replaceKeyWindow(withNav: UINavigationController, fromVC: UIViewController)
    {
        let keyWindow = UIApplication.shared.windows.first
        keyWindow?.rootViewController = withNav
        
        let options: UIView.AnimationOptions = [.transitionCrossDissolve, .showHideTransitionViews]
        
        UIView.transition(with: keyWindow!, duration: 1.5, options: options, animations: {}, completion: nil)
    }
}
