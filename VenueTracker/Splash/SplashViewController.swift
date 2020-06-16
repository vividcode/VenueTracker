//
//  SplashViewController.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController
{
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bannerLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.bannerLabel.alpha = 0.0
        for label in self.stackView.subviews
        {
            label.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.stackView.animateSubViewsSerially(tags: [10,20,30,40,50], tagIndex: 0, completion:
        {
            self.bannerLabel.alphaAnimation(bHide: false, completion: {
                
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                   let navigator = appDelegate.navigator
               else
               {
                   return
               }
                
                navigator.prepareVenueListVC()
            })
        })
    }

}
