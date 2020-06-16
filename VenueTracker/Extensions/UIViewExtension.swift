//
//  UIViewExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 28/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
    func pulse()
    {
        let finalTransform = CGAffineTransform.init(scaleX: 1.25, y: 1.25)
        let initialTransform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.5, options: [], animations:
        {
            self.transform = finalTransform
            
        }, completion: {
        bFinished in
            self.transform = initialTransform
        })
    }
    
    func alphaAnimation(bHide: Bool, completion:(()->())?)
    {
        self.alpha = bHide ? 1.0 : 0.0
        
        UIView.animate(withDuration: 1.2, delay: 0, options: [], animations:
        {
            self.alpha = bHide ? 0.0 : 1.0
        }, completion:
        {
            (_) in
            completion?()
        }
        )
    }
    
    func animateSubViewsSerially(tags: [Int], tagIndex: Int, completion:(()->())?)
    {
        if (tagIndex < 0 || tagIndex >= tags.count)
        {
            completion?()
            return
        }
        
        let tag = tags[tagIndex]
        let subView = self.viewWithTag(tag)

        let zeroT = CGAffineTransform.identity.scaledBy(x: 0.01, y: 0.01)
        subView?.transform = zeroT
        
        let hugeT = CGAffineTransform.identity.scaledBy(x: 1.25, y: 1.25)
        let origT = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.8, delay: 0, options: [], animations:
        {
            subView?.transform = hugeT
        })
        { (_) in
            subView?.transform = origT
            self.animateSubViewsSerially(tags:tags, tagIndex: tagIndex + 1, completion: completion)
        }
    }
}
