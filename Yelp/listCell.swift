//
//  listCell.swift
//  Yelp
//
//  Created by Shuhui Qu on 4/21/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class listCell: UITableViewCell {

    @IBOutlet weak var listNameLabel: UILabel!
    @IBOutlet weak var listReviewCountLabel: UILabel!
    @IBOutlet weak var listAddrLabel: UILabel!
    @IBOutlet weak var listCategoryLabel: UILabel!
    @IBOutlet weak var listDistLabel: UILabel!
    @IBOutlet weak var listImageView: UIImageView!
    @IBOutlet weak var ratingImageView: UIImageView!
    
    var list:NSDictionary = NSDictionary()
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
        listNameLabel.text = list["name"] as? String
        
        listImageView.layer.cornerRadius = 3
        listImageView.clipsToBounds = true
        if let url = list["image_url"] as? String{
            listImageView.setImageWithURL(NSURL(string: url)!)
        }
        
        
        var ratingsUrl = list["rating_img_url"] as? String
        ratingImageView.setImageWithURL(NSURL(string: ratingsUrl!))
        var numberOfRatings = list["review_count"] as? Int
        listReviewCountLabel.text = "\(numberOfRatings!) Reviews"
        
        var location = list["location"] as! NSDictionary
        var displayAddress = location["display_address"] as! [String]
        var labelDisplayAddress = "\(displayAddress[0])"
        var i = 1
        while ( i < displayAddress.count) {
            labelDisplayAddress += ",\(displayAddress[i])"
            i++
        }
        listAddrLabel.text = labelDisplayAddress
        
        var categories = list["categories"]as! [[String]]
        var categoryLabelString = "\(categories[0][0])"
        // TODO fix that trailing comma
        i = 1
        while ( i < categories.count){
            categoryLabelString += ",\(categories[i][0])"
            i++
        }
        listCategoryLabel.text = categoryLabelString
        
        // Get the real distance
        listDistLabel.text = list["distance"] as? String

    }

}
