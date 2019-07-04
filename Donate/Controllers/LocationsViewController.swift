//
//  LocationsViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 06/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import MapKit
import Contacts

class LocationsViewController: UIViewController, MKMapViewDelegate, HospitalLocationDelegate {
    
    func loadMapViewWithLocation(withLocation location: CLLocation, isDonateView: Bool) {
        if isDonateView == true {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            locationsMapView.setRegion(region, animated: true)
            let coordinate2D: CLLocationCoordinate2D = location.coordinate
            startPlottingAnnotationsOnMap(withRegion: region, andCoordinate: coordinate2D)
        }
        else {
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            locationsMapView.setRegion(region, animated: true)
            let coordinate2D: CLLocationCoordinate2D = location.coordinate
            startPlottingAnnotationsOnMap(withRegion: region, andCoordinate: coordinate2D)
        }
    }
    
    var personalLocation = CLLocation()
    let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(13.0827, 80.2707)
    let searchRadius: CLLocationDistance = 2000
    private var mapChangedFromUserInteraction = false
    @IBOutlet weak var locationsMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(locationsMapView)
        setUpConstraintsAndPositions()
        locationsMapView.delegate = self
        
    }
    
    func startPlottingAnnotationsOnMap(withRegion region: MKCoordinateRegion, andCoordinate coordinate: CLLocationCoordinate2D) {
        searchBy(naturalLanguageQuery: "hospital", region: region, coordinates: coordinate, completionHandler: {
            response, error in
            
            if response != nil {
                for item in response!.mapItems {
                    
                    self.addPinToMapView(title: item.name, address: (item.placemark.thoroughfare != nil) ? item.placemark.thoroughfare!: "", latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                }
            }
        })
    }
    
    func addPinToMapView(title: String?, address: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        if let title = title {
            let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            
            
            let artwork = CustomAnnotation(title: title, locationName: address, discipline: "Sculpture", coordinate: location)
            locationsMapView.addAnnotation(artwork)
        }
    }
    
    func setUpConstraintsAndPositions() {
        locationsMapView.snp.makeConstraints { make in
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
    
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.locationsMapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizerState.began || recognizer.state == UIGestureRecognizerState.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            let allAnnotations = locationsMapView.annotations
            let customAnnotations = allAnnotations.filter{ $0.isKind(of: CustomAnnotation.self)}.map{$0 as! CustomAnnotation}
            let coordinateRegion = locationsMapView.region
            searchBy(naturalLanguageQuery: "hospital", region: coordinateRegion, coordinates: coordinateRegion.center, completionHandler: {
                response, error in
                
                if response != nil {
                    
                    for item in response!.mapItems {
                        
                        if customAnnotations.first(where: {$0.coordinate.latitude == item.placemark.coordinate.latitude && $0.coordinate.longitude == item.placemark.coordinate.longitude}) == nil {
                            
                            DispatchQueue.global(qos: .userInteractive).async {
                                self.addPinToMapView(title: item.name, address: (item.placemark.thoroughfare != nil) ? item.placemark.thoroughfare!: "", latitude: item.placemark.location!.coordinate.latitude, longitude: item.placemark.location!.coordinate.longitude)
                            }
                        }
                    }
                }
            })
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            print("Annotations removed")
        }
    }
    
}
extension LocationsViewController {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! CustomAnnotation
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        location.mapItem().openInMaps(launchOptions: launchOptions)
    }
}
extension MKMapView {
    func visibleAnnotations() -> [MKAnnotation] {
        return self.annotations(in: self.visibleMapRect).map { obj -> MKAnnotation in return obj as! MKAnnotation }
    }
}
extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}
