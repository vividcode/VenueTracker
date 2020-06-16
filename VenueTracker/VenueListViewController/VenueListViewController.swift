//
//  ViewController.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import UIKit
import CoreData

class VenueListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    static let venueListCell = "VenueListCell"
    
    @IBOutlet weak var tableView: UITableView!
    var venueList: [Venue] = []
    var venueFetcher: VenueFetcher?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.navigationItem.title = "Attractions Around You"
        
        self.configureTableView()
    }
    
    func configureTableView()
    {
        //workaround to access the last cell
        self.tableView.contentInset  = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
        self.tableView.register(UINib.init(nibName: "VenueListCell", bundle: .main), forCellReuseIdentifier: VenueListViewController.venueListCell)
        if (self.venueList.count == 0)
        {
            self.showLabel(msg: "🍽️ Scanning Attractions Nearby 🍽️")
            self.tableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.venueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: VenueListViewController.venueListCell) as! VenueListCell
        
        var venue = self.venueList[indexPath.row]
        cell.venueNameLabel.text = venue.venueName
        cell.venueDescriptionLabel.text = venue.venueDescription
        cell.thumbnailURL = NSURL(string: venue.listImageURLStr)
        
        cell.favoriteButtonAction = {
            [unowned self] in
            cell.venueFavoriteButton.pulse()
            venue.isFavorite = !venue.isFavorite
            self.venueList[indexPath.row] = venue
            let favoriteImageName = venue.isFavorite ? "favorite":"unfavorite"
            cell.venueFavoriteButton.setImage(UIImage.init(named: favoriteImageName), for: .normal)
            self.updateData(updatedObjects: [venue])
        }
        
        let favoriteImageName = venue.isFavorite ? "favorite":"unfavorite"
        cell.venueFavoriteButton.setImage(UIImage.init(named: favoriteImageName), for: .normal)
        
        cell.venueThumbnail.loadThumbNail(imageURL: NSURL(string: venue.listImageURLStr)!) { (img) in
            cell.venueThumbnail.alpha = 0
            
            if cell.thumbnailURL!.absoluteString == venue.listImageURLStr
            {
                cell.venueThumbnail.image = img
            }
            UIView.animate(withDuration: 0.5)
            {
                cell.venueThumbnail.alpha = 1
            }
        }
        
        return cell
    }
    
    func shuffleTableView(newVenueList: [Venue])
    {
        //Do this initially
        if (self.venueList.count == 0)
        {
            self.venueList = newVenueList
            
            self.tableView.reloadData()
            
            let originalTransform = CGAffineTransform.identity
            let smallTransform = originalTransform.scaledBy(x: 0.05, y: 0.05)
            
            self.tableView.transform = smallTransform
            UIView.animate(withDuration: 0.8, animations:
            {
                if (self.tableView.isHidden)
                {
                    self.tableView.isHidden = false
                }
                self.tableView.transform = originalTransform
            })
            { (_) in
                
            }
        }
        else
        {
            self.venueList = newVenueList
            self.tableView.pairShuffleAnimation()
        }
    }
}

extension VenueListViewController : Presenting
{
    func showErrorMessage(errorMessage: String)
    {
        self.showLabel(msg: errorMessage)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.removeLabel()
        }
    }
    
    func updateUIWithDataItems(dataItems: [Any])
    {
        if let newVenueList = dataItems as? [Venue]
        {
            self.removeLabel()
          
            self.shuffleTableView(newVenueList: newVenueList)
        }
    }
}

extension VenueListViewController : Updater
{
    func postDataToAPI(dataToPost: [Any])
    {
        print("Not implemented")
    }
}
