//
//  MultiSelectCell.swift
//  Yelp
//
//  Created by Shuhui Qu on 4/21/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

protocol MultiSelectDelegate
{
    func distanceSelected(multiSelectCell:MultiSelectCell, didChangeValue distance: Int)
    func sortBySelected(multiSelectCell:MultiSelectCell, didChangeValue sortBy: Int)
}

class MultiSelectCell: UITableViewCell {

    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    var delegate:MultiSelectDelegate?
    
    var section: Int = -1
    var row: Int = -1
    
    var sectionExpanded = false
    var rowSelected = false
    
    var sortByRowSelected = 0
    var distanceRowSelected = 0
    
    var distances = ["Auto", "0.5 miles", "1 mile", "5 miles", "20 miles"]
    var distancesValue = [0, 804, 1609, 8046, 16093]
    var sortBy = ["Best Match", "Distance", "Rating"]
    var sortByValue = [0,1,2]

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if (section == 1) {
            self.categoryLabel.text = distances[row]
            if (row == distanceRowSelected) {
                rowSelected = true
                delegate?.distanceSelected(self, didChangeValue: distancesValue[row])
            } else {
                rowSelected = false
            }
        }
        if (section == 2) {
            self.categoryLabel.text = sortBy[row]
            if (row == sortByRowSelected) {
                rowSelected = true
                delegate?.sortBySelected(self, didChangeValue: sortByValue[row])
            } else {
                rowSelected = false
            }
        }
        if (sectionExpanded) {
            statusLabel.text = "wait"
            if (rowSelected) {
                statusLabel.text = "checked"
            } else {
                statusLabel.text = "unchecked"
            }
        } else {
            statusLabel.text = "see all"
        }
    }
}
