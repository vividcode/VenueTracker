//
//  UIImageViewExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView
{
    public func loadThumbNail(imageURL: NSURL, completion:@escaping (UIImage) -> Void)
    {
        if let image = imageURL.cachedImage {
            completion(image)
        }
        else
        {
            imageURL.fetchImage(completion:
                {
                    (image) in
                    DispatchQueue.main.async
                    {
                        imageURL.updateSharedCache(cacheKey: (imageURL.absoluteString!), image: image)
                        completion(image)
                    }
                })
        }
    }
}
