//
//  RequestViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 01/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class RequestViewController: UIViewController//, PassDataDelegate
{
    
    
    var requestDict: [String: String] = [:]
    
    let scrollView = UIScrollView()
    let patientNameTF = UITextField()
    let quantityReqTF = UITextField()
    let ageTF = UITextField()
    let bloodGroupTF = UITextField()
    let contactTF = UITextField()
    let hospitalTF = UITextField()
    let genderTF = UITextField()
    let locationTF = UITextField()
    let saveButton = UIButton()
    let dateTF = UITextField()
    let patientDetailsLabel = UILabel()
    let generalDetailsLabel = UILabel()
    
    let mainStackView = UIStackView()
    let unitsStackView = UIStackView()
    let ageStackView = UIStackView()
    let bloodGroupPicker = UIPickerView()
    let genderPicker = UIPickerView()
    let bloodGroupPickerData = [String](arrayLiteral: "A+", "O+", "B+", "AB+", "A-", "O-", "B-", "AB-")
    let genderPickerData = [String](arrayLiteral: "Male", "Female")
    lazy var tfArray = [quantityReqTF, ageTF, bloodGroupTF,  patientNameTF, contactTF, dateTF, hospitalTF, locationTF, genderTF]
    
    var arrangedSubviews: [UIView] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NavigationHelper.navigationSettings(vc: self, title: "Request Blood")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(createRequest))
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([ NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 18)!], for: UIControlState.normal)
        
        dateTF.addTarget(self, action: #selector(self.openBloodGroupPicker(_:)), for: UIControlEvents.editingDidBegin)
        self.view.addSubview(scrollView)
        
        let textFieldColor = UIColor.red.withAlphaComponent(0.5)
        patientNameTF.customize(title: "Patient's Name", bgColor: textFieldColor, imageString: "user")
        quantityReqTF.customize(title: "Units Required", bgColor: textFieldColor, imageString: "request")
        ageTF.customize(title: "Patient's Age", bgColor: textFieldColor, imageString: "age")
        bloodGroupTF.customize(title: "Blood Group", bgColor: textFieldColor, imageString: "group")
        contactTF.customize(title: "Contact", bgColor: textFieldColor, imageString: "contact")
        hospitalTF.customize(title: "Hospital", bgColor: textFieldColor, imageString: "hospital")
        genderTF.customize(title: "Gender", bgColor: textFieldColor, imageString: "gender")
        locationTF.customize(title: "Location", bgColor: textFieldColor, imageString: "location")
        dateTF.customize(title: "Date", bgColor: textFieldColor, imageString: "date-25")
        
        
        tfArray.forEach({ $0.delegate = self})
        
        contactTF.tag = 3
        patientNameTF.tag = 4
        bloodGroupTF.inputView = bloodGroupPicker
        bloodGroupPicker.delegate = self
        bloodGroupPicker.backgroundColor = UIColor.white
        bloodGroupPicker.tag = 1
        
        genderTF.inputView = genderPicker
        genderPicker.delegate = self
        genderPicker.backgroundColor = UIColor.white
        genderPicker.tag = 2
        
        let font = UIFont(name: "OpenSans", size: 18)
        
        patientDetailsLabel.textColor = UIColor.white
        patientDetailsLabel.backgroundColor = UIColor.red.withAlphaComponent(0.25)
        patientDetailsLabel.text = "Patient's Details".uppercased()
        patientDetailsLabel.font = font
        patientDetailsLabel.textAlignment = .left
        
        generalDetailsLabel.textColor = UIColor.white
        generalDetailsLabel.backgroundColor = UIColor.red.withAlphaComponent(0.25)
        generalDetailsLabel.text = "General Details".uppercased()
        generalDetailsLabel.font = font
        generalDetailsLabel.textAlignment = .left
        
        
        
        arrangedSubviews = [patientDetailsLabel, patientNameTF, unitsStackView, ageStackView, contactTF, generalDetailsLabel, dateTF, hospitalTF, locationTF]
        
        unitsStackView.stackViewConfiguration(subviews: [quantityReqTF, bloodGroupTF], stackAxis: .horizontal, stackDistribution: .fillEqually, stackAlignment: .fill, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        ageStackView.stackViewConfiguration(subviews: [ageTF, genderTF], stackAxis: .horizontal, stackDistribution: .fillEqually, stackAlignment: .fill, stackLayoutMargins: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        mainStackView.stackViewConfiguration(subviews: arrangedSubviews, stackAxis: .vertical, stackDistribution: .fill, stackAlignment: .fill, stackLayoutMargins: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        self.scrollView.addSubview(mainStackView)
        constraintsAndPositionsForViews()
    }
    
    @objc func openBloodGroupPicker(_ sender: UITextField)
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
        dateTF.text = formatter.string(from: sender.date)
        dateTF.isUserInteractionEnabled = false
    }
    
    @objc func createRequest()
    {
        let valid = validateFields()
        
        if valid {
            let alert = UIAlertController(title: "Alert", message: "Please fill all required fields", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else {
            ////add logic to save data to firebase
            let request = PostFirestoreData()
            let userID : String = (Auth.auth().currentUser?.uid)!
            let requestDict = Request(age: ageTF.text!, bloodGroup: bloodGroupTF.text!, contact: contactTF.text!, gender: genderTF.text!, hospital: hospitalTF.text!, location: locationTF.text!, patient: patientNameTF.text!, quantityReq: quantityReqTF.text!, userId: userID)
            
            request.addDataToFireStore(requestDict: requestDict.dictionary)
            
            let alert = UIAlertController(title: "Success", message: "Your request for blood has been acknowledged", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {
                action in
                switch action.style{
                case .default:
                    self.dismiss(animated: true, completion: nil)

                case .cancel:
                    print("cancel")

                case .destructive:
                    print("destructive")
                }}))
            self.present(alert, animated: true, completion: nil)
            print(requestDict)
        }
    }
    
    func validateFields() -> Bool
    {
        let res = tfArray.map{$0.text?.count != 0}
        return res.contains(false)
    }

    func constraintsAndPositionsForViews()
    {
        scrollView.snp.makeConstraints {
            make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height)
        }
        mainStackView.snp.makeConstraints {
            make in
            make.leading.trailing.top.bottom.equalTo(scrollView)
        }
        mainStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1.0).isActive = true
 
        arrangedSubviews.forEach( {
            $0.snp.makeConstraints {
                make in
                make.height.greaterThanOrEqualTo(60)
            }
        })
        patientDetailsLabel.snp.makeConstraints {
            make in
            make.height.equalTo(30)
        }
        generalDetailsLabel.snp.makeConstraints {
            make in
            make.height.equalTo(30)
        }
    }
    
}

extension RequestViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return bloodGroupPickerData.count
        } else {
            return genderPickerData.count
        }
    }
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
           return bloodGroupPickerData[row]
        } else {
            return genderPickerData[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            bloodGroupTF.text = bloodGroupPickerData[row]
        } else {
            genderTF.text = genderPickerData[row]
        }
    }
}
extension RequestViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        let check = checkValidations(textField, string: result)
        return check
    }
    
    
    func checkValidations(_ textField: UITextField, string: String) -> Bool {
        if textField.tag == 3
        {
            let allowedCharacters = CharacterSet.decimalDigits
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet) && string.count <= 10
        }
        if textField.tag == 4 {
            return string.count <= 30
        }
        return true
    }
}
