//
//  URLExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation

import UIKit

class URLCache
{
    static let sharedCache: NSCache <NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.name = "MyImageCache"
        cache.countLimit = 30 // Max 30 images in memory.
        cache.totalCostLimit = 10*1024*1024 // Max 10MB used.
        return cache
    }()
    
    static let placeHolder : UIImage = UIImage.init(named: "Placeholder")!
}

extension NSURL
{
    public typealias ImageCacheCompletion = (UIImage) -> Void
    
    var cachedImage: UIImage? {
        
        if let image =  URLCache.sharedCache.object(forKey: absoluteString! as NSString)
        {
            return image
        }
        
        return self.loadImageFromDisk()
    }
    
    public func updateSharedCache(cacheKey: String, image: UIImage)
    {
        URLCache.sharedCache.setObject(image, forKey: cacheKey as NSString)
    }
    
   public func fetchImage(completion: @escaping ImageCacheCompletion)
    {
        let task = URLSession.shared.dataTask(with: self as URL)
        {
            data, response, error in
            if error == nil {
                if let  data = data,
                    let image = UIImage(data: data)
                {
                    self.saveImage(image: image)
                    DispatchQueue.main.async()
                    {
                        completion(image)
                    }
                }
                else
                {
                    let image = URLCache.placeHolder
                    completion(image)
                }
            }
            else
            {
                let image = URLCache.placeHolder
                completion(image)
            }
        }
        task.resume()
    }
    
    func saveImage (image : UIImage)
    {
        let fileManager = FileManager.default
        let folderPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = self.absoluteURL?.lastPathComponent
        
        let filePath = folderPath.appendingPathComponent(fileName!)
        fileManager.flushDocumentsDirectory(allowedFolderSize: 1024*1024*30)
        
        if let data = image.jpegData(compressionQuality: 1.0), !FileManager.default.fileExists(atPath: filePath.path)
        {
            do
            {
                try data.write(to: filePath)
            }
            catch
            {
                print("Error saving file to disk: \(error)")
            }
        }
    }
    
    func loadImageFromDisk() -> UIImage?
    {
        let folderPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let fileName = self.absoluteURL?.lastPathComponent
        
        let fileURL = folderPath.appendingPathComponent(fileName!)
       
        do
        {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)!
        }
        catch
        {
            return nil
        }
    }
}
