//
//  ActivityTableViewCell.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 24.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var activityImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cardView.addShadowAndRoundedCorners()
        titleLabel.font = UIFont(name: Theme.bodyFontNameDemiBold, size: 17)
        subTitleLabel.font = UIFont(name: Theme.bodyFontName, size: 17)
        
    }
    
    func setup(model: ActivityModel) {
        activityImageView.image = getActivityImage(type: model.activityType)
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
    
    func getActivityImage(type: ActivityType) -> UIImage {
        switch type {
        case .auto:
            return #imageLiteral(resourceName: "Car")
        case .excursion:
            return #imageLiteral(resourceName: "Excursion")
        case .flight:
            return #imageLiteral(resourceName: "Flight")
        case .food:
            return #imageLiteral(resourceName: "Food")
        case .hotel:
            return #imageLiteral(resourceName: "Hotel")
        }
    }

}
