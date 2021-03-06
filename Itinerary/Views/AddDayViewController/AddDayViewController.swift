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
    var tripModel: TripModel!
    var doneSaving: ((DayModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        if alreadyExists(datePicker.date) {
            let alert = UIAlertController(title: "Day Already Exists", message: "Choose another day.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
//        guard titleTextField.hasValue, let newTitle = titleTextField.text else {return}
        
        let dayModel = DayModel(title: datePicker.date, subTitle: subTitleTextField.text ?? "", tripData: nil)
        DayFunctions.createDay(at: tripIndex, using: dayModel)

        if let doneSaving = doneSaving {
            doneSaving(dayModel)
        }
        dismiss(animated: true)
    }
    
    func alreadyExists(_ date: Date) -> Bool {
        // alternative
//        if tripModel.dayModels.contains(where: { (dayModel) -> Bool in
//            return dayModel.title == date
//        }) {
//            return true
//        }
        
        if tripModel.dayModels.contains(where: { $0.title.mediumDate() == date.mediumDate() }) {
            return true
        }
        
        return false
    }
    
    @IBAction func subTitleTextFieldDoneAction(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}
