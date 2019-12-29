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
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var subTitleTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var tripIndex: Int!
    
    var doneSaving: ((DayModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
//        guard titleTextField.hasValue, let newTitle = titleTextField.text else {return}
        
        let dayModel = DayModel(title: datePicker.date, subTitle: subTitleTextField.text ?? "", tripData: nil)
        DayFunctions.createDays(at: tripIndex, using: dayModel)

        if let doneSaving = doneSaving {
            doneSaving(dayModel)
        }
        dismiss(animated: true)
    }
    
    @IBAction func subTitleTextFieldDoneAction(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
