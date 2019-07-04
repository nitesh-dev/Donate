//
//  DonateCollectionCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 06/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit

class DonateCollectionCell: UICollectionViewCell {
    
    let bloodGroupLabel = UILabel()
    let bgView = UIView()
    let unitsRequiredLabel = UILabel()
    let cellBackgroundView = UIView()
    let dateLabel = UILabel()
    let titleLabel = UILabel()
    let locationButton = UIButton()
    let stackView = UIStackView()
    let distanceLabel = UILabel()
    
    override func awakeFromNib() {
        cellBackgroundView.layer.cornerRadius = 5.0
        cellBackgroundView.clipsToBounds = true
        self.addSubview(cellBackgroundView)
        
        cellBackgroundView.addSubview(bgView)
        bgView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        bgView.layer.cornerRadius = 5.0
        
        bloodGroupLabel.textColor = UIColor.white
        bloodGroupLabel.textAlignment = .center
        bloodGroupLabel.font = UIFont(name: "OpenSans-Semibold", size: 24)!
        bgView.addSubview(bloodGroupLabel)
        bgView.addSubview(unitsRequiredLabel)
        unitsRequiredLabel.textAlignment = .center
        
        setUpLabels(titleLabel, font: UIFont(name: "OpenSans", size: 14)!)
        titleLabel.textAlignment = .left
        setUpLabels(unitsRequiredLabel, font: UIFont(name: "OpenSans", size: 14)!)
        setUpLabels(distanceLabel, font: UIFont(name: "OpenSans", size: 14)!)
        distanceLabel.textAlignment = .left
        
        setUpLabels(dateLabel, font: UIFont(name: "OpenSans", size: 14)!)
        
        stackView.stackViewConfiguration(subviews: [titleLabel, dateLabel, distanceLabel], stackAxis: .vertical, stackDistribution: .fillEqually, stackAlignment: .leading, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        self.addSubview(stackView)
        //stackView.addBackground(color: UIColor.red)
        locationButton.setImage(UIImage(named: "direction")?.withRenderingMode(.alwaysTemplate), for: .normal)
        locationButton.imageView?.tintColor = UIColor.white
        cellBackgroundView.addSubview(locationButton)
        setupConstraintsForViews()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.layer.shadowOpacity = 0.4
//        self.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.layer.shadowRadius = 5
//        self.layer.shadowColor = UIColor.black.cgColor
//        self.layer.masksToBounds = false
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        bloodGroupLabel.clipsToBounds = true
        bloodGroupLabel.layer.cornerRadius = 5.0

        let lineLayer = CAShapeLayer()
        lineLayer.strokeColor = UIColor.white.cgColor
        lineLayer.lineWidth = 1
        lineLayer.lineDashPattern = [4,4]
        let path = CGMutablePath()
        path.addLines(between: [CGPoint(x: cellBackgroundView.frame.width -  locationButton.frame.width - 15, y: self.cellBackgroundView.bounds.origin.y + 10),
                                CGPoint(x: cellBackgroundView.frame.width - locationButton.frame.width - 15, y: self.cellBackgroundView.bounds.height - 10)])
        lineLayer.path = path
        self.cellBackgroundView.layer.addSublayer(lineLayer)
        locationButton.centerVertically()
        
        
        let gradient: CAGradientLayer = CAGradientLayer()
        
        gradient.colors = [UIColor.red.withAlphaComponent(0.2).cgColor, UIColor.red.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = self.cellBackgroundView.bounds
        
        self.cellBackgroundView.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setUpLabels(_ label: UILabel, font: UIFont) {
        label.textColor = UIColor.white
        //label.textAlignment = .left
        label.font = font
        //label.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    private func setLabelImageAttachment(for label: UILabel, image: UIImage, title: String)
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
        label.attributedText = completeText
    }
    
    func configureCells(dataAtCurrentIndex: [String: Any])
    {
        if let dateString = dataAtCurrentIndex["Hospital"] as? String {
            setLabelImageAttachment(for: dateLabel, image: #imageLiteral(resourceName: "date-25"), title: dateString)
        }
        if let unitsRequiredString = dataAtCurrentIndex["QuantityRequired"] as? String  {
            //setLabelImageAttachment(for: unitsRequiredLabel, image: #imageLiteral(resourceName: "request"), title: unitsRequiredString + " Units")
            self.unitsRequiredLabel.text = unitsRequiredString + " Units"
        }
        if let patientNameString = dataAtCurrentIndex["PatientName"] as? String  {
            setLabelImageAttachment(for: titleLabel, image: #imageLiteral(resourceName: "user"), title: patientNameString)
        }
        if let location = dataAtCurrentIndex["Location"] as? String  {
            setLabelImageAttachment(for: distanceLabel, image: #imageLiteral(resourceName: "location"), title: location)
        }
        self.bloodGroupLabel.text = dataAtCurrentIndex["BloodGroup"] as? String
    }
    
    private func setupConstraintsForViews() {
        
        cellBackgroundView.snp.makeConstraints {
            make in
            make.top.bottom.left.equalTo(self)
            make.right.equalTo(self.snp.right)
        }
        
        bgView.snp.makeConstraints {
            make in
            make.top.left.equalTo(cellBackgroundView).offset(10)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-10)
            make.width.equalTo(self.snp.width).multipliedBy(0.2)
        }
        unitsRequiredLabel.snp.makeConstraints {
            make in
            make.left.equalTo(bgView.snp.left)
            make.bottom.equalTo(bgView.snp.bottom)
            make.width.equalTo(bgView.snp.width)
            make.height.equalTo(30)
        }
        bloodGroupLabel.snp.makeConstraints {
            make in
            make.top.equalTo(bgView.snp.top).offset(10)
            make.bottom.equalTo(unitsRequiredLabel.snp.top)
            make.width.equalTo(bgView.snp.width).multipliedBy(0.9)
            make.centerX.equalTo(bgView.snp.centerX)
        }
        locationButton.snp.makeConstraints {
            make in
            make.right.equalTo(cellBackgroundView.snp.right).offset(-10)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-15)
            make.top.equalTo(cellBackgroundView.snp.top).offset(15)
            make.width.equalTo(60)
        }
        stackView.snp.makeConstraints {
            make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(bgView.snp.right).offset(10)
            make.right.lessThanOrEqualTo(locationButton.snp.left).offset(-10)
            make.top.lessThanOrEqualTo(self.snp.top).offset(10)
            make.bottom.lessThanOrEqualTo(self.snp.bottom).offset(-10)
        }
    }
}
extension UIButton {
    
    func centerVertically(padding: CGFloat = 6.0) {
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + padding
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 10.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height / 2),
            right: 0.0
        )
        
        self.contentEdgeInsets = UIEdgeInsets(
            top: 10.0,
            left: 0.0,
            bottom: titleLabelSize.height / 2,
            right: 0.0
        )
    }
}
