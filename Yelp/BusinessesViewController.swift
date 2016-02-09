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

    var businesses = [Business]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Business.searchWithTerm(
            "Thai",
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
