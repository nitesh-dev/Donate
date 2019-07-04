//
//  RequestTableCellTableViewCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 01/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit

protocol PassDataDelegate: AnyObject {
    func passDataToController(key: Int, value: String, fireStoreKeyName: String)
}

class RequestTableCell: UITableViewCell {

    var textField = UITextField()
    var picker = UIPickerView()
    var pickerData: [String] = []
    var placeholderArray: [String] = []
    weak var delegate: PassDataDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picker.delegate = self
        picker.dataSource = self
        textFieldSetUp()
        setConstraitsForViews()
        picker.backgroundColor = UIColor.white
    }
    
    func textFieldSetUp()
    {
        self.addSubview(textField)
        textField.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        textField.tintColor = UIColor.red.withAlphaComponent(0.5)
        textField.textColor = UIColor.white
        textField.font = UIFont(name: "OpenSans-Light", size: 20)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.white.cgColor
        textField.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textField.delegate = self
        textField.autocorrectionType = .no
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        if textField.tag == 2 || textField.tag == 4
        {
           textField.inputView = picker
           textField.tintColor = UIColor.clear
         }
    }
    func setConstraitsForViews() {
        textField.snp.makeConstraints {
            make in
            make.left.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
            make.bottom.equalTo(self)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
extension RequestTableCell: UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource
{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        textField.text = pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        let titleData = pickerData[row]
        let pickerValue = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "OpenSans", size: 22.0)!,NSAttributedStringKey.foregroundColor: UIColor.black])
        pickerLabel.attributedText = pickerValue
        pickerLabel.textAlignment = .center
        return pickerLabel
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string

        let check = checkValidations(textField, string: result)
        let fireStoreFieldName = textField.placeholder!.replacingOccurrences(of: " ", with: "")
        delegate?.passDataToController(key:textField.tag, value: result, fireStoreKeyName: fireStoreFieldName.replacingOccurrences(of: "*", with: ""))
        return check
    }
    
    func checkValidations(_ textField: UITextField, string: String) -> Bool {
        var boolVal = true
        if textField.tag == 2 || textField.tag == 4
        {
            boolVal = false
            textField.resignFirstResponder()
            return boolVal
        }
        if textField.tag == 1 || textField.tag == 5 || textField.tag == 7
        {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(textField.text?.isEmpty)! {
            let text = placeholderArray[textField.tag].contains("*") ? String(placeholderArray[textField.tag].dropLast(2)) :placeholderArray[textField.tag]
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: text.width(withConstrainedHeight: 0, font: UIFont(name: "OpenSans", size: 20)! ) + 20, height: textField.bounds.height))
        
        let label = UILabel(frame: CGRect(x: 10, y: 0, width: text.width(withConstrainedHeight: 0, font: UIFont(name: "OpenSans", size: 22)!), height: textField.bounds.height ))
        label.font = UIFont(name: "OpenSans", size: 20)!
        label.text = text
        label.textColor = UIColor.white
        label.textAlignment = .left
        leftView.addSubview(label)
        
        textField.leftView = leftView
        textField.leftViewMode = .always
        }
        if textField.text != ""{
        print("Hello \(textField.placeholder!)")
        let fireStoreFieldName = textField.placeholder!.replacingOccurrences(of: " ", with: "")
            delegate?.passDataToController(key:textField.tag, value: textField.text!, fireStoreKeyName: fireStoreFieldName.replacingOccurrences(of: "*", with: ""))
        }
    }
}
extension String {
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
