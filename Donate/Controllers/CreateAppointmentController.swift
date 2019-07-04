//
//  CreateAppointmentControllerViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 19/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import FirebaseAuth
import PMAlertController

class CreateAppointmentController: UIViewController {
    
    let topStackView = UIStackView()
    let middleStackView = UIStackView()
    let bottomStackView = UIStackView()
    let eventNameTF = UITextField()
    let eventDateTF = UITextField()
    let locationName = UITextField()
    let eventPurpose = UITextView()
    let eventGeoLoc = UITextField()
    let titleLabel = UILabel()
    let mainStackView = UIStackView()
    let saveButton = UIButton()
    let cancelButton = UIButton()
    var type: String = ""
    var isEdit = false
    var appointmentDict: [String: Any] = [:]
    var appointmentId: String = ""
    var editedAppointmentDict: [String: Any] = [:]
    
    lazy var tfArray = [eventNameTF, eventDateTF, locationName, eventGeoLoc]
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAllViews()
        self.view.blurredBackground(color: UIColor.red, below: mainStackView)
        setStackViews()
        setupConstraintsForViews()
        if isEdit == true && appointmentDict.count != 0 {
            populateFieldsIfEditing(appointmentId: appointmentId, appointmentDict: appointmentDict)
        }
    }
    
    private func populateFieldsIfEditing(appointmentId: String, appointmentDict: [String: Any])
    {
        if let dateString = appointmentDict["date"] as? String {
            eventDateTF.text = dateString
        }
        if let nameString = appointmentDict["eventName"] as? String  {
            eventNameTF.text = nameString
        }
        if let locationNameString = appointmentDict["locationName"] as? String  {
            locationName.text = locationNameString
        }
        if let purposeString = appointmentDict["purpose"] as? String  {
            eventPurpose.text = purposeString
        }
        if let locationString = appointmentDict["location"] as? String  {
            eventGeoLoc.text = locationString
        }

    }
    
    private func setStackViews() {
        
        //Setting all the stackviews here, mainStackView is the background stack view, on the top of which, there are 3 stack views i.e topStackView, middleStackView and bottomStackView
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        
        mainStackView.stackViewConfiguration(subviews: [topStackView, middleStackView, bottomStackView], stackAxis: .vertical, stackDistribution: .fill, stackAlignment: .fill, stackLayoutMargins: edgeInsets)
        self.view.addSubview(mainStackView)
        
        topStackView.stackViewConfiguration(subviews: [titleLabel, eventNameTF, eventDateTF, locationName, eventGeoLoc], stackAxis: .vertical, stackDistribution: .fillEqually, stackAlignment: .center, stackLayoutMargins: edgeInsets)
        
        middleStackView.stackViewConfiguration(subviews: [eventPurpose], stackAxis: .vertical, stackDistribution: .fillEqually, stackAlignment: .center, stackLayoutMargins: edgeInsets)
        
        bottomStackView.stackViewConfiguration(subviews: [saveButton, cancelButton], stackAxis: .horizontal, stackDistribution: .fillEqually, stackAlignment: .center, stackLayoutMargins: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    }
    private func setUpAllViews(){
        
        //Title configurations
        titleLabel.textColor = UIColor.white
        titleLabel.setAttributedText(withString: !isEdit ? "Create " +  type: "Edit " +  type, boldString: !isEdit ? "Create": "Edit", font: UIFont(name: "OpenSans-Light", size: 24)!)
        titleLabel.textAlignment = .center
        
        //Textfield configurations
        eventDateTF.customize(title: type + " Date", bgColor: UIColor.white.withAlphaComponent(0.5), imageString: "date-25")
        eventDateTF.tag = 7
        eventDateTF.delegate = self
        eventNameTF.customize(title: type + " Name", bgColor: UIColor.white.withAlphaComponent(0.5), imageString: "appointment")
        eventNameTF.tag = 5
        eventNameTF.delegate = self
        eventDateTF.addTarget(self, action: #selector(self.openPicker(_:)), for: UIControlEvents.touchDown)
        
        eventGeoLoc.customize(title: "Geolocation", bgColor: UIColor.white.withAlphaComponent(0.5), imageString: "direction")
        eventGeoLoc.tag = 8
        eventGeoLoc.delegate = self
        locationName.customize(title: "Location Name", bgColor: UIColor.white.withAlphaComponent(0.5), imageString: "location")
        locationName.tag = 6
        locationName.delegate = self
        
        //Event Purpose TextView configurations
        eventPurpose.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        eventPurpose.tintColor = UIColor.red.withAlphaComponent(0.5)
        eventPurpose.textColor = UIColor.white
        eventPurpose.font = UIFont(name: "OpenSans-Light", size: 20)
        eventPurpose.autocorrectionType = .no
        eventPurpose.layer.cornerRadius = 5.0
        eventPurpose.delegate = self
        
        //SAVE Button configurations
        saveButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        saveButton.layer.cornerRadius = 5.0
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(UIColor.white, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 20)
        saveButton.addTarget(self, action: #selector(self.saveAppointment(_:)), for: .touchUpInside)
        
        //Cancel Button configurations
        cancelButton.backgroundColor = UIColor.red
        cancelButton.layer.cornerRadius = 5.0
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.white, for: .normal)
        cancelButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 20)
        cancelButton.addTarget(self, action: #selector(self.pressButton(_:)), for: .touchUpInside)
    }
    
    @objc func openPicker(_ sender: UITextField)
    {
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = .dateAndTime
        datePickerView.backgroundColor = UIColor.white
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(handleDatePicker(sender:)), for: .valueChanged)
    }
    
    @objc func handleDatePicker(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a 'on' MMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        eventDateTF.text = formatter.string(from: sender.date)
        eventDateTF.isUserInteractionEnabled = false
    }
    
    @objc func pressButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name("CloseChildView"), object: nil)
    }
    
    private func validateFields() -> Bool {
        let res = tfArray.map{$0.text?.count != 0}
        return res.contains(false)
    }
    
    @objc func saveAppointment(_ sender: UIButton) {
        
        let ifInvalid = validateFields()
        
        if ifInvalid {
            let alertVC = PMAlertController(title: "Alert", description: "Please fill all required fields", image: UIImage(named: "alert"), style: .alert)
            alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
                print("Cancel")
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
        else {
            let userID : String = (Auth.auth().currentUser?.uid)!
            let request = PostFirestoreData()
            
            if isEdit {
                editedAppointmentDict["location"] = eventGeoLoc.text!
                editedAppointmentDict["eventName"] = eventNameTF.text!
                editedAppointmentDict["locationName"] = locationName.text!
                editedAppointmentDict["date"] = eventDateTF.text!
                editedAppointmentDict["purpose"] = eventPurpose.text!
                request.editAppointment(requestDict: editedAppointmentDict, documentId: appointmentId)
            }
            else {
                let requestDict = Appointment(createdBy: userID, createdByName: "Nitesh Singh", date: eventDateTF.text!, eventName: eventNameTF.text!, isEvent: false, locationName: locationName.text!, purpose: eventPurpose.text!, geoLocation: eventGeoLoc.text!, type: type)
                request.addAppointmentToFireStore(requestDict: requestDict.dictionary)
            }
            
            let alertVC = PMAlertController(title: "Success", description: "Appointment created", image: UIImage(named: "checked"), style: .alert)
            
            alertVC.addAction(PMAlertAction(title: "Okay", style: .cancel, action: { () -> Void in
                NotificationCenter.default.post(name: Notification.Name("CloseChildView"), object: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    private func setupConstraintsForViews() {
        
        mainStackView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        topStackView.snp.makeConstraints { make in
            make.height.equalTo(self.view.snp.height).multipliedBy(0.6)
        }
        middleStackView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(self.view.snp.height).multipliedBy(0.22)
        }
        bottomStackView.snp.makeConstraints { make in
            make.height.lessThanOrEqualTo(self.view.snp.height).multipliedBy(0.18)
        }
        eventDateTF.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
        }
        eventNameTF.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
        }
        eventGeoLoc.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
        }
        locationName.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
        }
        titleLabel.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
        }
        eventPurpose.snp.makeConstraints {
            make in
            make.left.equalTo(topStackView.snp.left).offset(10)
            make.right.equalTo(topStackView.snp.right).offset(-10)
            
        }
        saveButton.snp.makeConstraints {
            make in
            make.height.equalTo(bottomStackView.snp.height)
        }
        cancelButton.snp.makeConstraints {
            make in
            make.height.equalTo(bottomStackView.snp.height)
        }
    }
}

extension CreateAppointmentController: UITextFieldDelegate, UITextViewDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
//        if isEdit {
//            switch textField.tag
//            {
//            case 5: editedAppointmentDict["eventName"] = result
//            case 6: editedAppointmentDict["locationName"] = result
//            case 7: editedAppointmentDict["date"] = result
//            case 8: editedAppointmentDict["location"] = result
//            default: break
//            }
//        }
        
        let check = checkValidations(textField, string: result)
        return check
    }
    
    func checkValidations(_ textField: UITextField, string: String) -> Bool {
        if textField.tag == 5 || textField.tag == 6
        {
            return string.count <= 30
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        if isEdit {
//            editedAppointmentDict["purpose"] = newText
//        }
        let numberOfChars = newText.count
        return numberOfChars <= 100
    }
}
