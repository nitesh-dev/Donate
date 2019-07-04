//
//  SettingsViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 21/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class SettingsViewController: UIViewController {
    
    let profileLabelsArray = ["Blood Group", "Age", "Contact"]
    let settingLabelsArray = ["Version", "Developer", "Log out"]
    
    let profileDetailArray = ["O+ve", "22", "8194859553"]
    let settingDetailArray = ["1.0.0", "Nitesh Singh","Logged In"]
    let profileImageView = UIImageView()
    let nameLabel = UILabel()
    
    @IBOutlet weak var settingsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(profileImageView)
        
        self.view.addSubview(nameLabel)
        nameLabel.text = "Nitesh Singh"
        nameLabel.textColor = UIColor.black
        nameLabel.font = UIFont(name: "OpenSans", size: 24)
        nameLabel.textAlignment = .center
        
        constraintsAndPositionsForViews()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.image = UIImage(named: "life")
        profileImageView.clipsToBounds = true
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        

    }
    
    
//    @objc func logout(_ sender: UIButton)
//    {
//        try! Auth.auth().signOut()
//
//        let vc = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: "welcomeController") as! InitialViewController
//        self.present(vc, animated: false, completion: nil)
//
//    }
    
    
    private func constraintsAndPositionsForViews()
    {
        let topOffset = self.view.bounds.height * 0.35
        settingsTableView.snp.makeConstraints {
            make in
            make.top.equalTo(self.view.snp.top).offset(topOffset)
            make.left.right.bottom.equalTo(self.view)
        }
        let imageWidthAndHeight = topOffset * 0.7
        profileImageView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(settingsTableView.snp.top).offset(-40)
            make.height.width.equalTo(imageWidthAndHeight)
        }
        nameLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.bottom.equalTo(settingsTableView.snp.top).offset(-5)
            make.top.lessThanOrEqualTo(profileImageView.snp.bottom).offset(5)
            make.width.equalTo(self.view.bounds.width)
        }
    }
}
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
           return "Profile Details"
        }
        else {
            return "App Details"
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int)
    {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "OpenSans", size: 14)!
        header.textLabel?.textColor = UIColor.lightGray
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        if indexPath.section == 0 {
        cell.textLabel?.text = profileLabelsArray[indexPath.row]
        cell.detailTextLabel?.text = profileDetailArray[indexPath.row]
        }
        else {
        cell.textLabel?.text = settingLabelsArray[indexPath.row]
        cell.detailTextLabel?.text = settingDetailArray[indexPath.row]
        }
        return cell
    }
}
extension UIImage {
    func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
}
