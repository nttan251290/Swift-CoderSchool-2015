//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit
import CoreLocation

class BusinessesViewController: SearchViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var loadingIndicator: LoadingIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 116
        
        self.tableView.addInfiniteScrollingWithActionHandler({
            self.performSearch(self.searchBar.text, offset: self.offset, limit: self.limit)
        })
        
        self.tableView.showsInfiniteScrolling = false
        self.tableView.reloadData()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("onUserLocation"), name: "UserLocation/updated", object: nil)
        
        UserLocation.instance.requestLocation()
        
        let loadingIndicator = (NSBundle.mainBundle().loadNibNamed("LoadingIndicator", owner: self, options: nil)[0] as! LoadingIndicator)
        self.loadingIndicator = loadingIndicator
        self.tableView.tableFooterView = loadingIndicator
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = self.results[indexPath.row]
        
        return cell
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let result = self.results[indexPath.row]
        selectedBusiness = result
        self.showDetailsForResult(result)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    */
    
    func onUserLocation() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "UserLocation/updated", object: nil)
        if self.searchBar.text == "" {
            self.performSearch("Restaurants")
        }
    }
    
    override func onBeforeSearch() {
        self.loadingIndicator.animate()
    }
    
    override func onResults(results: [Business], total: Int, response: NSDictionary) {
        self.tableView.infiniteScrollingView.stopAnimating()
        self.tableView.showsInfiniteScrolling = results.count < total
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.reloadData()
    }
    
    override func onResultsCleared() {
        self.loadingIndicator.stopAnimating()
        self.tableView.tableFooterView = self.loadingIndicator
        self.tableView.showsInfiniteScrolling = false
        self.tableView.reloadData()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            if navigationController.viewControllers[0] is MapViewController {
                let controller = navigationController.viewControllers[0] as! MapViewController
                controller.delegate = self
            }
        }
    }

    
    
}
