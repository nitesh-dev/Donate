//
//  HospitalLocationDelegate.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 15/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import CoreLocation

protocol HospitalLocationDelegate: NSObjectProtocol {
    func loadMapViewWithLocation(withLocation location: CLLocation, isDonateView: Bool)
}
