//
//  BusinessesMapViewController.swift
//  Yelp
//
//  Created by Xiaofei Long on 2/13/16.
//  Copyright © 2016 Xiaofei Long. All rights reserved.
//

import MapKit
import UIKit

class BusinessesMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

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

        let center = CLLocation(latitude: 37.785771, longitude: -122.406165)
        let span = MKCoordinateSpanMake(0.02, 0.02)
        mapView.setRegion(MKCoordinateRegionMake(center.coordinate, span), animated: false)

        updateAnnotations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let businessesListViewController =
        navigationController.topViewController as! BusinessesListViewController
        businessesListViewController.businesses = self.businesses
        businessesListViewController.term = self.term
    }

    // MARK: - Helpers

    func fetchBusinesses() {
        YelpClient.sharedInstance.search(
            term,
            offset: 0,
            completion: { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.updateAnnotations()
            }
        )
    }

    func updateAnnotations() {
        mapView.removeAnnotations(mapView.annotations)

        for business in businesses {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: business.latitude!,
                longitude: business.longitude!
            )
            annotation.title = business.name
            annotation.subtitle = business.address
            mapView.addAnnotation(annotation)
        }
    }

}

extension BusinessesMapViewController: UISearchBarDelegate {

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
