//
//  UITextFieldExtension.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

extension UITextField {
    var hasValue: Bool {
        guard text == "" else {return true}
        // 1- to show warning image in textfield
        //            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        //            imageView.image = UIImage(named: "ic_warning")
        //            imageView.contentMode = .scaleAspectFit
        //
        //            rightView = imageView
        //            rightViewMode = .unlessEditing
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        return false
    }
}
