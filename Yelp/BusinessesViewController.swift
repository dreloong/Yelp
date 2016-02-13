//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/9/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var businesses = [Business]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    var term = "" {
        didSet {
            fetchBusinesses()
        }
    }

    lazy var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.tintColor = UIColor.whiteColor()
        navigationItem.titleView = searchBar

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        term = ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Helpers

    func fetchBusinesses() {
        Business.searchWithTerm(
            term,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
            }
        )
    }

}

extension BusinessesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }

    func tableView(
        tableView: UITableView,
        cellForRowAtIndexPath indexPath: NSIndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(
            "Business Cell",
            forIndexPath: indexPath
        ) as! BusinessTableViewCell

        cell.business = businesses[indexPath.row]
        return cell
    }

}

extension BusinessesViewController: UITableViewDelegate {

}

extension BusinessesViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        term = searchBar.text!
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

}
