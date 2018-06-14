//
//  PopoverCityViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/9.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol PassSelectedCityInfoDelegate: class {
    func passSelectedCity(city:City)
}

class PopoverCityViewController: UIViewController {
    
    var selectedCity:City? = nil
    weak var delegate:PassSelectedCityInfoDelegate?
    
    let cityArray = [City(cityChineseName: "基隆", cityEnglishName: "Keelung", isSelected: false),City(cityChineseName: "台北", cityEnglishName: "Taipei", isSelected: false),City(cityChineseName: "桃園", cityEnglishName: "Taoyuan", isSelected: false),City(cityChineseName: "新竹", cityEnglishName: "Hsinchu", isSelected: false),City(cityChineseName: "苗栗", cityEnglishName: "Miaoli", isSelected: false),City(cityChineseName: "台中", cityEnglishName: "Taichung", isSelected: false),City(cityChineseName: "南投", cityEnglishName: "Nantou", isSelected: false),City(cityChineseName: "彰化", cityEnglishName: "Changhua", isSelected: false),City(cityChineseName: "雲林", cityEnglishName: "Yunlin", isSelected: false),City(cityChineseName: "嘉義", cityEnglishName: "Chiayi", isSelected: false),City(cityChineseName: "台南", cityEnglishName: "Tainan", isSelected: false),City(cityChineseName: "高雄", cityEnglishName: "Kaohsiung", isSelected: false),City(cityChineseName: "屏東", cityEnglishName: "Pingtung", isSelected: false),City(cityChineseName: "宜蘭", cityEnglishName: "Yilan", isSelected: false),City(cityChineseName: "花蓮", cityEnglishName: "Hualien", isSelected: false),City(cityChineseName: "台東", cityEnglishName: "Taitung", isSelected: false),City(cityChineseName: "澎湖", cityEnglishName: "Penghu", isSelected: false)]
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var cityCollectionView: UICollectionView!
    
    @IBAction func ensureCityAction(_ sender: UIButton) {
        if self.selectedCity != nil{
            delegate?.passSelectedCity(city: self.selectedCity!)
            self.dismiss(animated: true, completion: nil)
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityCollectionView.delegate = self
        cityCollectionView.dataSource = self
        collectionViewFlowLayout.minimumInteritemSpacing = 5
        collectionViewFlowLayout.itemSize.width = self.view.frame.width * (160/375)
        collectionViewFlowLayout.itemSize.height = self.view.frame.height * (44/520)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PopoverCityViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cityArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cityCell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifierManager.cityCellID, for: indexPath) as! CityCollectionViewCell
        let city = self.cityArray[indexPath.item]
        cityCell.updateUI(city: city)
        return cityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCity = self.cityArray[indexPath.item]
        
        //處理點擊到的外觀
        for eachcity in self.cityArray{
            eachcity.isSelected = false
        }
        selectedCity.isSelected = true
        self.cityCollectionView.reloadData()
        //傳值要用的
        self.selectedCity = selectedCity
    }
    
}
