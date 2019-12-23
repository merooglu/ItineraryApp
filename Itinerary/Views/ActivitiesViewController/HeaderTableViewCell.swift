//
//  HeaderTableViewCell.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 21.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = UIFont(name: Theme.bodyFontNameBold, size: 17)
        subTitleLabel.font = UIFont(name: Theme.bodyFontName, size: 15)
    }
    
    func setup(model: DayModel) {
        titleLabel.text = model.title
        subTitleLabel.text = model.subTitle
    }
}
