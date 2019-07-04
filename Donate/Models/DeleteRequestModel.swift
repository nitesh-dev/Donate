//
//  DeleteRequestModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 28/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class DeleteRequestModel {
    let db = Firestore.firestore()
    //var dict = [[String: Any]]()
    
    enum DeleteResult {
        case success(String)
        case catchFailure(Error)
        case failure(String)
    }
    
    func deleteAppointmentFromFirebase(appointmentID: String, completionHandler: @escaping (DeleteResult) -> ()) {
        db.collection("EventsAppointments").document(appointmentID).delete() { err in
            if let err = err {
                completionHandler(.failure(err.localizedDescription))
                print("Error removing document: \(err)")
            } else {
                completionHandler(.success("Successfull"))
                print("Document successfully removed!")
            }
        }
    }
}
