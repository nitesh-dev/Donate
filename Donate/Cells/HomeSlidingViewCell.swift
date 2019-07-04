//
//  HomeSlidingViewCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 30/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit

class HomeSlidingViewCell: UICollectionViewCell {
    var cellBackgroundImageView = UIImageView()
    var cellBackgroundView = UIView()
    var descriptionLabel = UILabel()
    
    let iconImageView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        
        self.backgroundColor = UIColor.white
        descriptionLabel.font = UIFont(name: "OpenSans", size: 14)
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
    }
    
    func configureViews()
    {
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
        
        self.addSubview(cellBackgroundImageView)
        cellBackgroundImageView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(iconImageView)
        cellBackgroundView.addSubview(descriptionLabel)
        
        cellBackgroundImageView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self)
        }
        cellBackgroundView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self)
        }
        
        iconImageView.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.cellBackgroundView.snp.centerX)
            make.top.greaterThanOrEqualTo(self.cellBackgroundView.snp.top).offset(20)
            //make.bottom.equalTo(self.cellBackgroundView.snp.bottom).offset(-10)
            //make.top.equalTo(self.cellBackgroundView.snp.top).offset(40)
            make.height.width.equalTo(self.cellBackgroundView.snp.width).multipliedBy(0.55)
        }
        descriptionLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.cellBackgroundView.snp.centerX)
            make.top.equalTo(self.iconImageView.snp.bottom).priority(.high)
            make.height.equalTo(50)
            make.width.equalTo(self.cellBackgroundView.snp.width).multipliedBy(0.9)
            make.bottom.greaterThanOrEqualTo(self.cellBackgroundView.snp.bottom).offset(-25)
        }
        
        cellBackgroundImageView.image = #imageLiteral(resourceName: "diego-ph-254975-unsplash")
        cellBackgroundImageView.isUserInteractionEnabled = true
        cellBackgroundImageView.contentMode = .scaleAspectFill
        cellBackgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.8)
    }
}
