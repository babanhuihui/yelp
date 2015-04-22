//
//  FilterViewController.swift
//  Yelp
//
//  Created by Shuhui Qu on 4/21/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
//
//    distanceRowSelected = find(distanceValues, distance)!
//
//    sortByRowSelected = sortBy
//
//    dealsSelected = selected
//
//        categoriesSelected.append(category)
//        categoryRowsSelected.append(find(generalCategoriesValues, category)!)


protocol FilterViewDelegate
{
    func filterUpdate(filterViewController: FilterViewController, didUpdateFilter dealsSelected: Bool, didUpdateFilter sortByRowSelected: Int, didUpdateFilter distanceRowSelected: Int, didUpdateFilter categoriesSelected: [String])
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CategoryCellDelegate, MultiSelectDelegate{

    
    @IBOutlet weak var tableView: UITableView!
    var delegate: FilterViewDelegate?
    
    var sectionExpanded = [1: false, 2: false, 3: true]
    
    var dealsSelected = false
    var distanceRowSelected = 0
    //Auto,0.5,1,5,10 miles
    var distanceValues = [0, 804, 1609, 8046, 16093]
    
    var sortByRowSelected = 0
    //best, dist ,rating
    var sortByValues = [0,1,2]
    
    var categoriesSelected : [String] = []
    var generalCategoriesValues = ["sushi","fooddeliveryservices", "vegan","cafes"]
    var categoryRowsSelected: [Int] = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false;
        tableView.rowHeight = 40

        
        // Do any additional setup after loading the view.
        for category in categoriesSelected {
            categoryRowsSelected.append(find(generalCategoriesValues, category)!)
        }
        
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView = UIView(frame: CGRect(x:0, y:0, width: 320, height: 40))
        var headerLabel = UILabel(frame: CGRect(x:0, y:0, width:320, height: 40))
        
        if (section == 0) {
            headerLabel.text = "Deals"
        }
        if (section == 1) {
            headerLabel.text = "Distance"
        }
        if (section == 2) {
            headerLabel.text = "Sort By"
        }
        if (section == 3) {
            headerLabel.text = "Category"
        }
        headerView.addSubview(headerLabel)
        return headerView
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var section = indexPath.section
        if (section == 1 || section == 2) {
            if (sectionExpanded[section] == true) {
                if (section == 1) {
                    distanceRowSelected = indexPath.row
                } else {
                    sortByRowSelected = indexPath.row
                }
                sectionExpanded[section] = false
            } else {
                sectionExpanded[section] = true
            }
        }
        
        if (section == 3) {
            if(sectionExpanded[section] == true){
                sectionExpanded[section] = false
                categoryRowsSelected = [0]
            }else{
                sectionExpanded[section] = true
                for category in categoriesSelected {
                    categoryRowsSelected.append(find(generalCategoriesValues, category)!)
                }
            }
        }
        
        tableView.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var section = indexPath.section
        NSLog(String(section))
//        if (section == 3 && indexPath.row == 0 && !sectionExpanded[section]!) {
//            var cell = tableView.dequeueReusableCellWithIdentifier("expandCell") as! ExpandCell
//            return cell
//        }
        if (section == 0 || section == 3) {
            var cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell") as! CategoryCell
            cell.section = indexPath.section
            cell.row = indexPath.row
            cell.delegate = self
            setSwitchValue(cell, section: indexPath.section, row: indexPath.row)
            return cell
            
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("multiCell") as! MultiSelectCell
            cell.section = indexPath.section
            if (!sectionExpanded[section]!) {
                if (section == 1) {
                    cell.row = distanceRowSelected
                } else if section == 2 {
                    cell.row = sortByRowSelected
                }
            } else {
                cell.row = indexPath.row
            }
            cell.sortByRowSelected = self.sortByRowSelected
            cell.distanceRowSelected = self.distanceRowSelected
            cell.sectionExpanded = sectionExpanded[section]!
            cell.delegate = self
            return cell
        }
    }
    
    func setSwitchValue(cell: CategoryCell, section: Int, row: Int) -> Void{
        if (section == 0) {
            if (dealsSelected) {
                cell.categorySwitch.setOn(true, animated: false)
            }else{
                cell.categorySwitch.setOn(false, animated: false)
            }
        }
        if (section == 3) {
            var isCategoryRowSelected = find(categoryRowsSelected, row)
            if let isSelected = isCategoryRowSelected {
                cell.categorySwitch.setOn(true, animated: false)
            }else{
                cell.categorySwitch.setOn(false, animated: false)
            }
        }
    }

    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1;
        }
        if (section == 1) {
            if (sectionExpanded[section] == true) {
                return 5
            } else {
                return 1
            }
        }
        
        if (section == 2) {
            if (sectionExpanded[section] == true) {
                return 3
            } else {
                return 1
            }
        }
        if (section == 3) {
            if (sectionExpanded[section] == true) {
                return 4
            } else {
                return 1
            }
        }
        return 0

    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int{
        return 4
    }
    
    @IBAction func cancelTap(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }


    
    @IBAction func searchTap(sender: UIBarButtonItem) {
        delegate?.filterUpdate(self, didUpdateFilter: dealsSelected, didUpdateFilter: sortByRowSelected, didUpdateFilter: distanceRowSelected, didUpdateFilter: categoriesSelected)
        dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func distanceSelected(multiSelectCell:MultiSelectCell, didChangeValue distance: Int){
        distanceRowSelected = find(distanceValues, distance)!
        NSLog("dist")
    }
    func sortBySelected(multiSelectCell:MultiSelectCell, didChangeValue sortBy: Int){
        sortByRowSelected = sortBy
        NSLog("sort")
    }
    func dealsSelected(categoryCell: CategoryCell, didChangeValue selected: Bool){
        dealsSelected = selected
        NSLog("deals")
    }
    func generalSelected(categoryCell: CategoryCell, didChangeValue category: String, didChangeValue selected: Bool){
        NSLog("category")
        if(selected == true){
            categoriesSelected.append(category)
            categoryRowsSelected.append(find(generalCategoriesValues, category)!)
        }else{
            var temp:Int?
            if let temp = find(categoriesSelected, category){
                categoriesSelected.removeAtIndex(temp)
                categoryRowsSelected.removeAtIndex(temp)
            }
            
        }

    }

    

}
