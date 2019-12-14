//
//  UIButtonExtension.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 30.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

extension UIButton {

    func createFloatingActionButton() {
        backgroundColor = Theme.tintColor
        layer.cornerRadius = frame.height / 2
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 10)
    }

}
