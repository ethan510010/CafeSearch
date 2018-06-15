//
//  CafeListCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

class CafeListCell: UITableViewCell {
    
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var cafeNameLabel: UILabel!
    @IBOutlet weak var cafeAddressLabel: UILabel!
    @IBOutlet weak var cafeDistanceLabel: UILabel!
    
    func updateUI(cafe:Cafe, distance:Double){
        self.cafeNameLabel.text = cafe.name
        self.cafeAddressLabel.text = cafe.address
        //得到咖啡店的座標
        let distanceInt = round(distance)
        if distance < 1000{
            self.cafeDistanceLabel.text = "距離:\(distanceInt)m"
        }else{
            self.cafeDistanceLabel.text = "距離:\(distanceInt/1000)km"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellBackgroundView.layer.cornerRadius = 20
        cellBackgroundView.layer.masksToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //點選到的樣式
        self.selectionStyle = .none
        // Configure the view for the selected state
    }

}
