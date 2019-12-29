//
//  ActivitiesViewController.swift
//  Itinerary
//
//  Created by Mehmet Eroğlu on 17.12.2019.
//  Copyright © 2019 Mehmet Eroğlu. All rights reserved.
//

import UIKit

class ActivitiesViewController: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: FloatingActionButton!
    
    var tripId: UUID!
    var tripTitle = ""
    var tripModel: TripModel?
    var sectionHeaderHeight: CGFloat = 0.0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = tripTitle
        tableView.dataSource = self
        tableView.delegate = self

        TripFunctions.readTrip(by: tripId) {[weak self] (model) in
            guard let self = self else { return }
            self.tripModel = model
            
            guard let model = model else { return }
            self.backgroundImageView.image = model.image
            self.tableView.reloadData()
        }
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)?.contentView.bounds.height ?? 0
    }

    @IBAction func addButtonTapped(_ sender: FloatingActionButton) {
        let alert = UIAlertController(title: "Which would you like to add?", message: nil, preferredStyle: .actionSheet)
        let dayAction = UIAlertAction(title: "Day", style: .default, handler: handleAddDay)
        let activityAction = UIAlertAction(title: "Activity", style: .default, handler: handleAddActivity(action:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(dayAction)
        alert.addAction(activityAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: -7, width: sender.bounds.width, height: sender.bounds.height)
        present(alert, animated: true)
    }
    
    func handleAddDay(action: UIAlertAction) {
        print("Add new day")
    }
    
    func handleAddActivity(action: UIAlertAction) {
        print("Add new activity")
    }
}

extension ActivitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tripModel?.dayModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let dayModel = tripModel?.dayModels[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier) as! HeaderTableViewCell
        cell.setup(model: dayModel!)
        return cell.contentView
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let title = tripModel?.dayModels[section].title ?? ""
//        let subTitle = tripModel?.dayModels[section].subTitle ?? ""
//        return "\(title) - \(subTitle)"
//    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tripModel?.dayModels[section].activityModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var model = tripModel?.dayModels[indexPath.section].activityModels[indexPath.row]
        var cell = tableView.dequeueReusableCell(withIdentifier: ActivityTableViewCell.identifier) as! ActivityTableViewCell
        cell.setup(model: model!)
        return cell
    }
}
