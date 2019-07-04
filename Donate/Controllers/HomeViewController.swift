//
//  HomeViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 30/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var dashboardView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var slidingCollectionView: UICollectionView!
    @IBOutlet weak var statsCollectionView: UICollectionView!
    
    @IBAction func openSettings(_ sender: UIBarButtonItem) {
        let settings = Storyboards.helperStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.settingsIdentifier)
        self.present(settings, animated: true, completion: nil)
    }
    let horizontalLine = UIView()
    
    let icons = [#imageLiteral(resourceName: "request"), #imageLiteral(resourceName: "donate"), #imageLiteral(resourceName: "hospital"), #imageLiteral(resourceName: "appointment"), #imageLiteral(resourceName: "event"), #imageLiteral(resourceName: "badge")]
    let titleArray = ["Request Blood", "Donate Blood", "Hospitals/ Bloodbanks Nearby", "Appointments", "Events", "Badges"]
    let countTitles = ["Litres Donated", "Lives Saved"]
    override func viewDidLoad() {
        super.viewDidLoad()
        slidingCollectionView.delegate = self
        slidingCollectionView.dataSource = self
        statsCollectionView.delegate = self
        statsCollectionView.dataSource = self
        
        self.view.addSubview(backgroundImageView)
        self.backgroundImageView.addSubview(backgroundView)
        self.backgroundView.addSubview(slidingCollectionView)
        self.backgroundView.addSubview(statsCollectionView)
        self.backgroundView.addSubview(horizontalLine)
        
        horizontalLine.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        backgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        backgroundImageView.isUserInteractionEnabled = true
        slidingCollectionView.backgroundColor = UIColor.clear
        statsCollectionView.backgroundColor = UIColor.clear
        
        self.backgroundView.addSubview(dashboardView)
        dashboardView.backgroundColor = UIColor.white
        configureConstraintsAndPositions()
        navigationSettings()
        dashboardViewSettings()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func dashboardViewSettings()
    {
        dashboardView.layer.cornerRadius = 5
        dashboardView.clipsToBounds = true
    }
    
    func navigationSettings()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.backgroundColor = UIColor.red.withAlphaComponent(0.5)
        
        let navLabel = UILabel()
        let navTitle = NSMutableAttributedString(string: "Drop", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "OpenSans", size: 22)!])
        
        navTitle.append(NSMutableAttributedString(string: "Donate", attributes:[
            NSAttributedStringKey.font: UIFont(name: "OpenSans-Light", size: 22)!,
            NSAttributedStringKey.foregroundColor: UIColor.white]))
        
        navLabel.attributedText = navTitle
        self.navigationItem.titleView = navLabel
        
        UIApplication.shared.statusBarStyle = .lightContent
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = UIColor.red.withAlphaComponent(0.5)
    }
    
    func configureConstraintsAndPositions()
    {
        backgroundImageView.snp.makeConstraints {
            make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset(64.0)//((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height)
        }
        backgroundView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self.backgroundImageView)
        }
        slidingCollectionView.snp.makeConstraints {
            make in
            make.left.right.bottom.equalTo(self.backgroundView)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.3)
        }
        dashboardView.snp.makeConstraints {
            make in
            make.bottom.equalTo(slidingCollectionView.snp.top).offset(-10)
            make.left.equalTo(self.backgroundView).offset(10)
            make.right.equalTo(self.backgroundView).offset(-10)
            make.height.lessThanOrEqualTo(self.view.snp.height).multipliedBy(0.3)
        }
        statsCollectionView.snp.makeConstraints {
            make in
         make.top.equalTo(self.backgroundView.snp.top)
            make.bottom.equalTo(self.dashboardView.snp.top).offset(-10)
            make.left.right.equalTo(self.backgroundView)
        }
        horizontalLine.snp.makeConstraints {
            make in
            make.height.equalTo(1)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.9)
            make.centerX.equalTo(self.view.snp.centerX)
           make.top.equalTo(self.backgroundView.snp.top)
        }
    }
    
}
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 100
        {
            return titleArray.count
        }
        if collectionView.tag == 200
        {
            return 2
        }
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 100
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.slidingCellIdentifier, for: indexPath) as! HomeSlidingViewCell
            cell.iconImageView.image = icons[indexPath.item].withRenderingMode(.alwaysTemplate)
            cell.iconImageView.tintColor = UIColor.white.withAlphaComponent(0.8)
            cell.descriptionLabel.text = titleArray[indexPath.item]
            cell.tag = indexPath.item
            return cell
        }
        if collectionView.tag == 200
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.statsCellIdentifier, for: indexPath) as! HomeStatsViewCell
            cell.descriptionLabel.text = countTitles[indexPath.item]
            //cell.countLabel.text = "45"
            cell.countView.image = indexPath.item == 0 ?  #imageLiteral(resourceName: "blood").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "lifeicon").withRenderingMode(.alwaysTemplate)
            cell.countView.tintColor = UIColor.white.withAlphaComponent(0.8)
            cell.backgroundColor = UIColor.clear
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 5
            cell.cellBackgroundImageView.image = indexPath.item == 0 ?  #imageLiteral(resourceName: "livessaved") : #imageLiteral(resourceName: "livessaved")
            return cell
        }
        return UICollectionViewCell()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView.tag == 100
        {
            let cellsAcross: CGFloat = 2.5
            var widthRemainingForCellContent = collectionView.bounds.width
            if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
                let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
                widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
            }
            let cellWidth = widthRemainingForCellContent / cellsAcross
            
            
            return CGSize(width: cellWidth, height: collectionView.bounds.height - 20)
        }
        
        if collectionView.tag == 200 {
            
            let padding: CGFloat =  50
            let collectionViewSize = collectionView.frame.size.width - padding
            
            return CGSize(width: collectionViewSize / 2, height: collectionViewSize / 2)
        }
        return CGSize()
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        switch cell.tag {
        
        case 0:
            let presentingVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.requestIdentifier)
            self.navigationController?.pushViewController(presentingVC, animated: true)
        case 1:
            let presentingVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.donateIdentifier)
            self.navigationController?.pushViewController(presentingVC, animated: true)
        case 2:
            let presentingVC = Storyboards.mainStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.hospitalIdentifier)
            self.navigationController?.pushViewController(presentingVC, animated: true)
        case 3:
            let presentingVC = Storyboards.helperStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.appointmentIdentifier) as! AppointmentController
            presentingVC.type = AppConstants.appointmentType
            self.navigationController?.pushViewController(presentingVC, animated: true)
        default:
            let presentingVC = Storyboards.helperStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.appointmentIdentifier) as! AppointmentController
            presentingVC.type = AppConstants.eventType
            self.navigationController?.pushViewController(presentingVC, animated: true)
        }
    }
}
