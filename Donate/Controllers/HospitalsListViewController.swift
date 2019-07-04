//
//  HospitalsListViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 13/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import CoreLocation

class HospitalsListViewController: UIViewController {

    let locationManager = CLLocationManager()
    weak var locationDelegate: HospitalLocationDelegate?
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var hospitalTableController: HBBTableViewController = {
        var viewController = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.hospitalTableController) as! HBBTableViewController
        
        return viewController
    }()
    
    private lazy var locationsViewController: LocationsViewController = {
        var viewController = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.mapLocationController) as! LocationsViewController

        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentControl.setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white], for: .selected)
        
        constraintsAndPositionsForViews()
        //Setting up navigation bar title and right button
        NavigationHelper.navigationSettings(vc: self, title: "Hospitals Nearby")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(createRequest))
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        //adding a new child controller on existing controller
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.segmentControl.snp.bottom).offset(10)
        }
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        //removing child controller from existing controller
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: locationsViewController)
            add(asChildViewController: hospitalTableController)
        } else {
            remove(asChildViewController: hospitalTableController)
            add(asChildViewController: locationsViewController)
        }
    }
    
    func constraintsAndPositionsForViews() {
        segmentControl.snp.makeConstraints {
            make in
            make.top.equalTo(self.view.snp.top).offset((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height + 10)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
    }
    
    @objc func createRequest() {
        
    }
    
    func openSettingsForLocation() {
        let alert = UIAlertController(title: "Go To Settings", message: "Oops! It seems like you've not provided your location, please grant location access", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { action in
            UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
extension HospitalsListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error::: \(error)")
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
        if status == .denied {
            openSettingsForLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            let locDict = [ "location": location]

            NotificationCenter.default.post(name: Notification.Name("DisplayNearbyHospitals"), object: nil, userInfo: locDict)
            print("Hello Location \(location)")
            self.locationDelegate = locationsViewController
            locationDelegate?.loadMapViewWithLocation(withLocation: location, isDonateView: false)
        }
    }
}
