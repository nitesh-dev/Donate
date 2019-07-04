//
//  InitialViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 28/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit

class InitialViewController: UIViewController {

    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var findDonorBtn: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    @IBAction func findDonor(_ sender: UIButton) {
        
    }
    @IBAction func registerAsDonor(_ sender: UIButton) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        configureViews()
        setUpConstraints()
    }

    func configureViews()
    {
        backgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        self.view.addSubview(backgroundView)
        
        let image = UIImage(named: "diego-ph-254975-unsplash")
        backgroundImageView.image = image
        backgroundImageView.clipsToBounds = true
        
        findDonorBtn.buttonSetUp(title: "Find Donors")
        registerBtn.buttonSetUp(title: "Register / Sign In")
        
        titleText.font = UIFont(name: "OpenSans-Bold", size: 44)
        titleText.textColor = UIColor.white
        titleText.textAlignment = .center
        //titleText.attributedText = attributedText(withString: "DonateDrop", boldString: "Donate", font: UIFont(name: "OpenSans-Light", size: 44)!)
        titleText.setAttributedText(withString: "DonateDrop", boldString: "Donate", font: UIFont(name: "OpenSans-Light", size: 44)!)
        
        let attributedString = NSMutableAttributedString(string: "Save lives. Donate.  \nFind donors nearby.")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        attributedString.addAttribute(NSAttributedStringKey.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descriptionText.attributedText = attributedString
        descriptionText.font = UIFont(name: "OpenSans-Light", size: 16)
        descriptionText.textColor = UIColor.white
        descriptionText.textAlignment = .center
        descriptionText.numberOfLines = 0
        descriptionText.lineBreakMode = .byWordWrapping
        descriptionText.adjustsFontSizeToFitWidth = true
        descriptionText.minimumScaleFactor = 0.5
        
        descriptionText.sizeToFit()
        
        self.view.addSubview(descriptionText)
        self.view.addSubview(titleText)
        self.view.addSubview(findDonorBtn)
        self.view.addSubview(registerBtn)
        self.view.addSubview(backgroundImageView)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundImageView.layer.cornerRadius = backgroundImageView.frame.height / 2.0
        
        
        let borderWidth: CGFloat = 10.0
        
        backgroundImageView.layer.borderColor = UIColor.red.withAlphaComponent(0.4).cgColor
        backgroundImageView.layer.borderWidth = borderWidth
    }
    
    func setUpConstraints() {
        
        let modelName = UIDevice.modelName
        backgroundView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.view)
        }
       // let height = UIScreen.main.bounds.height * 0.10
        
        backgroundImageView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.top.greaterThanOrEqualTo(self.backgroundView.snp.top).offset(30)
            make.height.width.lessThanOrEqualTo(self.backgroundView.snp.width).multipliedBy(0.75)
        }
        var butttonHeight: CGFloat = 0.0
        if modelName.lowercased().contains("se") || modelName.lowercased().contains("5s")
        {
            butttonHeight = 50.0
        }
        else
        {
            butttonHeight = 60.0
        }
        registerBtn.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.backgroundView.snp.bottom).offset(-30)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(butttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        findDonorBtn.snp.makeConstraints {
            make in
            make.bottom.equalTo(self.registerBtn.snp.top).offset(-15)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.height.equalTo(butttonHeight)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
        }
        
        titleText.snp.makeConstraints {
            make in
            make.top.greaterThanOrEqualTo(self.backgroundImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
            make.height.lessThanOrEqualTo(60)
        }
        
        descriptionText.snp.makeConstraints {
            make in
            make.top.greaterThanOrEqualTo(self.titleText.snp.bottom).offset(10)
            make.centerX.equalTo(self.backgroundView.snp.centerX)
            make.leading.equalTo(self.backgroundView.snp.leading).offset(20)
            make.trailing.equalTo(self.backgroundView.snp.trailing).offset(-20)
            make.bottom.greaterThanOrEqualTo(self.findDonorBtn.snp.top).offset(-25)
        }
        
    }
}
extension UILabel {
    func setAttributedText(withString string: String, boldString: String, font: UIFont){
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        attributedText = attributedString
    }
}
