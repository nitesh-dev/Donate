//
//  HomeStatsViewCellCollectionViewCell.swift
//  Donate
//
//  Created by Cognizant Technology Solutions # 2 on 31/01/19.
//  Copyright © 2019 Cognizant Technology Solutions # 2. All rights reserved.
//

import UIKit

class HomeStatsViewCell: UICollectionViewCell {
    var cellBackgroundImageView = UIImageView()
    var cellBackgroundView = UIView()
    var descriptionLabel = UILabel()
    var countView = UIImageView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
        
        self.backgroundColor = UIColor.clear
        descriptionLabel.font = UIFont(name: "OpenSans", size: 16)
        descriptionLabel.textColor = UIColor.white
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.5
        
        descriptionLabel.adjustsFontSizeToFitWidth = true
        descriptionLabel.minimumScaleFactor = 0.7
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        cellBackgroundView.layer.cornerRadius = 5
        cellBackgroundView.clipsToBounds = true
        cellBackgroundImageView.clipsToBounds = true
    }
    
    func configureViews()
    {
        self.addSubview(cellBackgroundImageView)
        cellBackgroundImageView.addSubview(cellBackgroundView)
        cellBackgroundView.addSubview(descriptionLabel)
        cellBackgroundView.addSubview(countView)
        cellBackgroundView.backgroundColor = UIColor.red.withAlphaComponent(0.9)
        
        cellBackgroundImageView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(self)
        }
        cellBackgroundView.snp.makeConstraints {
            make in
            make.left.right.top.bottom.equalTo(cellBackgroundImageView)
        }
        
        let heightOffset = self.bounds.height * 0.15
        countView.snp.makeConstraints {
            make in
            make.top.equalTo(self.cellBackgroundView).offset(heightOffset)
            make.centerX.equalTo(self.cellBackgroundView.snp.centerX)
            make.width.height.equalTo(self.cellBackgroundView.snp.height).multipliedBy(0.5)
        }
        descriptionLabel.snp.makeConstraints {
            make in
            make.centerX.equalTo(self.cellBackgroundView.snp.centerX)
            make.top.greaterThanOrEqualTo(self.countView.snp.bottom)
            make.width.equalTo(self.cellBackgroundView.snp.width).multipliedBy(0.9)
            make.bottom.lessThanOrEqualTo(self.cellBackgroundView.snp.bottom).offset(-10)
        }
        
        cellBackgroundImageView.isUserInteractionEnabled = true
    }
}
