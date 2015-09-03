//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()
    var showRepo: [GithubRepo]! = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        // add search bar to navigation bar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        
        doSearch()
    }
    
    private func doSearch() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
       
        GithubRepo.fetchRepos(searchSettings, successCallback: { (repos) -> Void in
            self.showRepo = repos
            self.tableView.reloadData()
            
            for repo in repos {
                print("[Name: \(repo.name!)]" +
                    "\n\t[Stars: \(repo.stars!)]" +
                    "\n\t[Forks: \(repo.forks!)]")
                println(
                    "\n\t[Description: \(repo.description!)]" +
                    "\n\t[Owner: \(repo.ownerHandle!)]" +
                    "\n\t[Avatar: \(repo.ownerAvatarURL!)]")
            }
            
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }, error: { (error) -> Void in
            println(error)
        })
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("CustomRepoCell") as? CustomRepoCell
        
        if cell == nil {
            cell = CustomRepoCell()
        }
        
        cell!.parseRepoData(showRepo[indexPath.row])
        
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if showRepo.count != 0 {
                print(showRepo.count)
        }
        
        return showRepo.count
        
        
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}
