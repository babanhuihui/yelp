//
//  ViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 9/19/14.
//  Copyright (c) 2014 Timothy Lee. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewDelegate{
    var client: YelpClient!
    var filterViewController: FilterViewController!
    
    var searchBar: UISearchBar!
    
    
    
    @IBOutlet weak var listTableView: UITableView!
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    let TConsumerKey = "Mb7dd5roWZEfLbQ0OOWUSA"
    let ConsumerSecret = "aTroe-QnZOPKEGrrz5qUaQzMHKs"
    let Token = "J-rPB6YnSiU8dCbnAgk0Dc_cIsNAa5so"
    let TokenSecret	= "8PFXYZnFQj6hIs_R_b4yDPuJRVs"
    
    var searchTerm = "restaurant"
    
    var radius = 0
    var categories:[String] = [String]()
    var sortBy = 0
    var offset = 1
    var deal = false
    
    var distanceValues = [0, 804, 1609, 8046, 16093]
    var listings: [NSDictionary] = [NSDictionary]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        listTableView.delegate = self
        listTableView.dataSource = self
        
        self.listings = []
        self.automaticallyAdjustsScrollViewInsets = false;
        listTableView.rowHeight = UITableViewAutomaticDimension
        listTableView.estimatedRowHeight = 90.0;
        
        searchBar = UISearchBar(frame: CGRect(x: 0.0, y: 0.0, width: 150.0, height: 40.0))
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        getData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func getData(){
        retrieveData(searchTerm, radius: radius, categories: categories, sortBy: sortBy, offset: offset)
    }
    
    func retrieveData(searchTerm:String, radius:Int, categories: [String], sortBy: Int, offset: Int){
        client = YelpClient(consumerKey: TConsumerKey, consumerSecret: ConsumerSecret, accessToken: Token, accessSecret: TokenSecret)
        client.searchWithTerm(searchTerm, radius: radius, categories: categories, sortBy: sortBy, offset: offset * 20, limit: 20, success:{ (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            println(response)
            self.listings += response["businesses"] as! [NSDictionary]
            NSLog("Listings count \(self.listings.count)")
            
            // Do any additional setup after loading the view.
            self.listTableView.reloadData()
            self.view.endEditing(true);
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listings.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if ((offset*20) - indexPath.row == 5) {
            self.offset += 1
            self.getData()
        }
        var listingCell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! listCell
        listingCell.list = listings[indexPath.row]
        return listingCell
    }
    
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
         tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchTerm = searchBar.text
        offset = 1
        listings = []
        
        radius = 0
        categories = [String]()
        sortBy = 0
        deal = false
        
        retrieveData(searchTerm, radius: radius, categories: categories, sortBy: sortBy, offset: offset)
        searchTerm = "restaurant"
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.resignFirstResponder()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        NSLog("Navigating")
        if segue.identifier == "presentFilter"{
            let filtersNC = segue.destinationViewController as! UINavigationController
            let filtersVC = filtersNC.viewControllers[0] as! FilterViewController
            filtersVC.delegate = self
        }
    }
    
    func filterUpdate(filterViewController: FilterViewController, didUpdateFilter dealsSelected: Bool, didUpdateFilter sortByRowSelected: Int, didUpdateFilter distanceRowSelected: Int, didUpdateFilter categoriesSelected: [String]){
        NSLog("Received information")
        self.radius = distanceValues[distanceRowSelected]
        self.categories = categoriesSelected
        self.sortBy = sortByRowSelected
        self.offset = 1
        self.deal = dealsSelected
        listings = []
        retrieveData(searchTerm, radius: radius, categories: categories, sortBy: sortBy, offset: offset)
    }

    
}

