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
}
