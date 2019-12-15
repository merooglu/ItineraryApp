//
//  TripsViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 29.10.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class TripsViewController: UIViewController {
    
    @IBOutlet weak var tableVeiw: UITableView!
    @IBOutlet weak var addButton: FloatingActionButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableVeiw.delegate = self
        tableVeiw.dataSource = self
        
        TripFunctions.readTrips(complition: { [weak self] in
            // Completion, this called from TripFunctions.readTrips function
            self?.tableVeiw.reloadData()
        })
        
        view.backgroundColor = Theme.backgroundColor
        //        addButton.createFloatingActionButton()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTripViewController" {
            let popup = segue.destination as! AddTripViewController
            // 1. You can use the callback like this
//            popup.doneSaving = tripVCdoneSavingFunction()
            popup.doneSaving = {[weak self] in
                self?.tableVeiw.reloadData()
            }
        }
    }
    
    // 1. you define your function ve popupın doneSaving fonksiyonuna atıyoruz.
    func tripVCdoneSavingFunction() {
        // this call back functions
        // add your code here
    }
    
}

extension TripsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TripData.tripModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVeiw.dequeueReusableCell(withIdentifier: "cell") as! TripsTableViewCell
        cell.setup(tripModel: TripData.tripModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
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
        // this available thing is because I don't have trash icon in project so I use the sf symbols icon
        if #available(iOS 13.0, *) {
            delete.image = UIImage(systemName: "trash", withConfiguration: UIImage.SymbolConfiguration(scale: .medium))
        } else {
            // Fallback on earlier versions
        }
        // change the UIContextualAction background color
//        delete.backgroundColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
}
