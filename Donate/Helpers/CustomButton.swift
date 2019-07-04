//
//  CustomButton.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 29/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor.red.withAlphaComponent(0.5) : (titleLabel?.text?.lowercased().contains("sign"))! ?  UIColor.white : UIColor.clear
            titleLabel?.textColor = isHighlighted ? UIColor.white : (titleLabel?.text?.lowercased().contains("sign"))! ?  UIColor.red.withAlphaComponent(0.5) : UIColor.white
        }
    }
}
extension UIButton {
    func buttonSetUp(title: String)
    {
        backgroundColor = title.lowercased().contains("sign") ? UIColor.white : UIColor.clear
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        setTitle(title, for: .normal)
        layer.cornerRadius = 5
        titleLabel?.font = UIFont(name: "OpenSans-Light", size: 24)
        setTitleColor(title.lowercased().contains("sign") ? UIColor.red.withAlphaComponent(0.5) : UIColor.white, for: .normal)
        //backgroundView.addSubview(button)
    }
}
