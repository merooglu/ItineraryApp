//
//  AddTripViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 14.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import Photos
import UIKit

class AddTripViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tripTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var imageview: UIImageView!
    
    var tripIndexToEdit: Int?
    
    var doneSaving: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.font = UIFont(name: Theme.mainFontName, size: 24)
        imageview.layer.cornerRadius = 10
        
        // DropShadow on title
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowColor = UIColor.white.cgColor
        titleLabel.layer.shadowOffset = CGSize.zero
        titleLabel.layer.shadowRadius = 5
        
        if let index = tripIndexToEdit {
            let trip = TripData.tripModels[index]
            tripTextField.text = trip.title
            imageview.image = trip.image
            titleLabel.text = "Edit Trip"
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        tripTextField.rightViewMode = .never
        // 4- using extension
        //        guard tripTextField.hasValue, let newTripName = tripTextField.text else { return }
        
        guard tripTextField.text != "", let newTripName = tripTextField.text else {
            // Alternatives
            // 1- to show warning image in textfield
            //            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            //            imageView.image = UIImage(named: "ic_warning")
            //            imageView.contentMode = .scaleAspectFit
            //
            //            tripTextField.rightView = imageView
            //            tripTextField.rightViewMode = .always
            
            // 2- make textfield background something diffrent
            //            tripTextField.backgroundColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
            
            // 3- make textfield borders red
            tripTextField.layer.borderColor = UIColor.red.cgColor
            tripTextField.layer.borderWidth = 1
            tripTextField.layer.cornerRadius = 5
            tripTextField.placeholder = "Trip name required"
            
            return
        }

        if let index = tripIndexToEdit {
            TripFunctions.updateTrip(at: index, title: newTripName, image: imageview.image)
        } else {
            TripFunctions.createTrip(tripModel: TripModel(title: newTripName, image: imageview.image))
        }
        
        if let doneSaving = doneSaving {
            doneSaving()
        }
        dismiss(animated: true)
    }
    
    fileprivate func presentPhotoPickerController() {
        DispatchQueue.main.async {
            let myPickerController = UIImagePickerController()
            myPickerController.allowsEditing = true
            myPickerController.delegate = self
            myPickerController.sourceType = .photoLibrary
            self.present(myPickerController, animated: true)
        }
    }
    
    @IBAction func addPhotoButtonTapped(_ sender: UIButton) {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.presentPhotoPickerController()
            case .notDetermined:
                if status == PHAuthorizationStatus.authorized {
                    self.presentPhotoPickerController()
                }
            case .restricted:
                let alert = UIAlertController(title: "Photo Library Restricted", message: "Photo library access restricted and cannot be accessed.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            case .denied:
                let alert = UIAlertController(title: "Photo Library Access Denied", message: "Photo library access was previously denied. Please update your Settings if you wish to change this.", preferredStyle: .alert)
                let gotoSettingsAction = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
                    DispatchQueue.main.async {
                        let url = URL(string: UIApplication.openSettingsURLString)!
                        UIApplication.shared.open(url, options: [:])
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(gotoSettingsAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true)
            @unknown default:
                print("It looks like Apple add new enum values to PHAuthorizationStatus")
            }
        }
    }
    
}

extension AddTripViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            self.imageview.image = image
        } else if let image = info[.originalImage] as? UIImage {
            self.imageview.image = image
        }
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
