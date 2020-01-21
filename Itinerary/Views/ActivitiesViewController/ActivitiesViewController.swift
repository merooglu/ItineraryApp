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
    
    fileprivate func getTripIndex() -> Int! {
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
    
    @IBAction func toggleEditModeButtonTapped(_ sender: UIBarButtonItem) {
        // toggle edit mode
//        tableView.isEditing = !tableView.isEditing
        // alternative
        tableView.isEditing.toggle()
        sender.title = sender.title == "Edit" ? "Done" : "Edit"
    }
    
}
// MARK: - UITableViewDelegate - UITableViewDataSource
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
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let activityModel = tripModel!.dayModels[indexPath.section].activityModels[indexPath.row]
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (contextualAction, view, actionPerformed: @escaping (Bool) -> Void ) in
            
            let alert = UIAlertController(title: "Delete Activity", message: "Are you sure want to delete this activity: \(activityModel.title)", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alertAction) in
                actionPerformed(false)
            }))
            
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (alertAction) in
                // perform delete
                ActivityFunctions.deleteActivity(at: self.getTripIndex(), for: indexPath.section, using: activityModel)
                self.tripModel!.dayModels[indexPath.section].activityModels.remove(at: indexPath.row)
                // table view den silmeden önce back-endten veriyi silmek gerekir (1 üst satır)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                actionPerformed(true)
            }))
            
            self.present(alert, animated: true)
            
        }
        
        delete.image = UIImage(named: "ic_delete")
        
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> Void) in
            let vc = AddActivityViewController.getInstance() as! AddActivityViewController
            vc.tripModel = self.tripModel
            
            // Which Trip are we working with?
            vc.tripIndex = self.getTripIndex()
            
            // Which Day are we on?
            vc.dayIndexToEdit = indexPath.section
            
            // Which activity are we editing?
            vc.activityModelToEdit = self.tripModel?.dayModels[indexPath.section].activityModels[indexPath.row]
            
            // What do we want to happen after the activity saved
            vc.doneUpdating = { [weak self] oldDayIndex, newDayIndex, activityModel in
                guard let self = self else { return }
                
                let oldActivityIndex = (self.tripModel?.dayModels[oldDayIndex].activityModels.firstIndex(of: activityModel))!
                
                if oldDayIndex == newDayIndex {
                    // 1. Update local table data
                    self.tripModel?.dayModels[newDayIndex].activityModels[oldActivityIndex] = activityModel
                    // 2. Refresh just that row
                    let indexPath = IndexPath(row: oldActivityIndex, section: newDayIndex)
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                } else {
                    // Activity moved to a different day
                    
                    // 1. Remove activity from local table data
                    self.tripModel?.dayModels[oldDayIndex].activityModels.remove(at: oldActivityIndex)
                    // 2. Insert Activity into new location
                    let lastIndex = (self.tripModel?.dayModels[newDayIndex].activityModels.count)!
                    self.tripModel?.dayModels[newDayIndex].activityModels.insert(activityModel, at: lastIndex)
                    // 3. Update table rows
                    tableView.performBatchUpdates({
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        let insertIndexPath = IndexPath(row: lastIndex, section: newDayIndex)
                        tableView.insertRows(at: [insertIndexPath], with: .automatic)
                    })
                }
            }
            
            self.present(vc, animated: true)
            actionPerformed(true)
        }
        
        edit.image = UIImage(named: "ic_edit")
        edit.backgroundColor = UIColor(named: "Edit")
        
        return UISwipeActionsConfiguration(actions: [edit])
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // choose which section you want to reorder
//        if indexPath.section > 0 {
//            return true
//        }
//        return false
        
        // reorder all cell
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 1. Get the current activity
        let activityModel = (tripModel?.dayModels[sourceIndexPath.section].activityModels[sourceIndexPath.row])!
        
        // 2. Delete activity from old location
        tripModel?.dayModels[sourceIndexPath.section].activityModels.remove(at: sourceIndexPath.row)
        
        // 3. Insert activity into the new location
        tripModel?.dayModels[destinationIndexPath.section].activityModels.insert(activityModel, at: destinationIndexPath.row)
        
        // 4. Update the data store
        ActivityFunctions.reorderActivity(at: getTripIndex(), oldDayIndex: sourceIndexPath.section, newDayIndex: destinationIndexPath.section, newActivityIndex: destinationIndexPath.row, activityModel: activityModel)
    }
    
}
