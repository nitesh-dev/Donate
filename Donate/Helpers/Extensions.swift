//
//  Extensions.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 21/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {
    func addBackground(color: UIColor) {
        let subview = UIView(frame: bounds)
        subview.backgroundColor = color
        subview.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subview, at: 0)
    }
    
    func stackViewConfiguration(subviews: [UIView], stackAxis: UILayoutConstraintAxis, stackDistribution: UIStackViewDistribution, stackAlignment: UIStackViewAlignment, stackLayoutMargins: UIEdgeInsets  ) {
        axis  = stackAxis
        distribution  = stackDistribution
        alignment = stackAlignment
        spacing = 10.0
        subviews.forEach { self.addArrangedSubview($0)}
        layoutMargins = stackLayoutMargins
        isLayoutMarginsRelativeArrangement = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
extension UIView {
    func blurredBackground(color: UIColor, below: UIView) {
        backgroundColor = UIColor.red
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.insertSubview(blurEffectView, belowSubview: below)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5.0
    }
    
    func setGradientColor(colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = colors
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: 0)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 10, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        layer.cornerRadius = 5.0
    }
}
extension UITextField {
    func customize(title: String, bgColor: UIColor, imageString: String)
    {
        backgroundColor = bgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        
        paddingView.backgroundColor = UIColor.clear
        let imageView = UIImageView(frame: CGRect(x: 12.5, y: 12.5, width: 25, height: 25))
        let image = UIImage(named: imageString)?.withRenderingMode(.alwaysTemplate)
        imageView.image = image
        imageView.tintColor = UIColor.white
        paddingView.addSubview(imageView)
        
        leftView = paddingView
        leftViewMode = .always
        tintColor = UIColor.red.withAlphaComponent(0.5)
        textColor = UIColor.white
        font = UIFont(name: "OpenSans-Light", size: 20)
        contentVerticalAlignment = UIControlContentVerticalAlignment.center
        autocorrectionType = .no
        layer.cornerRadius = 5.0
        attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.8), NSAttributedStringKey.font :UIFont(name: "OpenSans-Light", size: 20)!])
    }
}
extension UILabel {
    func setLabelImageAttachment(image: UIImage, title: String)
    {
        let templateImage = image.withRenderingMode(.alwaysTemplate)
        let textAttachment = NSTextAttachment()
        textAttachment.image = templateImage
        let imageOffsetY:CGFloat = -2.0
        textAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 15, height: 15)
        let attributedStringWithImage = NSAttributedString(attachment: textAttachment)
        let completeText = NSMutableAttributedString(string: " ")
        completeText.append(attributedStringWithImage)
        let  textAfterIcon = NSMutableAttributedString(string: "  " + title)
        completeText.append(textAfterIcon)
        completeText.addAttribute(
            NSAttributedStringKey.foregroundColor,
            value: UIColor.white,
            range: NSMakeRange(
                0, 2))
        attributedText = completeText
    }
    func configureLabel(with fonts: UIFont) {
        textColor = UIColor.white
        textAlignment = .left
        font = fonts
    }
}
extension UIButton {
    func configureButton(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 16)
        backgroundColor = UIColor.red
        layer.cornerRadius = 5.0
        clipsToBounds = true
    }
}
