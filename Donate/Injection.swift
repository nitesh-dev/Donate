//
//  Injection.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 29/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    #if DEBUG
    @objc func injected() {
    for subview in self.view.subviews {
    subview.removeFromSuperview()
    }
    
    viewDidLoad()
    }
    #endif
}
