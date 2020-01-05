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

        updateTableViewWithTripData()
        sectionHeaderHeight = tableView.dequeueReusableCell(withIdentifier: HeaderTableViewCell.identifier)?.contentView.bounds.height ?? 0
    }
    
      fileprivate func updateTableViewWithTripData() {
          TripFunctions.readTrip(by: tripId) {[weak self] (model) in
              guard let self = self else { return }
              self.tripModel = model
              
              guard let model = model else { return }
              self.backgroundImageView.image = model.image
              self.tableView.reloadData()
          }
      }

    @IBAction func addButtonTapped(_ sender: FloatingActionButton) {
        let alert = UIAlertController(title: "Which would you like to add?", message: nil, preferredStyle: .actionSheet)
        let dayAction = UIAlertAction(title: "Day", style: .default, handler: handleAddDay)
        let activityAction = UIAlertAction(title: "Activity", style: .default, handler: handleAddActivity(action:))
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // alternative
//        if tripModel?.dayModels.count == 0 {
//            activityAction.isEnabled = false
//        }
        
        activityAction.isEnabled = tripModel!.dayModels.count > 0
        
        alert.addAction(dayAction)
        alert.addAction(activityAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = CGRect(x: 0, y: -7, width: sender.bounds.width, height: sender.bounds.height)
        present(alert, animated: true)
    }
    
    func handleAddDay(action: UIAlertAction) {
        // move to extension
//        let storyBoard = UIStoryboard(name: String(describing: AddDayViewController.self), bundle: nil)
//        let vc = storyBoard.instantiateInitialViewController()!
//        vc.modalPresentationStyle = .overFullScreen
        let vc = AddDayViewController.getInstance() as! AddDayViewController
        vc.tripModel = tripModel
        // alternative
        // let index = TripData.tripModels.firstIndex { $0.id == tripId }
        vc.tripIndex = TripData.tripModels.firstIndex(where: { (tripModel) -> Bool in
            tripModel.id == tripId
        })
        vc.doneSaving = {[weak self] dayModel in
            guard let self = self else { return }
//            let indexArray = [self.tripModel?.dayModels.count ?? 0]
            self.tripModel?.dayModels.append(dayModel)
            let indexArray = [self.tripModel?.dayModels.firstIndex(of: dayModel) ?? 0]
            self.tableView.insertSections(IndexSet(indexArray), with: UITableView.RowAnimation.automatic)
            // alternative
            // self.updateTableViewWithTripData()
        }
        present(vc, animated: true)
    }
    
    fileprivate func getTripIndex() -> Int? {
        return TripData.tripModels.firstIndex(where: { (tripModel) -> Bool in
            tripModel.id == tripId
        })
    }
    
    func handleAddActivity(action: UIAlertAction) {
        let vc = AddActivityViewController.getInstance() as! AddActivityViewController
        vc.tripModel = tripModel
        // alternative
        //        vc.tripIndex = TripData.tripModels.firstIndex(where: { (tripModel) -> Bool in
        //            tripModel.id == tripId
        //        })
        vc.tripIndex = getTripIndex()
        vc.doneSaving = {[weak self] dayIndex, activityModel in
            guard let self = self else { return }
            self.tripModel?.dayModels[dayIndex].activityModels.append(activityModel)
            let row = (self.tripModel?.dayModels[dayIndex].activityModels.count)! - 1
            let indexPath = IndexPath(row: row, section: dayIndex)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        present(vc, animated: true)
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
