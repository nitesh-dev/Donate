//
//  RequestDataModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 07/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Firebase

class PostFirestoreData {
    
    let db = Firestore.firestore()
    func addDataToFireStore(requestDict: [String: String])
    {
        var ref: DocumentReference? = nil
        ref = db.collection("bloodRequests").addDocument(data: requestDict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        let userID : String = (Auth.auth().currentUser?.uid)!
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData([
            "bloodRequestId": ref!.documentID
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func addAppointmentToFireStore(requestDict: [String: Any])
    {
        var ref: DocumentReference? = nil
        ref = db.collection("EventsAppointments").addDocument(data: requestDict) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        let userID : String = (Auth.auth().currentUser?.uid)!
        let userRef = db.collection("users").document(userID)
        
        userRef.updateData([
            "eventId": ref!.documentID
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    func editAppointment(requestDict: [String: Any], documentId: String) {
        let ref = db.collection("EventsAppointments").document(documentId)
        
        ref.updateData([
            "date": requestDict["date"] as Any,
            "eventName": requestDict["eventName"] as Any,
            "location": requestDict["location"] as Any,
            "locationName": requestDict["locationName"] as Any,
            "purpose": requestDict["purpose"] as Any
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
