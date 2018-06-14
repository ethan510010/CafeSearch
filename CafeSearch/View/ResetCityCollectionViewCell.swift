//
//  ResetCityCollectionViewCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/9.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class ResetCityCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var appearenceView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    func update(city:City){
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.cityNameLabel.text = city.cityChineseName
        if city.isSelected == true{
            self.appearenceView.backgroundColor = .brown
            self.cityNameLabel.textColor = .white
        }else{
            self.appearenceView.backgroundColor = .clear
            self.cityNameLabel.textColor = .white
        }
    }
}
