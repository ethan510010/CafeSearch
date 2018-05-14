//
//  ConditionViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/6.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol PassConditionRecordDelegate: class {
    func passConditionRecord(conditionDic:[String:String])
}

class SearchConditionViewController: UIViewController {
    
    let conditionArray = [Condition(conditionName: "Wifi品質", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "安靜程度", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "有無插座", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "座位多寡", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良")]

    //紀錄條件
    var conditionSelectedDic:[String:String] = ["Wifi品質":"不限","安靜程度":"不限","有無插座":"不限","座位多寡":"不限"]
    
    weak var delegate:PassConditionRecordDelegate?
    
    @IBOutlet weak var conditionTableView: UITableView!
    
    
    @IBAction func ensureConditionAction(_ sender: UIButton) {
        print(conditionSelectedDic)
        delegate?.passConditionRecord(conditionDic: self.conditionSelectedDic)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conditionTableView.delegate = self
        conditionTableView.dataSource = self
        conditionTableView.isScrollEnabled = false
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
extension SearchConditionViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.conditionArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conditionCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierManager.conditionCellID, for: indexPath) as! ConditionTableViewCell
        let condition = conditionArray[indexPath.row]
        conditionCell.index = indexPath
        conditionCell.delegate = self
        conditionCell.update(condition: condition)
        return conditionCell
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let coverView = UIView()
//        coverView.backgroundColor = UIColor(red: 0, green: 122/255, blue: 255/255, alpha: 1)
//        return coverView
//    }
    
}
extension SearchConditionViewController: WhichSegmentOfCellDidSelectedDelegate{
    func conditionSelected(index: IndexPath, selectedContidion: String) {
        let selectedConditionKey = self.conditionArray[index.row].conditionName
        self.conditionSelectedDic[selectedConditionKey] = selectedContidion
        print(conditionArray[index.row].conditionName, selectedContidion)
    }
 
}
