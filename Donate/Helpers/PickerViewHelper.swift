//
//  PickerViewHelper.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 01/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import Foundation
import UIKit

class PickerViewHelper : UIPickerView, UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    
    var pickerData : [String]!
    var pickerTextField : UITextField!
    
    init(pickerData: [String], dropdownField: UITextField) {
        super.init(frame: CGRect.zero)
        
        self.pickerData = pickerData
        self.pickerTextField = dropdownField
        
        self.delegate = self
        self.dataSource = self
        
        DispatchQueue.async(dispatch_get_main_queue(), {
            if pickerData.count &gt; 0 {
                self.pickerTextField.text = self.pickerData[0]
                self.pickerTextField.enabled = true
            } else {
                self.pickerTextField.text = nil
                self.pickerTextField.enabled = false
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -&gt; String? {
    return pickerData[row]
    }
    
    // When user selects an option, this function will set the text of the text field to reflect
    // the selected option.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickerData[row]
    }
    
    
}
