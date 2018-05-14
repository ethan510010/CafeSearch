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
        self.cityNameLabel.text = city.cityChineseName
        if city.isSelected == true{
            self.appearenceView.backgroundColor = .blue
            self.cityNameLabel.textColor = .white
        }else{
            self.appearenceView.backgroundColor = .white
            self.cityNameLabel.textColor = .black
        }
    }
}
