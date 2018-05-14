//
//  PostcodeIntExtension.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation
extension String{
    func convertPostcodeToRegion(postCode:Int) -> String{
        var taipeiRange = 100...120
        var keelungRange = 200...208
        var taipeiRange3 = 220...253
        var lienchiangRange = 209...212
        var yilanRange = 260...290
        var hsinchuRange = 300...319
        var taoyuanRange = 320...340
        var miaoliRange = 350...369
        var taichungRange = 400...439
        var changhuaRange = 500...530
        var nantouRange = 540...558
        var chiayiRange = 600...625
        var yunlinRange = 630...655
        var tainanRange = 700...745
        var kaohsiungRange = 800...852
        var penghuRange = 880...885
        var pingtungRange = 900...947
        var taitungRange = 950...966
        var hualienRange = 970...983
        switch postCode {
        case taipeiRange, taipeiRange3:
            return "taipei"
        case keelungRange:
            return "keelung"
        case lienchiangRange:
            return "lienchiang"
        case yilanRange:
            return "yilang"
        case hsinchuRange:
            return "hsinchu"
        case taoyuanRange:
            return "taoyuan"
        case miaoliRange:
            return "miaoli"
        case taichungRange:
            return "taichung"
        case changhuaRange:
            return "changhua"
        case nantouRange:
            return "nantou"
        case chiayiRange:
            return "chiayi"
        case yunlinRange:
            return "yunlin"
        case tainanRange:
            return "tainan"
        case kaohsiungRange:
            return "kaohsiung"
        case penghuRange:
            return "penghu"
        case pingtungRange:
            return "pingtung"
        case taitungRange:
            return "taitung"
        case hualienRange:
            return "hualien"
        default:
            return ""
        }
        
    }

}
