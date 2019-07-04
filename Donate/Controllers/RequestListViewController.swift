//
//  RequestListViewController.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 06/02/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit
import SnapKit
import NVActivityIndicatorView

class RequestListViewController: UIViewController {
    
    @IBOutlet weak var requestListCollectionView: UICollectionView!
    var requestForBloodDict = [[String: Any]]()
    lazy var activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2, width: 100, height: 100), type: NVActivityIndicatorType.ballScaleMultiple, color: UIColor.red, padding: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(activityIndicatorView)
        let offset = UIScreen.main.bounds.height - view.bounds.height
        self.activityIndicatorView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).offset(-offset)
        }
        activityIndicatorView.startAnimating()
        NotificationCenter.default.addObserver(self, selector: #selector(self.openSettingsForLocation(notification:)), name: Notification.Name("OpenSettings"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayRequests(notification:)), name: Notification.Name("DisplayData"), object: nil)
    }
    
    @objc func displayRequests(notification: Notification) {
        let request = RetrieveRequestDataModel()
        
        request.getRequestsFromFirebase(completionHandler:{ result in
            switch result {
            case .success(let requestedDictFromFirebase):
                self.requestForBloodDict = requestedDictFromFirebase
                self.activityIndicatorView.stopAnimating()
                self.requestListCollectionView.reloadData()
            case .failure(let error): print(error)
            case .catchFailure : print("Please try again")
            }
        })
    }
    
    
    
    @objc func openSettingsForLocation(notification: Notification) {
        let alert = UIAlertController(title: "Go To Settings", message: "Oops! It seems like you've not provided your location, please grant location access", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Sure", style: .default, handler: { action in
                UIApplication.shared.open(NSURL(string: UIApplicationOpenSettingsURLString)! as URL, options: [:], completionHandler: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension RequestListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if requestForBloodDict.count == 0 {
            return 0
        }
        else {
            return requestForBloodDict.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppConstants.Cells.donateCellIdentifier, for: indexPath) as! DonateCollectionCell
        if requestForBloodDict.count != 0
        {
            cell.configureCells(dataAtCurrentIndex: requestForBloodDict[indexPath.item])
        }
        return cell
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
        if(modelName.contains("SE") || modelName.contains("4") || modelName.contains("5"))
        {
            return CGSize(width: cellWidth, height: collectionView.bounds.height / 5)
        }
        else
        {
            return CGSize(width: cellWidth, height: collectionView.bounds.height / 6)
        }
    }
}
