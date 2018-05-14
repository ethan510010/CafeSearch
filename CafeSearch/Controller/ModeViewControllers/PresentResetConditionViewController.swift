//
//  PresentResetConditionViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/7.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol PassResetConditionDelegate: class {
    func passResetConditionDelegate(resetConditionDic:[String:String])
    func passResetCityDelegate(resetCity:City)
}

struct NotificationCondiitonAndCity {
    static let conditionNotification = "conditionNotification"
    static let cityNotification = "cityNotification"
}

class PresentResetConditionViewController: UIViewController {
    // 要用來存重新選擇的城市
    var resetSelectedCity:City? = nil
    
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    
    //預設先給北部的城市
    var chooseCityAreaArray:[City] = [City(cityChineseName: "基隆", cityEnglishName: "Keelung", isSelected: false),City(cityChineseName: "台北", cityEnglishName: "Taipei", isSelected: false),City(cityChineseName: "桃園", cityEnglishName: "Taoyuan", isSelected: false),City(cityChineseName: "新竹", cityEnglishName: "Hsinchu", isSelected: false)] {
        didSet{
            cityCollectionView.reloadData()
        }
    }
    let northAreaCityArray = [City(cityChineseName: "基隆", cityEnglishName: "Keelung", isSelected: false),City(cityChineseName: "台北", cityEnglishName: "Taipei", isSelected: false),City(cityChineseName: "桃園", cityEnglishName: "Taoyuan", isSelected: false),City(cityChineseName: "新竹", cityEnglishName: "Hsinchu", isSelected: false)]
    let centerAreaCityArray = [City(cityChineseName: "苗栗", cityEnglishName: "Miaoli", isSelected: false),City(cityChineseName: "台中", cityEnglishName: "Taichung", isSelected: false),City(cityChineseName: "南投", cityEnglishName: "Nantou", isSelected: false),City(cityChineseName: "彰化", cityEnglishName: "Changhua", isSelected: false),City(cityChineseName: "雲林", cityEnglishName: "Yunlin", isSelected: false)]
    let southAreaCityArray = [City(cityChineseName: "嘉義", cityEnglishName: "Chiayi", isSelected: false),City(cityChineseName: "台南", cityEnglishName: "Tainan", isSelected: false),City(cityChineseName: "高雄", cityEnglishName: "Kaohsiung", isSelected: false),City(cityChineseName: "屏東", cityEnglishName: "Pingtung", isSelected: false)]
    let eastAreaCityArray = [City(cityChineseName: "宜蘭", cityEnglishName: "Yilan", isSelected: false),City(cityChineseName: "花蓮", cityEnglishName: "Hualien", isSelected: false),City(cityChineseName: "台東", cityEnglishName: "Taitung", isSelected: false)]
    let outsideAreaCityArray = [City(cityChineseName: "澎湖", cityEnglishName: "Penghu", isSelected: false)]
    
    @IBAction func northAreaDidTapped(_ sender: UIButton) {
        self.chooseCityAreaArray = self.northAreaCityArray
    }
    @IBAction func centerAreaDidTapped(_ sender: UIButton) {
        self.chooseCityAreaArray = self.centerAreaCityArray
    }
    @IBAction func southAreaDidTapped(_ sender: UIButton) {
        self.chooseCityAreaArray = self.southAreaCityArray
    }
    @IBAction func eastAreaDidTapped(_ sender: UIButton) {
        self.chooseCityAreaArray = self.eastAreaCityArray
    }
    @IBAction func outsideAreaDidTapped(_ sender: UIButton) {
        self.chooseCityAreaArray = self.outsideAreaCityArray
    }

    let resetConditionArray = [Condition(conditionName: "Wifi品質", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "安靜程度", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "有無插座", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良"),Condition(conditionName: "座位多寡", conditionNoLimit: "不限", conditionGeneral: "普通", conditionBetter: "優良")]
    
    var resetConditionSelectedDic:[String:String] = ["Wifi品質":"不限","安靜程度":"不限","有無插座":"不限","座位多寡":"不限"]
    
    @IBOutlet weak var resetConditionTableView: UITableView!
    
//    weak var delegate:PassResetConditionDelegate?
    
    //按下確認按鈕，必須通時傳值給mapModeVC與ListVC兩者，所以這邊用notification去傳值
    @IBAction func conditionSettingCompletionAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        NotificationCenter.default.post(name: .passConditionToMapVCAndListVCNotification, object: nil, userInfo: [NotificationCondiitonAndCity.conditionNotification:self.resetConditionSelectedDic,NotificationCondiitonAndCity.cityNotification:self.resetSelectedCity])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetConditionTableView.delegate = self
        resetConditionTableView.dataSource = self
        resetConditionTableView.separatorStyle = .none
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension PresentResetConditionViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.resetConditionArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierManager.resetConditionCellID, for: indexPath) as! ResetConditionTableViewCell
        cell.index = indexPath
        cell.delegate = self
        cell.update(condition: self.resetConditionArray[indexPath.row])
        return cell
    }
}
//接受來自下面條件的傳值所設定的delegate
extension PresentResetConditionViewController: ResetConditionSegmentDidSelectedDelegate{
    func resetConditionSelected(index: IndexPath, selectedContidion: String) {
        let resetConditionDicKey = self.resetConditionArray[index.row].conditionName
        self.resetConditionSelectedDic[resetConditionDicKey] = selectedContidion
    }
 
}
extension PresentResetConditionViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chooseCityAreaArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierManager.resetCityCellID, for: indexPath) as! ResetCityCollectionViewCell
        let eachCity = self.chooseCityAreaArray[indexPath.item]
        cell.update(city: eachCity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for eachCity in self.chooseCityAreaArray{
            eachCity.isSelected = false
        }
        var chooseCity = self.chooseCityAreaArray[indexPath.item]
        chooseCity.isSelected = true
        self.cityCollectionView.reloadData()
        //傳值要用的，所以把選到的放到全局變數
        self.resetSelectedCity = chooseCity
    }
   
}
