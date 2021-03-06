//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Daniel Moreh on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: Filters)
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let filters = Filters()
    private let tableStructure: [FilterType] = [.Deals, .Distance, .SortBy, .Category]
    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

    @IBAction func didTapCancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func didTapSearch(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.filtersViewController?(self, didUpdateFilters: self.filters)
    }
}

extension FiltersViewController: UITableViewDataSource {
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
            cell.delegate = self
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
            cell.delegate = self
            cell.switchLabel.text = categoryName
            cell.onSwitch.on = self.filters.categories.contains({ (category: [String : String]) -> Bool in
                return category["name"] == categoryName
            })
            return cell
        }
    }
}

extension FiltersViewController: UITableViewDelegate {
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

extension FiltersViewController: SwitchCellDelegate {
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = self.tableView.indexPathForCell(switchCell)!
        let filterType = self.tableStructure[indexPath.section]
        switch filterType {
        case .Deals:
            self.filters.dealsOnly = value
        case .Category:
            self.filters.categories.append(Filters.allCategories()[indexPath.row])
        case .Distance, .SortBy:
            break
        }

    }
}