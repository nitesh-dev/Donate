//
//  AppointmentModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 21/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

struct Appointment{
    var createdBy: String
    var createdByName: String
    var date: String
    var eventName: String
    var isEvent: Bool
    var locationName: String
    var purpose: String
    var geoLocation: String
    var type: String
    let db = Firestore.firestore()
    
    var dictionary: [String: Any] {
        return [
            "createdBy": createdBy,
            "createdByName": createdByName,
            "date": date,
            "eventName": eventName,
            "isEvent": isEvent,
            "location": geoLocation,
            "locationName": locationName,
            "purpose": purpose,
            "type": type
        ]
    }
}

extension Appointment{
    init?(dictionary: [String : Any], userId: String) {
        guard  let _ = dictionary["createdBy"],
            let _ = dictionary["createdByName"],
            let _ = dictionary["date"],
            let _ = dictionary["eventName"],
            let _ = dictionary["isEvent"],
            let _ = dictionary["Hospital"],
            let _ = dictionary["location"],
            let _ = dictionary["locationName"],
            let _ = dictionary["purpose"],
            let _ = dictionary["type"]
            else { return nil }
        
        self.init(dictionary: dictionary, userId: userId)
    }
}
