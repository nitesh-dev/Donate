//
//  RegisterDonorController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 29/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
import FirebaseFirestore

class RegisterDonorController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var registerDonorBtn: UIButton!
    @IBOutlet weak var userSignIn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    var databaseRef: DatabaseReference?
    var databaseHandler: DatabaseHandle?
    
    let db = Firestore.firestore()
    
    
    @IBAction func registerToBase(_ sender: Any) {
        
               // databaseRef = Database.database().reference()
                Auth.auth().createUser(withEmail: emailTF.text!, password: passwordTF.text!){ (user, error) in
                    if error == nil {
                        let userID : String = (Auth.auth().currentUser?.uid)!
                        
                        let userData: [String: Any] = [
                            "userName": self.nameTF.text as Any,
                            "userEmail": self.emailTF.text as Any
                        ]
                        self.db.collection("users").document(userID).setData(userData) { err in
                            if let err = err {
                                print("Error writing document: \(err)")
                            } else {
                                AppConstants.userName = userData["userName"] as! String
                                print("Document successfully written!")
                            }
                        }
                        
                        let newViewController = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.homeViewController)
                        self.present(newViewController, animated: true, completion: nil)
                        
                        let alertController = UIAlertController(title: "Success", message: userID, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                        

                    }
                    else{
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
            }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAllViews()
        configureViewsAndConstraints()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func setUpAllViews()
    {
        //      backgroundImageView.image = #imageLiteral(resourceName: "hope")
        self.view.addSubview(backgroundImageView)
        backgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        backgroundImageView.addSubview(backgroundView)
        
        registerDonorBtn.buttonSetUp(title: "Register")
        userSignIn.buttonSetUp(title: "Sign-in")
        
        backgroundImageView.isUserInteractionEnabled = true
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "OpenSans-Bold", size: 44)
        titleLabel.textColor = UIColor.white
        titleLabel.setAttributedText(withString: "Register as Donor", boldString: "Register", font: UIFont(name: "OpenSans-Light", size: 44)!)
        titleLabel.sizeToFit()
        titleLabel.adjustsFontSizeToFitWidth = true
        emailTF.textFieldSetUp(withTitle: "E-mail Address")
        passwordTF.textFieldSetUp(withTitle: "Password")
        nameTF.textFieldSetUp(withTitle: "Name")
        
        nameTF.delegate = self
        passwordTF.delegate = self
        emailTF.delegate = self
        
    }
    
    
    func configureViewsAndConstraints()
    {
        let model = UIDevice.modelName
        
        let buttonHeight = model.lowercased().contains("se") || model.lowercased().contains("5s") ? 50 : 60
        backgroundImageView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.view)
        }
        backgroundView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.backgroundImageView)
        }
        
        passwordTF.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.registerDonorBtn.snp.top).offset(-50)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        emailTF.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.passwordTF.snp.top).offset(-10)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        
        nameTF.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.emailTF.snp.top).offset(-10)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        userSignIn.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.backgroundView.snp.bottom).offset(-30)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        registerDonorBtn.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.userSignIn.snp.top).offset(-10)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(buttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        
        titleLabel.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.nameTF.snp.top).offset(-60)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(60)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        
    }
}
extension UITextField {
    func textFieldSetUp(withTitle title: String)
    {
        backgroundColor = UIColor.white.withAlphaComponent(0.1)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = 5
        attributedPlaceholder = NSAttributedString(string: title, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white.withAlphaComponent(0.5), NSAttributedStringKey.font :UIFont(name: "OpenSans-Light", size: 20)!])
        textColor = UIColor.white
        font = UIFont(name: "OpenSans-Light", size: 20)!
        tintColor = UIColor.red.withAlphaComponent(0.5)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
