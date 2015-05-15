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

    let APIKey = "AIzaSyDAimwxwKYyEVsVj-RC6qetSPqLK_lOnXg"
    let APISecret = ""
    
    @IBOutlet weak var tableView: UITableView!
    let locationManager = CLLocationManager()
    var latitude = ""
    var longitude = ""
    var filteredData: [String]!
    var searchController: UISearchController!
    var placesData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
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
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell") as! UITableViewCell
        cell.textLabel?.text = placesData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placesData.count
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        retreiveBusinesses(searchController.searchBar.text)
        tableView.reloadData()
    }
    
// MARK: Retreive Businesses Data from API
    
    func retreiveBusinesses(var keyword: String) {
        
        determineUserLocation()
        var keywordProtection = keyword.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        // Make sure Latitude + Longitude are set...
        let url = NSURL (string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(keywordProtection)&types=establishment&location=\(latitude),\(longitude)&radius=500&sensor=true&language=en&key=\(APIKey)")
    
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            
            if let jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as? NSDictionary {
                
                self.placesData = []
                if let predictions = jsonResult["predictions"] as? NSArray {
                    for item in predictions {
                        if let description = item["description"] as? String {
                            self.placesData.append(description)
                        }
                    }
                }
            }
        }
        
        task.resume()
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

