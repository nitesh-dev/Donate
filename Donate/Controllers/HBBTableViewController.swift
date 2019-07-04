//
//  HBBTableViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 13/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import NVActivityIndicatorView

class HBBTableViewController: UIViewController {

    @IBOutlet weak var hbTableView: UITableView!
    let initialLocation = CLLocation(latitude: 50.7275, longitude: 2.5426)
    //50.7275° N, 2.5426° E
    let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(13.0827, 80.2707)
    var hospitalNames = [String]()
    var hospitalLocation = [String]()
    
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.red, padding: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpConstraintsAndPositions()
        self.view.addSubview(activityIndicatorView)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayDataOnlyWhenLocationAuthorized(notification:)), name: Notification.Name("DisplayNearbyHospitals"), object: nil)
        hbTableView.isHidden = true
        let offset = UIScreen.main.bounds.height - view.bounds.height
        self.activityIndicatorView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(-offset)
        }
        activityIndicatorView.startAnimating()
        
    }
    @objc func displayDataOnlyWhenLocationAuthorized(notification: Notification) {
        let span = MKCoordinateSpanMake(10.0, 10.0)
        
        if let location = notification.userInfo?["location"] as? CLLocation {
            
            let coordinateRegion = MKCoordinateRegion.init(center: location.coordinate, span: span)
            searchBy(naturalLanguageQuery: "hospital", region: coordinateRegion, coordinates: location.coordinate, completionHandler: {
                response, error in
                
                if response != nil {
                    
                    for item in response!.mapItems {
                        
                        let coordinate = item.placemark.coordinate
                        let getLat: CLLocationDegrees = coordinate.latitude
                        let getLon: CLLocationDegrees = coordinate.longitude
                        let hosCoordinates: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
                        var distanceInMeters = hosCoordinates.distance(from: location) as Double
                        var unitString = " meters away"
                        
                        if distanceInMeters > 1000 {
                            distanceInMeters = distanceInMeters / 1000
                            unitString = " kms away"
                        }
                        let completeDistanceString = distanceInMeters.rounded(toPlaces: 1).description
                        
                        
                        self.hospitalNames.append(item.name!)
                        if let subLocality = item.placemark.subLocality {
                            self.hospitalLocation.append(subLocality + "  \u{2219}  " + completeDistanceString + unitString)
                        }
                        else if let thoroughFare = item.placemark.thoroughfare {
                            self.hospitalLocation.append(thoroughFare + "  \u{2219} " + completeDistanceString + unitString)
                        }
                        else {
                            self.hospitalLocation.append(completeDistanceString + unitString)
                        }
                        
                    }
                    self.hbTableView.isHidden = false
                    self.activityIndicatorView.stopAnimating()
                    self.hbTableView.reloadData()
                }
            })
        }
    }
    private func setUpConstraintsAndPositions()
    {
        hbTableView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.view)
        }
    }
    func searchBy(naturalLanguageQuery: String, region: MKCoordinateRegion, coordinates: CLLocationCoordinate2D, completionHandler: @escaping (_ response: MKLocalSearchResponse?, _ error: NSError?) -> Void) {
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = naturalLanguageQuery
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                completionHandler(nil, error as NSError?)
                
                return
            }
            
            completionHandler(response, error as NSError?)
        }
    }
}
extension HBBTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return hospitalNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AppConstants.Cells.hospitalCellIdentifier, for: indexPath)
        if hospitalNames.count != 0 {
            cell.textLabel?.font = UIFont(name: "OpenSans", size: 17)
            cell.detailTextLabel?.font = UIFont(name: "OpenSans-Light", size: 12)
            cell.textLabel?.text = hospitalNames[indexPath.row]
            cell.detailTextLabel?.text = hospitalLocation[indexPath.row]
        }
        return cell
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
