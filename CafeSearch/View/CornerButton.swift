//
//  CornerButton.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/6/14.
//  Copyright © 2018 EthanLin. All rights reserved.
//


import UIKit
class CornerButton: UIButton{
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.blue.cgColor
        self.layer.borderWidth = 3
    }
}
