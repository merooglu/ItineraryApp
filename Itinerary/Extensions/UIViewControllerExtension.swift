//
//  UIViewControllerExtension.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

extension UIViewController {
    /**
     Just returns the initial viewcontroller on a storyboard
     */
    static func getInstance() -> UIViewController {
        let storyBoard = UIStoryboard(name: String(describing: self), bundle: nil)
        let vc = storyBoard.instantiateInitialViewController()!
        return vc
    }
}
