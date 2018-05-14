//
//  SegueKey.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/6.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import Foundation

struct SegueManager {
    static let performCafeList = "performCafeList"
    static let performConditionPop = "showConditionPop"
    static let performGoogleMap = "performGoogleMap"
    static let performFB = "performFB"
    static let performResetConditionVC = "performResetCondition"
    static let performPanoVC = "performPanoView"
    static let performCityPop = "showCityPopover"
    static let performSearchConditionVC = "performSearchConditionVC"
    static let unwindFromConditionVCToListVC = "unwindToCafeList"
    static let unwindFromConditionVCToMapModeVC = "unwindToMapModeVC"
    static let performCafeDetail = "performCafeDetail"
}
