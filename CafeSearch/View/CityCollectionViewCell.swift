//
//  CityCollectionViewCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/9.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedAppearenceView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    func updateUI(city:City){
        self.cityNameLabel.text = "\(city.cityChineseName),\(city.cityEnglishName)"
        if city.isSelected{
            self.selectedAppearenceView.backgroundColor = .blue
            self.cityNameLabel.textColor = .white
        }else{
            self.selectedAppearenceView.backgroundColor = .white
            self.cityNameLabel.textColor = .black
        }
    }
}
