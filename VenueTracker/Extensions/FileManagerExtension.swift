//
//  FileManagerExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 29/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation

extension FileManager
{
    func sizeOfFile(_ folderPath: String) -> Int64
    {
        do
        {
            let contents = try FileManager.default.contentsOfDirectory(atPath: folderPath)
            var folderSize: Int64 = 0
            for content in contents
            {
                 do
                 {
                     let fullContentPath = folderPath + "/" + content
                     let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullContentPath)
                     folderSize += fileAttributes[FileAttributeKey.size] as? Int64 ?? 0
                 }
                 catch _
                 {
                     continue
                 }
             }
            
            return folderSize
        }
        catch
        {
            print(error)
            return -1
        }
    }
    
    func flushDocumentsDirectory(allowedFolderSize: Int64)
    {
        do
        {
            let documentDirectoryURL = try self.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            
            let folderSize = self.sizeOfFile(documentDirectoryURL.path)

            //Clear folder when images get above 30 MB
            if (folderSize > allowedFolderSize)
            {
                let fileSizeStr = ByteCountFormatter.string(fromByteCount: folderSize, countStyle: ByteCountFormatter.CountStyle.file)
                print("Flushing Document folder, Size: \(fileSizeStr)")
                let fileURLs = try self.contentsOfDirectory(at: documentDirectoryURL, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles, .skipsSubdirectoryDescendants])
                for url in fileURLs
                {
                   try self.removeItem(at: url)
                }
            }
        }
        catch
        {
            print(error)
        }
    }
}
