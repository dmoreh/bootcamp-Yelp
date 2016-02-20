//
//  FiltersTableViewDataSource.swift
//  Yelp
//
//  Created by Daniel Moreh on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

// TODO: What's a better name for this class? It's both a data source and a delegate. 
class FiltersTableViewDataSource: NSObject{
    var filters = Filters()
    private let tableStructure: [FilterType] = [.Deals, .Distance, .SortBy, .Category]
    weak var tableView: UITableView!
}

extension FiltersTableViewDataSource: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.tableStructure.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let filterType = self.tableStructure[section] 
        return filterType.rawValue
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterType = self.tableStructure[section]
        switch filterType {
        case .Deals:
            return 1
        case .Distance:
            return FilterDistance.cases().count
        case .SortBy:
            return FilterSortBy.cases().count
        case .Category:
            return Filters.allCategories().count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let filterType = self.tableStructure[indexPath.section]
        switch filterType {
        case .Deals:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a Deal"
            cell.onSwitch.on = self.filters.dealsOnly
            return cell
        case .Distance:
            let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "DefaultCell")
            let filterDistance = FilterDistance.cases()[indexPath.row]
            cell.textLabel?.text = filterDistance.rawValue
            cell.accessoryType = self.filters.distance == filterDistance ? .Checkmark : .None
            return cell
        case .SortBy:
            let cell = tableView.dequeueReusableCellWithIdentifier("DefaultCell") ?? UITableViewCell(style: .Default, reuseIdentifier: "DefaultCell")
            let filterSortBy = FilterSortBy.cases()[indexPath.row]
            cell.textLabel?.text = filterSortBy.rawValue
            cell.accessoryType = self.filters.sortBy == filterSortBy ? .Checkmark : .None
            return cell
        case .Category:
            let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            let categoryName = Filters.allCategories()[indexPath.row]["name"]
            cell.switchLabel.text = categoryName
            cell.onSwitch.on = self.filters.categories.contains({ (category: [String : String]) -> Bool in
                return category["name"] == categoryName
            })
            return cell
        }
    }
}

extension FiltersTableViewDataSource: UITableViewDelegate {
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        let filterType = self.tableStructure[indexPath.section]
        switch filterType {
        case .Distance, .SortBy:
            return true
        case .Deals, .Category:
            return false
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        let filterType = self.tableStructure[indexPath.section]
        switch filterType {
        case .Distance:
            self.filters.distance = FilterDistance.cases()[indexPath.row]
        case .SortBy:
            self.filters.sortBy = FilterSortBy.cases()[indexPath.row]
        case .Deals, .Category:
            return
        }

        tableView.reloadData()
    }
}