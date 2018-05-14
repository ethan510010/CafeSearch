//
//  StringExtension.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/4.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import Foundation

extension String{
    func deleteCityCountyWord() -> String{
        return self.replacingOccurrences(of: "City", with: "").replacingOccurrences(of: "County", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
//        if cityName.hasSuffix("City") || cityName.hasSuffix("County"){
//           var desireCityName = cityName.replacingOccurrences(of: " City", with: "")
//           return desireCityName.lowercased()
//        }else{
//            return cityName
//        }
    }
}
