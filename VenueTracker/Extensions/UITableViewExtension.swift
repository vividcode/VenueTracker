//
//  UITableViewExtension.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 27/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import Foundation
import UIKit

extension UITableView
{
    func isIndexPathValid(indexPath: IndexPath) -> Bool
    {
        if indexPath.section < self.numberOfSections
        {
            if indexPath.row < self.numberOfRows(inSection: indexPath.section)
            {
                return true
            }
        }

        return false
    }
    
    func pairShuffleAnimation()
    {
        self.reloadData()

        for section in (0...self.numberOfSections-1)
        {
            let rowCount = self.numberOfRows(inSection: section)
            
            self.beginUpdates()
            
            var blurredCells: [UITableViewCell] = []
            
            UIView.animate(withDuration: 0.8, animations:
            {
                for rowIdx in stride(from: 0, to: rowCount - 1, by: 2)
                {
                    let oldIndexPath1 = IndexPath(row: rowIdx, section: section)
                    let oldIndexPath2 = IndexPath(row: rowIdx+1, section: section)
                    let newIndexPath1 = IndexPath(row: rowIdx+1, section: section)
                    let newIndexPath2 = IndexPath(row: rowIdx, section: section)
                    
                    if (self.isIndexPathValid(indexPath: newIndexPath1) && self.isIndexPathValid(indexPath: newIndexPath2))
                    {
                        self.moveRow(at: oldIndexPath1, to: newIndexPath1)
                        self.moveRow(at: oldIndexPath2, to: newIndexPath2)
                    }
                    else
                    {
                        let cell1 = self.cellForRow(at: oldIndexPath1)
                        let cell2 = self.cellForRow(at: oldIndexPath1)
                        
                        cell1!.alpha = 0.5
                        cell2!.alpha = 0.5
                        
                        blurredCells.append(cell1!)
                        blurredCells.append(cell2!)
                    }
                }
            })
            { (_) in
                self.endUpdates()
                
                for cell in blurredCells
                {
                    cell.alpha = 1.0
                }
            }
        }
    }
}
