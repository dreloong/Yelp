//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/8/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!

    var business: Business! {
        didSet {
            addressLabel.text = business.address
            categoriesLabel.text = business.categories
            distanceLabel.text = business.distance
            nameLabel.text = business.name
            ratingImageView.setImageWithURL(business.ratingImageUrl!)
            reviewCountLabel.text = "\(business.reviewCount!) Reviews"
            thumbnailImageView.setImageWithURL(business.imageUrl!)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        thumbnailImageView.layer.cornerRadius = 3
        thumbnailImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
