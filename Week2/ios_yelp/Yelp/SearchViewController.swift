//
//  SearchViewController.swift
//  Yelp
//
//  Created by Nguyen Xuan Gieng on 9/7/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate, FiltersViewDelegate {
    
    var searchBar: UISearchBar!
    
    static var userLocation: UserLocation!
    
    var results = [Business]()
    var offset: Int = 0
    var total: Int!
    let limit: Int = 20
    
    var selectedBusiness: Business?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(UserLocation.instance)
        
        self.searchBar = UISearchBar()
        self.searchBar.delegate = self
        self.searchBar.placeholder = "e.g. thai, bibimbap"
        self.navigationItem.titleView = self.searchBar
    }
    
    final func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.clearResults()
        self.performSearch(searchBar.text)
    }
    
    final func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.clearResults()
        }
    }
    
    final func performSearch(term: String, offset: Int = 0, limit: Int = 20) {
        self.searchBar.text = term
        self.searchBar.resignFirstResponder()
        self.onBeforeSearch()
        
        Business.searchWithTerm(term, parameters: self.getSearchParameters(), offset: offset, limit: limit, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.results += businesses
            self.offset = self.results.count
            self.total = Business.lastResponse!["total"] as! Int
            self.onResults(self.results, total: self.total, response: Business.lastResponse!)
            
            for business in businesses {
                println(business.name!)
                println(business.address!)
            }
        })
    }
    
    func getSearchParameters() -> Dictionary<String, String> {
        var parameters = [
            "ll": "\(UserLocation.instance.latitude),\(UserLocation.instance.longitude)"
        ]
        for (key, value) in YelpFilters.instance.parameters {
            parameters[key] = value
        }
        return parameters
    }
    
    func onBeforeSearch() -> Void {}
    
    func onResults(results: [Business], total: Int, response: NSDictionary) -> Void {}
    
    final func clearResults() {
        self.results = []
        self.offset = 0
        self.onResultsCleared()
    }
    
    func onResultsCleared() -> Void {}
    
    
    func showDetailsForResult(result: Business) {
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let controller = storyboard.instantiateViewControllerWithIdentifier("Details") as! DetailsViewController
        selectedBusiness = result
        controller.business = result
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController is UINavigationController {
            let navigationController = segue.destinationViewController as! UINavigationController
            if navigationController.viewControllers[0] is FiltersTableViewController {
                let controller = navigationController.viewControllers[0] as! FiltersTableViewController
                controller.delegate = self
            }
        } else if (segue.destinationViewController is DetailsViewController) {
            let controller = segue.destinationViewController as! DetailsViewController
            if let item = sender as? BusinessCell {
                print(item)
                controller.business = item.business
            } else if selectedBusiness != nil {
                controller.business = selectedBusiness!
            }
            
            println(controller.business)
            println(selectedBusiness)
        }
    }
    
    final func onFiltersDone(controller: FiltersTableViewController) {
        if self.searchBar.text != "" {
            self.clearResults();
            self.performSearch(self.searchBar.text)
        }
    }
    
    func synchronize(searchView: SearchViewController) {
        self.searchBar.text = searchView.searchBar.text
        self.results = searchView.results
        self.total = searchView.total
        self.offset = searchView.offset
        
        if self.results.count > 0 {
            self.onResults(self.results, total: self.total, response: Business.lastResponse!)
        } else {
            self.onResultsCleared()
        }
    }
    
}
