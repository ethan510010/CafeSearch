//
//  CornerLabel.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/6/14.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class CornerLabel: UILabel{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
    }
}
