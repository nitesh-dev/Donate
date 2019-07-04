//
//  DashboardView.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 30/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit

class DashboardView: UIView {

    let label = UILabel()
    override func draw(_ rect: CGRect) {
        self.addSubview(label)
        label.snp.makeConstraints {
            make in
            make.left.top.equalTo(self).offset(20)
            make.height.equalTo(40)
            make.width.equalTo(self.snp.width).multipliedBy(0.8)
        }
        label.font = UIFont(name: "OpenSans-Light", size: 20)
        label.text = "Appointments"
        label.textColor = UIColor.black
        label.sizeToFit()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        updateMask()
    }
    
    private func updateMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x:0, y:0))
        path.addLine(to: CGPoint(x: (bounds.size.width / 2) - 40, y: 0))
        path.addLine(to: CGPoint(x: (bounds.size.width / 2) - 30, y: 10))
        path.addLine(to: CGPoint(x: (bounds.size.width / 2) + 20, y: 10))
        
        path.addLine(to: CGPoint(x: (bounds.size.width / 2) + 30, y: 0))
        
        path.addLine(to: CGPoint(x: bounds.size.width, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width , y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0 , y: bounds.size.height))
        path.close()
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

}
