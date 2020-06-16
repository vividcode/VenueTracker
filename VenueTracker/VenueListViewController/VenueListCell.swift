//
//  VenueListCell.swift
//  VenueTracker
//
//  Created by Nirav Bhatt on 26/04/2020.
//  Copyright © 2020 Nirav Bhatt. All rights reserved.
//

import UIKit

class VenueListCell: UITableViewCell {

    @IBOutlet weak var venueFavoriteButton: UIButton!
    @IBOutlet weak var venueThumbnail: UIImageView!
    @IBOutlet weak var venueDescriptionLabel: UILabel!
    @IBOutlet weak var venueNameLabel: UILabel!

    var thumbnailURL : NSURL?
    
    @objc var favoriteButtonAction : (() -> ())?
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        self.venueThumbnail.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func favoritePressed(_ sender: Any)
    {
        self.favoriteButtonAction?()
    }
    
}
