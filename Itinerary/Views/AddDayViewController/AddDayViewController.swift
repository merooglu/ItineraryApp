//
//  AddDayViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class AddDayViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subTitleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var tripIndexToEdit: Int?
    
    var doneSaving: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        titleTextField.rightViewMode = .never
        guard titleTextField.hasValue, let newTitle = titleTextField.text else {return}
        
//        if let index = tripIndexToEdit {
//            TripFunctions.updateTrip(at: index, title: newTripName, image: imageview.image)
//        } else {
//            TripFunctions.createTrip(tripModel: TripModel(title: newTripName, image: imageview.image))
//        }
        
        if let doneSaving = doneSaving {
            doneSaving()
        }
        dismiss(animated: true)
    }
}
