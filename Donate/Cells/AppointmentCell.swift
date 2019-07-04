//
//  AppointmentCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 15/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import PMAlertController

protocol ExpandedCellDelegate: NSObjectProtocol {
    func topButtonTouched(indexPath:IndexPath)
}
protocol ShowAlertDelegate: NSObjectProtocol {
    func showCustomAlert(appointmentIdToDelete: String)
}
protocol EditAppointmentDelegate: NSObjectProtocol {
    func editAppointment(withAppointmentID id: String, dict: [String: Any])
}

class AppointmentCell: UICollectionViewCell {
    
    let hospitalIcon = UIImageView()
    let appointmentNameLabel = UILabel()
    let appointmentDateLabel = UILabel()
    let stackView = UIStackView()
    let cellBackgroundView = UIView()
    let expandButton = UIButton()
    let reminderLabel = UILabel()
    let checkedButton = UIButton()
    
    //For Expanded Section
    let detailsIcon = UIImageView()
    let locationLabel = UILabel()
    let purposeLabel = UILabel()
    let expandedStackView = UIStackView()
    let expandedView = UIView()
    let editButton = UIButton()
    let deleteButton = UIButton()
    let doneButton = UIButton()
    let buttonsStackView = UIStackView()
    
    var isExpanded: Bool = false
    var appointmentId = ""
    var currentDataDict: [String: Any] = [:]
    
    weak var delegate: ExpandedCellDelegate?
    weak var alertDelegate: ShowAlertDelegate?
    weak var editDelegate: EditAppointmentDelegate?
    public var indexPath:IndexPath!
    
    var cellHeight: CGFloat = 0
    var imageHeightAndWidth: CGFloat = 0
    
    override func awakeFromNib() {
        cellBackgroundView.layer.cornerRadius = 5.0
        cellBackgroundView.clipsToBounds = true
        self.addSubview(cellBackgroundView)
        
        hospitalIcon.image = UIImage(named: "appointment")?.withRenderingMode(.alwaysTemplate)
        hospitalIcon.tintColor = UIColor.white
        cellBackgroundView.addSubview(hospitalIcon)
        
        expandButton.addTarget(self, action: #selector(self.expandView(_:)), for: .touchUpInside)
        cellBackgroundView.addSubview(expandButton)
        
        //checkedButton.addTarget(self, action: #selector(self.expandView(_:)), for: .touchUpInside)
        cellBackgroundView.addSubview(checkedButton)
        checkedButton.setImage(UIImage(named: "ok")?.withRenderingMode(.alwaysTemplate), for: .normal)
        checkedButton.imageView?.tintColor = UIColor.white
        checkedButton.isHidden = true
        
        appointmentNameLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        appointmentDateLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        reminderLabel.configureLabel(with: UIFont(name: "OpenSans", size: 14)!)
        
        
        stackView.stackViewConfiguration(subviews: [appointmentNameLabel, appointmentDateLabel, reminderLabel], stackAxis: .vertical, stackDistribution: .equalSpacing, stackAlignment: .leading, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
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
        
        expandedStackView.stackViewConfiguration(subviews: [locationLabel, purposeLabel], stackAxis: .vertical, stackDistribution: .fillProportionally, stackAlignment: .leading, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        expandedView.addSubview(expandedStackView)
        
        detailsIcon.image = UIImage(named: "show")?.withRenderingMode(.alwaysTemplate)
        detailsIcon.tintColor = UIColor.white
        expandedView.addSubview(detailsIcon)
        
        doneButton.configureButton(title: "Done")
        doneButton.addTarget(self, action: #selector(self.markAsDone(_:)), for: .touchUpInside)
        editButton.configureButton(title: "Edit")
        editButton.addTarget(self, action: #selector(self.editAppointment(_:)), for: .touchUpInside)
        deleteButton.configureButton(title: "Delete")
        deleteButton.addTarget(self, action: #selector(self.deleteAppointment(_:)), for: .touchUpInside)
        
        expandedView.addSubview(buttonsStackView)
        buttonsStackView.stackViewConfiguration(subviews: [editButton, doneButton, deleteButton], stackAxis: .horizontal, stackDistribution: .fillEqually, stackAlignment: .fill, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
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
            make.bottom.lessThanOrEqualTo(buttonsStackView.snp.top).offset(-10)
        }
        detailsIcon.snp.makeConstraints {
            make in
            make.left.equalTo(self.snp.left).offset(10)
            make.width.height.equalTo(50)
            make.centerY.equalTo(expandedStackView.snp.centerY)
        }
        buttonsStackView.snp.makeConstraints {
            make in
            make.left.equalTo(self.snp.left).offset(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(30)
            make.bottom.equalTo(expandedView.snp.bottom).offset(-10)
        }
    }
    
    @objc func deleteAppointment(_ sender: UIButton) {
        if let delegate = self.alertDelegate{
            delegate.showCustomAlert(appointmentIdToDelete: appointmentId)
        }
    }
    @objc func editAppointment(_ sender: UIButton) {
        if let delegate = self.editDelegate{
            delegate.editAppointment(withAppointmentID: appointmentId, dict: currentDataDict)
        }
    }
    @objc func markAsDone(_ sender: UIButton) {
        doneButton.isEnabled = false
        //doneButton.backgroundColor = UIColor.green
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientColors = [UIColor.red.withAlphaComponent(0.2).cgColor, UIColor.red.cgColor]
        cellBackgroundView.setGradientColor(colors: gradientColors)
    }
    
    func configureCells(dataAtCurrentIndex: [String: Any])
    {
        currentDataDict = dataAtCurrentIndex
        if let dateString = dataAtCurrentIndex["date"] as? String {
            appointmentDateLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "clock"), title: dateString)
        }
        if let nameString = dataAtCurrentIndex["eventName"] as? String  {
           appointmentNameLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "date-25"), title: nameString)
        }
        if let locationString = dataAtCurrentIndex["location"] as? String  {
           locationLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "location"), title: locationString)
        }
        if let purposeString = dataAtCurrentIndex["purpose"] as? String  {
           purposeLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "description"), title: purposeString)
        }
        if let reminderString = dataAtCurrentIndex["type"] as? String  {
           reminderLabel.setLabelImageAttachment(image: #imageLiteral(resourceName: "reminder"), title: reminderString)
        }
        if let id = dataAtCurrentIndex["appointmentId"] as? String  {
            appointmentId = id
        }
        if let done = dataAtCurrentIndex["isDone"] as? Bool {
            if done == true {
                checkedButton.isHidden = false
                editButton.isEnabled = false
            }
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
        
        hospitalIcon.snp.makeConstraints {
            make in
            make.centerY.equalTo(cellBackgroundView.snp.centerY)
            make.left.equalTo(cellBackgroundView.snp.left).offset(10)
            make.width.height.equalTo(imageHeightAndWidth)
        }
        
        stackView.snp.makeConstraints {
            make in
            make.centerY.equalTo(cellBackgroundView.snp.centerY)
            make.left.equalTo(hospitalIcon.snp.right).offset(10)
        }
        expandButton.snp.makeConstraints {
            make in
            make.right.equalTo(cellBackgroundView.snp.right).offset(-10)
            make.bottom.equalTo(cellBackgroundView.snp.bottom).offset(-10)
            make.width.height.equalTo(20)
        }
        checkedButton.snp.makeConstraints {
            make in
            make.right.equalTo(cellBackgroundView.snp.right).offset(-10)
            make.top.equalTo(cellBackgroundView.snp.top).offset(10)
            make.width.height.equalTo(30)
        }
    }
}
