//
//  UIViewExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 28/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

//MARK: IB properties
extension UIView
{
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!)
            return color
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}

enum AnimDirection: Int
{
    case fromRight = 1
    case fromBottom = 2
    case fromTop = 3
    case fromLeft = 4
}

//MARK: Basics

extension UIView
{
    func applyShadow()
    {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowRadius = 1.0
        self.layer.shadowOffset = CGSize(width: 0.0, height: -1.5)
        self.layer.shadowOpacity = 0.8
        self.layer.masksToBounds = false
    }
}

//MARK: Animations
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
    
    func animatePulseSerially(tags: [Int], tagIndex: Int, completion:(()->())?)
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
            self.animatePulseSerially(tags:tags, tagIndex: tagIndex + 1, completion: completion)
        }
    }
    
    class func animateSlideSerially(views: [UIView], containerBounds: CGRect, direction:AnimDirection)
    {
        var delayCounter = 0
        let (initial,final) : (CGAffineTransform, CGAffineTransform) = {
            switch(direction)
            {
                case .fromRight:
                    return (CGAffineTransform(translationX:containerBounds.size.width, y:0),  CGAffineTransform.identity)
                case .fromTop:
                    return (CGAffineTransform(translationX:0, y:-containerBounds.size.height),  CGAffineTransform.identity)
                case .fromBottom:
                    return (CGAffineTransform(translationX:0, y:containerBounds.size.height),  CGAffineTransform.identity)
                case .fromLeft:
                    return (CGAffineTransform.identity, CGAffineTransform(translationX:-containerBounds.size.width, y:0))
            }
        }()
        
        for v in views {
            v.transform = initial
        }
        
        for v in views
        {
            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter),usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseInOut, animations:
            {
                v.transform = final
            }, completion: nil)
            
            delayCounter += 1
        }
    }
}
