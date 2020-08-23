//
//  UIViewControllerExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController
{
    class func viewControllerWithIdentifier(identifier: String)->UIViewController?
    {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: Bundle.main)
        let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
        return vc
    }
    
    func showLabel(msg: String, callBack: @escaping ()->()? = {})
    {
        self.removeLabel()
        
        let label : UILabel = UILabel(frame: CGRect.init(x: 10, y: self.view.bounds.size.height*0.45, width: self.view.bounds.size.width - 20, height: 50))
        
        label.backgroundColor = UIColor.darkGray
        label.textColor = UIColor.white
        label.text = msg
        label.numberOfLines = 2
        label.textAlignment = .center
        label.layer.cornerRadius = 8.0
        label.layer.masksToBounds = true
        label.tag = 100
        self.view.addSubview(label)
        self.view.bringSubviewToFront(label)
    }
    
    func removeLabel()
    {
        if let label = self.view.viewWithTag(100)
        {
            label.removeFromSuperview()
        }
    }
}
