//
//  AddActivityViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 5.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class AddActivityViewController: UITableViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet var activityTypeButtons: [UIButton]!
    
    var doneSaving: ((Int, ActivityModel) -> ())?
    var tripIndex: Int! // Needs for saving
    var tripModel: TripModel! // Needs for showing days in pickerivew
    
    // For editing activities
    var dayIndexToEdit: Int?
    var activityModelToEdit: ActivityModel!
    var doneUpdating: ((Int, Int, ActivityModel) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
        
        if let dayIndex = dayIndexToEdit, let activityModel = activityModelToEdit {
            // Update Activity: populate the popup
            titleLabel.text = "Edit Activity"
            
            // Select the Day in the Picker View
            dayPickerView.selectRow(dayIndex, inComponent: 0, animated: true)
            
            // Populate the Activity Data
            activityTypeSelected(activityTypeButtons[activityModel.activityType.rawValue])
            titleTextField.text = activityModel.title
            subtitleTextField.text = activityModel.subTitle
        } else {
            // New Activity: set default values
            activityTypeSelected(activityTypeButtons[ActivityType.excursion.rawValue])
            
        }
    }
    
    @IBAction func activityTypeSelected(_ sender: UIButton) {
        // alternative
//        activityTypeButtons.forEach { (button) in
//            button.tintColor = Theme.accentColor
//        }
        activityTypeButtons.forEach({ $0.tintColor = Theme.accentColor})
        sender.tintColor = Theme.tintColor
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard titleTextField.text != "", let newTitle = titleTextField.text else {
            titleTextField.layer.borderColor = UIColor.red.cgColor
            titleTextField.layer.borderWidth = 1
            titleTextField.layer.cornerRadius = 5
            titleTextField.placeholder = "Activity name required"
            return
        }
        
        let activityType: ActivityType = getSelectedActivityType()
        
        let newDayIndex = dayPickerView.selectedRow(inComponent: 0)
        
        if activityModelToEdit != nil {
            // Update Activity
            activityModelToEdit.activityType = activityType
            activityModelToEdit.title = newTitle
            activityModelToEdit.subTitle = subtitleTextField.text ?? ""
            
            ActivityFunctions.updateActivity(at: tripIndex, oldDayIndex: dayIndexToEdit!, newDayIndex: newDayIndex, using: activityModelToEdit)
            
            if let doneUpdating = doneUpdating, let oldDayIndex = dayIndexToEdit {
                doneUpdating(oldDayIndex, newDayIndex, activityModelToEdit)
            }
        } else {
            // New Activity
            let activityModel = ActivityModel(title: newTitle, subTitle: subtitleTextField.text ?? "", activityType: activityType)
            ActivityFunctions.createActivity(at: tripIndex, for: newDayIndex, using: activityModel)
            
            if let doneSaving = doneSaving {
                doneSaving(newDayIndex, activityModel)
            }
        }
        
        dismiss(animated: true)
    }
    
    func getSelectedActivityType() -> ActivityType {
        for (index, button) in activityTypeButtons.enumerated() {
            if button.tintColor == Theme.tintColor {
                return ActivityType(rawValue: index) ?? .excursion
            }
        }
        
        return .excursion
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func keyboarddDoneButtonAction(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
}

extension AddActivityViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tripModel.dayModels.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return tripModel.dayModels[row].title.mediumDate()
    }
}
