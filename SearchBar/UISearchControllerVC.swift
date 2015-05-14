//
//  MyViewController.swift
//  SearchBar
//
//  Created by Serguei Vinnitskii on 5/11/15.
//  Copyright (c) 2015 Kartoshka. All rights reserved.
//

import UIKit
import CoreLocation

class UISearchControllerVC: UIViewController, UITableViewDataSource, UISearchResultsUpdating, CLLocationManagerDelegate {

    let APIKey = ""
    let APISecret = ""
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitude = ""
    var filteredData: [String]!
    var searchController: UISearchController!
    
    let data = ["New York, NY", "Los Angeles, CA", "Chicago, IL", "Houston, TX",
        "Philadelphia, PA", "Phoenix, AZ", "San Diego, CA", "San Antonio, TX",
        "Dallas, TX", "Detroit, MI", "San Jose, CA", "Indianapolis, IN",
        "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
        "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        filteredData = data
        
        // Initializing with searchResultsController set to nil means that
        // searchController will use this view controller to display the search results
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        
        // If we are using this same view controller to present the results
        // dimming it out wouldn't make sense.  Should set probably only set
        // this to yes if using another controller to display the search results.
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
        
        self.determineUserLocation()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as! UITableViewCell
        cell.textLabel?.text = filteredData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        
        filteredData = searchText.isEmpty ? data : data.filter({(dataString: String) -> Bool in
            return dataString.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
        })
        
        
        
        tableView.reloadData()
    }
// MARK: Retreive Businesses Data from API
    
    func retreiveBusinesses(keyword: String) {
        
        
        
    }
    
// MARK: CoreLocation services
    
    func determineUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation() // don't forget to stop...
    }
    
    // coreLocation delegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        latitude = "\(locationObj.coordinate.latitude)"
        longitude = "\(locationObj.coordinate.longitude)"
        
        println(latitude)
        println(longitude)
        
        // Stopping
        locationManager.stopUpdatingLocation()
    }
    
    // authorization status
    var locationStatus = "Not Started"
    func locationManager(manager: CLLocationManager!,
        didChangeAuthorizationStatus status: CLAuthorizationStatus) {
            
            switch status {
            case CLAuthorizationStatus.Restricted:
                locationStatus = "Restricted Access to location"
            case CLAuthorizationStatus.Denied:
                locationStatus = "User denied access to location"
            case CLAuthorizationStatus.NotDetermined:
                locationStatus = "Status not determined"
            default:
                locationStatus = "Allowed to location Access"
            }
    }
    
    
}

