//
//  City.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/9.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation

class City {
    var cityChineseName:String
    var cityEnglishName:String
    var isSelected:Bool
    
    init(cityChineseName:String,cityEnglishName:String,isSelected:Bool) {
        self.cityChineseName = cityChineseName
        self.cityEnglishName = cityEnglishName
        self.isSelected = isSelected
    }
}
