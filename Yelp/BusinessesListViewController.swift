//
//  BusinessesListViewController.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/9/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import UIKit

import SVPullToRefresh

class BusinessesListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var businesses = [Business]()
    var rightBarButtonItem: UIBarButtonItem?
    var term = ""

    lazy var searchBar = UISearchBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.placeholder = "Search"
        searchBar.tintColor = UIColor.whiteColor()
        searchBar.text = term
        navigationItem.titleView = searchBar
        rightBarButtonItem = navigationItem.rightBarButtonItem

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        tableView.addInfiniteScrollingWithActionHandler({self.fetchMoreBusinesses()})

        if businesses.count == 0 {
            fetchBusinesses()
        } else {
            tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let businessesMapViewController =
            navigationController.topViewController as! BusinessesMapViewController
        businessesMapViewController.businesses = self.businesses
        businessesMapViewController.term = self.term
    }

    // MARK: - Helpers

    func fetchBusinesses() {
        YelpClient.sharedInstance.search(
            term,
            offset: 0,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        )
    }

    func fetchMoreBusinesses() {
        YelpClient.sharedInstance.search(
            term,
            offset: self.businesses.count,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses += businesses
                self.tableView.reloadData()
                self.tableView.infiniteScrollingView.stopAnimating()
            }
        )
    }

}

extension BusinessesListViewController: UITableViewDataSource {

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

extension BusinessesListViewController: UITableViewDelegate {

}

extension BusinessesListViewController: UISearchBarDelegate {

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = rightBarButtonItem
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        term = searchBar.text!
        fetchBusinesses()
        searchBar.showsCancelButton = false
        navigationItem.rightBarButtonItem = rightBarButtonItem
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem = nil
    }

}
