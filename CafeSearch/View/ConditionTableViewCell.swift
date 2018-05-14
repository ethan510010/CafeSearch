//
//  ConditionTableViewCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/6.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit


protocol WhichSegmentOfCellDidSelectedDelegate: class {
    func conditionSelected(index:IndexPath,selectedContidion:String)
}

class ConditionTableViewCell: UITableViewCell {
    
    var index:IndexPath?
    weak var delegate: WhichSegmentOfCellDidSelectedDelegate?
    
    @IBOutlet weak var conditionNameLabel: UILabel!
    
    @IBOutlet weak var conditionLevelSegment: UISegmentedControl!
    
    
    @IBAction func selectCondition(_ sender: UISegmentedControl) {
        guard let index = index else {return}
        let selectedConditionIndex = sender.selectedSegmentIndex
        guard let selectedConditionTitle = sender.titleForSegment(at: selectedConditionIndex) else {return}
        delegate?.conditionSelected(index: index, selectedContidion: selectedConditionTitle)
    }
    
    
    func update(condition:Condition){
        conditionNameLabel.text = condition.conditionName
        conditionLevelSegment.setTitle(condition.conditionNoLimit, forSegmentAt: 0)
        conditionLevelSegment.setTitle(condition.conditionGeneral, forSegmentAt: 1)
        conditionLevelSegment.setTitle(condition.conditionBetter, forSegmentAt: 2)
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
