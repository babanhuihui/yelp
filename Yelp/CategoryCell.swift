//
//  CategoryCell.swift
//  Yelp
//
//  Created by Shuhui Qu on 4/21/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate
{
    func dealsSelected(categoryCell: CategoryCell, didChangeValue selected: Bool)
    func generalSelected(categoryCell: CategoryCell, didChangeValue category: String, didChangeValue selected: Bool)
}


class CategoryCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categorySwitch: UISwitch!
    var delegate:CategoryCellDelegate?
    
    var section: Int = -1
    var row: Int = -1
    
    var dealCategory = ["Has a Deal"]
    var distanceCategories = ["Auto", "0.5 miles", "1 mile", "5 miles", "10 miles"]
    var distanceCategoriesValue = [0, 804, 1609, 8046, 32186]
    var sortByCategories = ["Best Match": 0, "Distance": 1, "Rating": 2]
    var generalCategories = ["sushi", " delivery", "vegan",  "cafes"]
    var generalCategoriesValues = ["sushi","fooddeliveryservices", "vegan","cafes"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func switchFliped(sender: UISwitch) {
        var selected: Bool = sender.on
        if (section == 0) {
            delegate?.dealsSelected(self, didChangeValue: selected)
        } else if section == 1 {

        } else if section == 2 {

        } else if section == 3 {
            delegate?.generalSelected(self, didChangeValue: generalCategoriesValues[row], didChangeValue: selected)
        }

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (section == 0) {
            self.categoryLabel.text = dealCategory[row]
        }
        if (section == 3) {
            self.categoryLabel.text = generalCategories[row]
        }
    }

}
