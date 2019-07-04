//
//  AppConstants.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 13/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import UIKit

struct AppConstants {
    static let eventType = "Events"
    static let appointmentType = "Appointments"
    static var userName = ""
    
    struct Controller {
        static let requestIdentifier = "requestController"
        static let donateIdentifier = "donateController"
        static let hospitalIdentifier = "hospitalController"
        static let mapLocationController = "LocationsVC"
        static let hospitalTableController = "HBBTableVC"
        static let homeViewController =  "homeController"
        static let appointmentIdentifier = "appointmentController"
        static let createAppointmentController = "CreateAppointmentController"
        static let settingsIdentifier = "settingsController"
    }
    
    struct Cells {
        static let appointmentIdentifier = "AppointmentCell"
        static let hospitalCellIdentifier = "HospitalCell"
        static let donateCellIdentifier = "DonateCell"
        static let requestCellIdentifier = "RequestCell"
        static let slidingCellIdentifier = "SlidingCell"
        static let statsCellIdentifier = "StatsCell"
        static let eventIdentifier = "EventCell"
    }
}
struct Storyboards {
        static let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        static let helperStoryboard = UIStoryboard(name: "HelperStoryboard", bundle: Bundle.main)
}

