//
//  AddActivityViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 5.01.2020.
//  Copyright © 2020 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class AddActivityViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayPickerView: UIPickerView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var subtitleTextField: UITextField!
    @IBOutlet var activityTypeButtons: [UIButton]!
    
    var tripIndex: Int! // Needs for saving
    var tripModel: TripModel! // Needs for showing days in pickerivew
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        
        dayPickerView.delegate = self
        dayPickerView.dataSource = self
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
        let activityType: ActivityType = getSelectedActivityType()
        
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
