//
//  AppointmentController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 15/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import PMAlertController

class AppointmentController: UIViewController {
    
    @IBOutlet weak var appSegmentedControl: UISegmentedControl!
    @IBOutlet weak var appointmentCollectionView: UICollectionView!
    @IBOutlet weak var appointmentView: UIView!
    
    var cellWidth:CGFloat{
        return appointmentCollectionView.frame.size.width
    }
    var expandedHeight : CGFloat = 200
    var notExpandedHeight : CGFloat = 50
    var cellHeight: CGFloat = 0
    var isExpanded = [Bool]()
    
    var type: String = ""
    
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.red, padding: 0)
    
    var appointmentEventDict = [[String: Any]]()
    let blurView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if type == AppConstants.eventType {
        appointmentCollectionView.register(UINib(nibName: "EventCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.closeChildView(notification:)), name: Notification.Name("CloseChildView"), object: nil)
        createConstraints()
        NavigationHelper.navigationSettings(vc: self, title: "Your " + type)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createEventAppointment))
        appointmentView.isHidden = true
        self.view.addSubview(activityIndicatorView)
        constraintsAndPositionsForViews()
        activityIndicatorView.startAnimating()
        
        let request = RetrieveRequestDataModel()
        request.getAppointmentsAndEventsFromFirebase(type: String(type.dropLast()), completionHandler:{ result in
            
            switch result {
            case .success(let requestedDictFromFirebase):
                
                self.appointmentEventDict = requestedDictFromFirebase
                self.activityIndicatorView.stopAnimating()
                self.appointmentCollectionView.reloadData()
                self.isExpanded = Array(repeating: false, count: self.appointmentEventDict.count)
            case .failure(let error): print(error)
            case .catchFailure : print("Please try again")
            }
        })
        appSegmentedControl.isHidden = true
    }
    private func createConstraints() {
        appointmentView.snp.makeConstraints { make in
            make.width.equalTo(self.view.snp.width).multipliedBy(0.8)
            make.height.equalTo(self.view.snp.height).multipliedBy(0.7)
            make.center.equalTo(self.view.snp.center)
        }
    }
    
    @objc func closeChildView(notification: Notification) {
        self.childViewControllers.forEach({
            $0.willMove(toParentViewController: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParentViewController()
        })
        blurView.subviews.forEach({
            $0.removeFromSuperview()
        })
        blurView.removeFromSuperview()
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    private func appointmentViewLayout()
    {
        view.addSubview(appointmentView)
        createConstraints()
        
        let window = UIApplication.shared.keyWindow!
        blurView.frame = window.bounds
        view.addSubview(blurView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.addSubview(blurEffectView)
        
        blurView.backgroundColor = UIColor.clear
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        appointmentView.isHidden = false
    }
    
    @objc func createEventAppointment()
    {
        appointmentViewLayout()
        guard let childVC =  Storyboards.helperStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.createAppointmentController) as? CreateAppointmentController else {
            return
        }
        childVC.type = String(type.dropLast())
        addChildViewController(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        childVC.view.frame = appointmentView.bounds
        
        blurView.insertSubview(appointmentView, aboveSubview: blurView)
        appointmentView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
    }
    
    func editEventAppointment(id: String, dataDict: [String: Any])
    {
        appointmentViewLayout()
        guard let childVC =  Storyboards.helperStoryboard.instantiateViewController(withIdentifier: AppConstants.Controller.createAppointmentController) as? CreateAppointmentController else {
            return
        }
        childVC.type = String(type.dropLast())
        childVC.appointmentId = id
        childVC.appointmentDict = dataDict
        childVC.isEdit = true
        addChildViewController(childVC)
        childVC.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        childVC.view.frame = appointmentView.bounds
        
        blurView.insertSubview(appointmentView, aboveSubview: blurView)
        appointmentView.addSubview(childVC.view)
        childVC.didMove(toParentViewController: self)
    }
    
    
    private func constraintsAndPositionsForViews() {
        appointmentCollectionView.snp.makeConstraints {
            make in
            make.left.right.bottom.equalTo(self.view)
            make.top.equalTo(self.view.snp.top).offset((self.navigationController?.navigationBar.frame.height)! + UIApplication.shared.statusBarFrame.height)
        }
        let offset = UIScreen.main.bounds.height - view.bounds.height
        self.activityIndicatorView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(-offset)
        }
    }
}
extension AppointmentController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if appointmentEventDict.count == 0 {
            return 0
        }
        else {
            return appointmentEventDict.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if type == AppConstants.appointmentType {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.appointmentIdentifier, for: indexPath) as! AppointmentCell
        if appointmentEventDict.count != 0 && !isExpanded[indexPath.row]
        {
            cell.cellHeight = cellHeight
            cell.isExpanded = false
            cell.indexPath = indexPath
            cell.delegate = self
            cell.alertDelegate = self
            cell.editDelegate = self
            cell.configureCells(dataAtCurrentIndex: appointmentEventDict[indexPath.item])
        }
        else if isExpanded[indexPath.row] {
            cell.cellHeight = cellHeight
            cell.isExpanded = true
            cell.createExpandedView()
            cell.indexPath = indexPath
            cell.delegate = self
            cell.alertDelegate = self
            cell.editDelegate = self
            cell.configureCells(dataAtCurrentIndex: appointmentEventDict[indexPath.item])
        }
        return cell
        }
        if type == AppConstants.eventType {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.eventIdentifier, for: indexPath) as! EventCell
            if appointmentEventDict.count != 0 && !isExpanded[indexPath.row]
            {
                cell.cellHeight = cellHeight
                cell.isExpanded = false
                cell.indexPath = indexPath
                cell.delegate = self
                cell.configureCells(dataAtCurrentIndex: appointmentEventDict[indexPath.item])
            }
            else if isExpanded[indexPath.row] {
                cell.cellHeight = cellHeight
                cell.isExpanded = true
                cell.createExpandedView()
                cell.indexPath = indexPath
                cell.delegate = self
                cell.configureCells(dataAtCurrentIndex: appointmentEventDict[indexPath.item])
            }
            return cell
        }
        return UICollectionViewCell.init()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 1
        var widthRemainingForCellContent = collectionView.bounds.width
        if let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout {
            let borderSize: CGFloat = flowLayout.sectionInset.left + flowLayout.sectionInset.right
            widthRemainingForCellContent -= borderSize + ((cellsAcross - 1) * flowLayout.minimumInteritemSpacing)
        }
        let cellWidth = widthRemainingForCellContent / cellsAcross
        let modelName = UIDevice.modelName
        if isExpanded[indexPath.row] == true{
            return CGSize(width: cellWidth, height: 300)
        }
        else
        {
            if(modelName.contains("SE") || modelName.contains("4") || modelName.contains("5"))
            {
                cellHeight = collectionView.bounds.height / 5
                return CGSize(width: cellWidth, height: collectionView.bounds.height / 5)
            }
            else
            {
                cellHeight = collectionView.bounds.height / 6
                return CGSize(width: cellWidth, height: collectionView.bounds.height / 6)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension AppointmentController: ExpandedCellDelegate {
    func topButtonTouched(indexPath: IndexPath) {
        isExpanded[indexPath.row] = !isExpanded[indexPath.row]
        UIView.animate(withDuration: 0.8, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseIn , animations: {
            self.appointmentCollectionView.reloadItems(at: [indexPath])
        }, completion: { success in
            print("success")
        })
    }
}
extension AppointmentController: ShowAlertDelegate {
    
    func showCustomAlert(appointmentIdToDelete: String) {
        let alertVC = PMAlertController(title: "Are you sure?", description: "You won't be able to revert this back.", image: UIImage(named: "trash"), style: .walkthrough)
        
        
        alertVC.headerViewTopSpaceConstraint.constant = 20
        alertVC.alertContentStackViewLeadingConstraint.constant = 20
        alertVC.alertContentStackViewTrailingConstraint.constant = 20
        alertVC.alertContentStackViewTopConstraint.constant = 20
        alertVC.alertActionStackViewLeadingConstraint.constant = 20
        alertVC.alertActionStackViewTrailingConstraint.constant = 20
        alertVC.alertActionStackViewTopConstraint.constant = 20
        alertVC.alertActionStackViewBottomConstraint.constant = 0
        alertVC.view.layoutIfNeeded()
        
        alertVC.addAction(PMAlertAction(title: "Cancel", style: .cancel, action: { () -> Void in
            print("Cancel")
        }))
        
        alertVC.addAction(PMAlertAction(title: "Delete", style: .default, action: { () in
            print("Allow")
                    let deleteRequest = DeleteRequestModel()
                    deleteRequest.deleteAppointmentFromFirebase(appointmentID: appointmentIdToDelete, completionHandler: { result in
                        switch result {
                        case .success(let successMessage):
                            print(successMessage)
                        case .catchFailure:
                            print("Failure catched")
                        case .failure:
                            print("Operation failed")
                        }
                    })
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
}

extension AppointmentController: EditAppointmentDelegate {
    func editAppointment(withAppointmentID id: String, dict: [String : Any]) {
        editEventAppointment(id: id, dataDict: dict)
    }
}
