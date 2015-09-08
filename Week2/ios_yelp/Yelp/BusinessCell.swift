//
//  BusinessCell.swift
//  Yelp
//
//  Created by Nguyen Xuan Gieng on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var ratingCountLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    
    var business : Business! {
        didSet {
            
            nameLabel.text = business.name!
            ratingImageView.setImageWithURL(business.ratingImageURL!)
            ratingCountLabel.text = "\(business.reviewCount!)"
            ratingCountLabel.text! += (business.reviewCount as! Double) > 1 ? " Reviews" : "Review"
            addressLabel.text = business.address!
            distanceLabel.text = business.distance!
            categoriesLabel.text = business.categories!
            
            thumbImageView.setImageWithURL(business.imageURL!)
            self.layoutIfNeeded()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbImageView.layer.cornerRadius = 5
        thumbImageView.clipsToBounds = true
        
        //nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       // nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
