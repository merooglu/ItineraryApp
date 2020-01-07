//
//  TripsViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var tableVeiw: UITableView!
    @IBOutlet weak var addButton: FloatingActionButton!
    @IBOutlet var helpView: UIVisualEffectView!
    var seenHelpView = "seenHelpView"
    
    var tripIndexToEdit: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        
        TripFunctions.readTrips(complition: { [unowned self] in
            // Completion, this called from TripFunctions.readTrips function
            self.tableVeiw.reloadData()
            
            if TripData.tripModels.count > 0 {
                if UserDefaults.standard.bool(forKey: self.seenHelpView) == false {
                    self.view.addSubview(self.helpView)
                    self.helpView.frame = self.view.bounds 
                }
            }
        })
     
        view.backgroundColor = Theme.backgroundColor
        //        addButton.createFloatingActionButton()
        
        UIView.animate(withDuration: 1, delay: 0, options: [.curveEaseIn], animations: {
            // 200° x π/180
            let radians = CGFloat(200 * Double.pi/180)
            self.logoImageView.alpha = 0
            self.logoImageView.transform = CGAffineTransform(rotationAngle: radians).scaledBy(x: 3, y: 3)
            
            let yRotation = CATransform3DMakeRotation(radians, 0, radians, 0)
            self.logoImageView.layer.transform = CATransform3DConcat(self.logoImageView.layer.transform, yRotation)
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTripViewController" {
            let popup = segue.destination as! AddTripViewController
            popup.tripIndexToEdit = self.tripIndexToEdit
            // 1. You can use the callback like this
//            popup.doneSaving = tripVCdoneSavingFunction()
            popup.doneSaving = {[weak self] in
                guard let self = self else { return }
                self.tableVeiw.reloadData()
            }
            tripIndexToEdit = nil
        }
    }
    
    // 1. you define your function ve popupın doneSaving fonksiyonuna atıyoruz.
    func tripVCdoneSavingFunction() {
        // this call back functions
        // add your code here
    }
    
    
    @IBAction func helpViewCloseButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
        }) { (success) in
            self.helpView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: self.seenHelpView)
        }
    }
    
}

// MARK: - TableView datasource and delegate functions
extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripData.tripModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVeiw.dequeueReusableCell(withIdentifier: TripsTableViewCell.identifier) as! TripsTableViewCell
        cell.setup(tripModel: TripData.tripModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trip = TripData.tripModels[indexPath.row]
        let vc = ActivitiesViewController.getInstance() as! ActivitiesViewController
        vc.tripId = trip.id
        vc.tripTitle = trip.title
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Deleting tableView row swipe to left side
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let trip = TripData.tripModels[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void ) in
            
            let alert = UIAlertController(title: "Delete Trip", message: "Are you sure want to delete this trip: \(trip.title)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                // perform delete
                TripFunctions.deleteTrip(index: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                actionPerformed(true)
            }))
            
            self.present(alert, animated: true)
            
        }
        
        delete.image = UIImage(named: "ic_delete")
        // change the UIContextualAction background color
//        delete.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    // MARK: - Editing tableView rows swipe to right side
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> Void) in
            self.tripIndexToEdit = indexPath.row
            self.performSegue(withIdentifier: "AddTripViewController", sender: nil)
            actionPerformed(true)
        }
        
        edit.image = UIImage(named: "ic_edit")
        edit.backgroundColor = Theme.editColor // UIColor(named: "Edit")
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
}
