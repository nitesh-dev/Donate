//
//  UserModel.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 30/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation

struct User{
    var userName:String
    var userId: String
    
    var dictionary: [String: Any] {
        return [
            "userName": userName,
            "userId": userId
        ]
    }
}

extension User{
    init?(dictionary: [String : Any], id: String) {
        guard   let userName = dictionary["userName"] as? String,
            let id = dictionary["userId"] as? String
            else { return nil }
        
        self.init(userName: userName, userId: id)
    }
}
