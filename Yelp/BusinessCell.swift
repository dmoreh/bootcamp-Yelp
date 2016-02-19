//
//  BusinessCell.swift
//  Yelp
//
//  Created by Daniel Moreh on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!

    var business: Business! {
        didSet {
            nameLabel.text = business.name
            categoriesLabel.text = business.categories
            addressLabel.text = business.address
            distanceLabel.text = business.distance

            if let imageURL = business.imageURL {
                thumbImageView.setImageWithURL(imageURL)
            }

            if let reviewCount = business.reviewCount {
                reviewCountLabel.text = "\(reviewCount) Reviews"
            }

            if let ratingImageURL = business.ratingImageURL {
                ratingImageView.setImageWithURL(ratingImageURL)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbImageView.layer.cornerRadius = 3
        thumbImageView.clipsToBounds = true
    }
}
