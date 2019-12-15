//
//  TripsTableViewCell.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class TripsTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tripImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.addShadowAndRoundedCorners()
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 32)
        cardView.backgroundColor = Theme.accentColor
        tripImageView.layer.cornerRadius = cardView.layer.cornerRadius
    }

    func setup(tripModel: TripModel) {
        titleLabel.text = tripModel.title
        tripImageView.image = tripModel.image
    }

}
