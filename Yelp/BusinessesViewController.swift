//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var businessTableView: UITableView!

    var searchTerm = "Restaurants" {
        didSet {
            if searchTerm == "" {
                searchTerm = "Restaurants"
            }
            self.fetchResults()
        }
    }

    var filters = Filters() {
        didSet {
            self.fetchResults()
        }
    }

    var businesses: [Business]! {
        didSet {
            self.businessTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.businessTableView.dataSource = self
        self.businessTableView.rowHeight = UITableViewAutomaticDimension
        self.businessTableView.estimatedRowHeight = 120

        let searchBar = UISearchBar()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar

        self.fetchResults()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

    private func fetchResults() {
        let categories = self.filters.categories.map { (category: [String : String]) -> String in
            return category["code"]!
        }
        
        Business.searchWithTerm(
            self.searchTerm,
            sort: self.filters.sortBy.yelpSortMode(),
            categories: categories,
            deals: self.filters.dealsOnly,
            distance: self.filters.distance.meters(),
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
        })
    }
}

extension BusinessesViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let businesses = self.businesses else {
            return 0
        }

        return businesses.count
    }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters) {
        self.filters = filters
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchTerm = searchText
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
