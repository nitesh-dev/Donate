//
//  DonateViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 05/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation

class DonateViewController: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    let locationManager = CLLocationManager()
    weak var locationDelegate: HospitalLocationDelegate?
    var currLoc = CLLocation()
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private lazy var requestListControlelr: RequestListViewController = {
        
        var viewController = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: "RequestListVC") as! RequestListViewController
        
        return viewController
    }()
    
    private lazy var locationsViewController: LocationsViewController = {
        var viewController = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: "LocationsVC") as! LocationsViewController
        
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
        NavigationHelper.navigationSettings(vc: self, title: "Donate Blood")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "filter"), style: .plain, target: self, action: #selector(createRequest))
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        
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
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if segmentControl.selectedSegmentIndex == 0 {
            remove(asChildViewController: locationsViewController)
            add(asChildViewController: requestListControlelr)
        } else {
            remove(asChildViewController: requestListControlelr)
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
extension DonateViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error::: \(error)")
        locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
            NotificationCenter.default.post(name: Notification.Name("DisplayData"), object: nil)
        }
        if status == .denied {
            openSettingsForLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            self.locationDelegate = locationsViewController
            locationDelegate?.loadMapViewWithLocation(withLocation: location, isDonateView: true)
        }
    }
}
