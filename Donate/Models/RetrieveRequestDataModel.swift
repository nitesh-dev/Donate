//
//  RetrieveRequestDataModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 07/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class RetrieveRequestDataModel {
    
    let db = Firestore.firestore()
    var dict = [[String: Any]]()
    
    enum DownloadResult {
        case success([[String: Any]])
        case catchFailure(Error)
        case failure(String)
    }
    enum UserNameResult {
        case success(String)
        case catchFailure(Error)
        case failure(String)
    }
 
    
    func getRequestsFromFirebase(completionHandler: @escaping (DownloadResult) -> ())
    {
        db.collection("bloodRequests").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(.failure(err.localizedDescription))
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    self.dict.append(document.data())
                }
                completionHandler(.success(self.dict))
            }
        }
    }
    func getAppointmentsAndEventsFromFirebase(type: String, completionHandler: @escaping (DownloadResult) -> ())
    {
         db.collection("EventsAppointments").whereField("type", isEqualTo: type).addSnapshotListener { (documentSnapshot, err) in
            
            guard let document = documentSnapshot else {
                if let err = err {
                print("Error getting documents: \(err)")
                completionHandler(.failure(err.localizedDescription))
                }
                return
            }
            self.dict = []
            var docId = [String]()
                for doc in document.documents {
                    
                    if !docId.contains(doc.documentID){
                    print("\(doc.documentID) => \(doc.data())")
                    var dictionary = doc.data()
                    dictionary["appointmentId"] = doc.documentID
                    self.dict.append(dictionary)
                    docId.append(doc.documentID)
                    }
                }
                completionHandler(.success(self.dict))
        }
    }
    func getUserName(userId: String, completionHandler: @escaping (UserNameResult) -> ()) {
        let docRef = db.collection("users").document(userId)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                if let dataDescription = document.data() {
                    completionHandler(.success(dataDescription["userName"] as! String))
                }
            } else {
                completionHandler(.failure("Error"))
                print("Document does not exist")
            }
        }
    }
}
