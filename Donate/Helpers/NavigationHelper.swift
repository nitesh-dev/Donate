//
//  NavigationHelper.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 15/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import UIKit

struct NavigationHelper {
    
    static func navigationSettings(vc: UIViewController, title: String)
    {
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: String(title.split(separator: " ")[0]), attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 22)!])
        navTitle.append(NSMutableAttributedString(string: " " + String(title.split(separator: " ")[1]), attributes:[
            NSAttributedStringKey.font: UIFont(name: "OpenSans-Light", size: 22)!,
            NSAttributedStringKey.foregroundColor: UIColor.white]))
        navLabel.attributedText = navTitle
        vc.navigationItem.titleView = navLabel
    }
}
