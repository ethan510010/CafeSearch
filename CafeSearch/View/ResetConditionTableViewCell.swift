//
//  ResetConditionTableViewCell.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/7.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol ResetConditionSegmentDidSelectedDelegate: class {
    func resetConditionSelected(index:IndexPath,selectedContidion:String)
}

class ResetConditionTableViewCell: UITableViewCell {
    
    var index:IndexPath?
    weak var delegate: ResetConditionSegmentDidSelectedDelegate?
    
    @IBOutlet weak var resetConditionLabel: UILabel!
    @IBOutlet weak var resetConditionLevelSegment: UISegmentedControl!
    
    func update(condition:Condition){
        resetConditionLabel.text = condition.conditionName
        resetConditionLevelSegment.setTitle(condition.conditionNoLimit, forSegmentAt: 0)
        resetConditionLevelSegment.setTitle(condition.conditionGeneral, forSegmentAt: 1)
        resetConditionLevelSegment.setTitle(condition.conditionBetter, forSegmentAt: 2)
    }
    
    @IBAction func resetConditionLevelSelected(_ sender: UISegmentedControl) {
        guard let index = index else { return }
        let selectedSegmentIndex = sender.selectedSegmentIndex
        guard let selectedResetConditionTitle = sender.titleForSegment(at: selectedSegmentIndex) else {return}
        delegate?.resetConditionSelected(index: index, selectedContidion: selectedResetConditionTitle)
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
