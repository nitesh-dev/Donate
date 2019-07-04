//
//  AppointmentCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 15/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit

class EventCell: UICollectionViewCell {
    
    
    let eventIcon = UIImageView()
    let eventNameLabel = UILabel()
    let eventDateLabel = UILabel()
    let orgaizerNameLabel = UILabel()
    let stackView = UIStackView()
    let cellBackgroundView = UIView()
    let expandButton = UIButton()
    
    //For Expanded Section
    let detailsIcon = UIImageView()
    let locationLabel = UILabel()
    let locationNameLabel = UILabel()
    let purposeLabel = UILabel()
    let expandedStackView = UIStackView()
    let expandedView = UIView()
    let pledgeButton = UIButton()
    let shareButton = UIButton()
    
    var isExpanded: Bool = false
    
    weak var delegate:ExpandedCellDelegate?
    public var indexPath:IndexPath!
    
    var cellHeight: CGFloat = 0
    var imageHeightAndWidth: CGFloat = 0
    
    override func awakeFromNib() {
        cellBackgroundView.layer.cornerRadius = 5.0
        cellBackgroundView.clipsToBounds = true
        self.addSubview(cellBackgroundView)
        
        eventIcon.image = UIImage(named: "event")?.withRenderingMode(.alwaysTemplate)
        eventIcon.tintColor = UIColor.white
        cellBackgroundView.addSubview(eventIcon)
        
        expandButton.addTarget(self, action: #selector(self.expandView(_:)), for: .touchUpInside)
        cellBackgroundView.addSubview(expandButton)
        
        eventDateLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        eventNameLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        orgaizerNameLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        
        stackView.stackViewConfiguration(subviews: [eventNameLabel, eventDateLabel, orgaizerNameLabel], stackAxis: .vertical, stackDistribution: .equalSpacing, stackAlignment: .leading, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        cellBackgroundView.addSubview(stackView)
    }
    
    @objc func expandView(_ sender: UIButton) {
        if let delegate = self.delegate{
            delegate.topButtonTouched(indexPath: indexPath)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isExpanded{
            expandButton.setImage(UIImage(named: "down-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
            expandButton.imageView?.tintColor = UIColor.white
        }
        else {
            expandButton.setImage(UIImage(named: "up-arrow")?.withRenderingMode(.alwaysTemplate), for: .normal)
            expandButton.imageView?.tintColor = UIColor.white
        }
        setupConstraintsForViews()
    }
    
    func createExpandedView()
    {
        locationNameLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        locationLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        purposeLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        purposeLabel.numberOfLines = 0
        purposeLabel.lineBreakMode = .byWordWrapping
        purposeLabel.adjustsFontSizeToFitWidth = true
        purposeLabel.minimumScaleFactor = 0.5
        
        expandedView.layer.cornerRadius = 5.0
        expandedView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        expandedView.clipsToBounds = true
        self.addSubview(expandedView)
        
        expandedStackView.stackViewConfiguration(subviews: [locationLabel, locationNameLabel, purposeLabel], stackAxis: .vertical, stackDistribution: .fillProportionally, stackAlignment: .leading, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        expandedView.addSubview(expandedStackView)
        
        //Expanded View Icon Setting
        detailsIcon.image = UIImage(named: "show")?.withRenderingMode(.alwaysTemplate)
        detailsIcon.tintColor = UIColor.white
        expandedView.addSubview(detailsIcon)
        
        //Expanded View Buttons Configuration
        pledgeButton.configureButton(title: "Interested")
        expandedView.addSubview(pledgeButton)
        shareButton.configureButton(title: "Share")
        expandedView.addSubview(shareButton)
        
        expandedView.snp.makeConstraints {
            make in
            make.right.left.equalTo(self)
            make.top.equalTo(cellBackgroundView.snp.bottom).offset(5)
            make.height.equalTo(300 - cellHeight - 8)
        }
        expandedStackView.snp.makeConstraints {
            make in
            make.top.equalTo(expandedView).offset(10)
            make.left.equalTo(expandedView).offset(70)
            make.right.equalTo(expandedView.snp.right).offset(-10)
            make.bottom.lessThanOrEqualTo(pledgeButton.snp.top).offset(-10)
        }
        detailsIcon.snp.makeConstraints {
            make in
            make.left.equalTo(self.snp.left).offset(10)
            make.width.height.equalTo(50)
            make.centerY.equalTo(expandedStackView.snp.centerY)
        }
        let width = self.bounds.width / 2 - 15
        pledgeButton.snp.makeConstraints {
            make in
            make.left.equalTo(self.snp.left).offset(10)
            make.width.equalTo(width)
            make.bottom.equalTo(self.expandedView.snp.bottom).offset(-10)
            make.height.equalTo(30)
        }
        shareButton.snp.makeConstraints {
            make in
            make.left.equalTo(pledgeButton.snp.right).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.bottom.equalTo(self.expandedView.snp.bottom).offset(-10)
            make.height.equalTo(30)
        }
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientColors = [UIColor.red.withAlphaComponent(0.2).cgColor, UIColor.red.cgColor]
        cellBackgroundView.setGradientColor(colors: gradientColors)
    }
    
    func configureCells(dataAtCurrentIndex: [String: Any])
    {
        if let dateString = dataAtCurrentIndex["date"] as? String {
            eventDateLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "clock"), title: dateString)
        }
        if let nameString = dataAtCurrentIndex["eventName"] as? String  {
            eventNameLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "date-25"), title: nameString)
        }
        if let organizerNameString = dataAtCurrentIndex["createdByName"] as? String  {
            orgaizerNameLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "user"), title: organizerNameString)
        }
        if let locationString = dataAtCurrentIndex["location"] as? String  {
            locationLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "location"), title: locationString)
        }
        if let locationNameString = dataAtCurrentIndex["locationName"] as? String  {
            locationNameLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "direction"), title: locationNameString)
        }
        if let purposeString = dataAtCurrentIndex["purpose"] as? String  {
            purposeLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "description"), title: purposeString)
        }
    }
    
    private func setupConstraintsForViews() {
        
        //        if isExpanded {
        //            imageHeightAndWidth = self.bounds.size.height * 0.25
        //        }
        //        else {
        imageHeightAndWidth = 50.0 //self.bounds.size.height * 0.5
        //}
        cellBackgroundView.snp.makeConstraints {
            make in
            make.top.left.equalTo(self)
            make.height.equalTo(cellHeight)
            make.right.equalTo(self.snp.right)
        }
        
        eventIcon.snp.makeConstraints {
            make in
            make.centerY.equalTo(cellBackgroundView.snp.centerY)
            make.left.equalTo(cellBackgroundView.snp.left).offset(10)
            make.width.height.equalTo(imageHeightAndWidth)
        }
        
        stackView.snp.makeConstraints {
            make in
            make.centerY.equalTo(cellBackgroundView.snp.centerY)
            make.left.equalTo(eventIcon.snp.right).offset(10)
            make.right.lessThanOrEqualTo(expandButton.snp.left).offset(-10)
        }
        expandButton.snp.makeConstraints {
            make in
            make.right.equalTo(cellBackgroundView.snp.right).offset(-10)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-10)
            make.width.height.equalTo(30)
        }
    }
}

