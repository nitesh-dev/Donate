//
//  RequestModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 21/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation

struct Request{
    var age:String
    var bloodGroup: String
    var contact: String
    var gender: String
    var hospital: String
    var location: String
    var patient: String
    var quantityReq: String
    var userId: String
    
    var dictionary: [String: String] {
        return [
            "Age": age,
            "BloodGroup": bloodGroup,
            "Contact": contact,
            "Gender": gender,
            "Hospital": hospital,
            "Location": location,
            "PatientName": patient,
            "QuantityRequired": quantityReq,
            "userID": userId
        ]
    }
}

extension Request{
    init?(dictionary: [String : String], userId: String) {
        guard  let _ = dictionary["Age"],
            let _ = dictionary["BloodGroup"],
            let _ = dictionary["Gender"],
            let _ = dictionary["Contact"],
            let _ = dictionary["Hospital"],
            let _ = dictionary["Location"],
            let _ = dictionary["PatientName"],
            let _ = dictionary["QuantityRequired"]
            else { return nil }

        self.init(dictionary: dictionary, userId: userId)
    }
}

