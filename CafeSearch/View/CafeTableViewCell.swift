//
//  CafeTableViewCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/3.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreLocation

protocol WhichCafeFBButtonDidTappedDelegate {
    func whichFBButtonDidTapped(index:IndexPath)
}

class CafeTableViewCell: UITableViewCell {
    
    var index:IndexPath?
    var delegate:WhichCafeFBButtonDidTappedDelegate?
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var fbButton: UIButton!
    
    
    @IBAction func openFBAction(_ sender: UIButton) {
        guard let index = self.index else { return }
        delegate?.whichFBButtonDidTapped(index: index)
    }
    
    func updateUI(cafe:Cafe,distance: Double){
        self.nameLabel.text = cafe.name
        self.locationLabel.text = cafe.address
        //得到咖啡店的座標
        let distanceInt = round(distance)
        if distance < 1000{
            self.distanceLabel.text = "距離:\(distanceInt)m"
        }else{
            self.distanceLabel.text = "距離:\(distanceInt/1000)km"
        }
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionStyle = .none
        // Configure the view for the selected state
    }
    
}
