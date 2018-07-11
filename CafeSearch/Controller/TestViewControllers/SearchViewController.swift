//
//  ViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/3.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager:CLLocationManager?

    //現在所在城市
    var currentCity:String? = ""
    //現在的座標
    var currentLocation:CLLocation?
    
    //把popoverVC傳過來的條件存進一個dic
    var conditionSettingFromPopoverDic:[String:String] = [String:String]()
    
    @IBOutlet weak var currentPositionLabel: UILabel!
    
    
    @IBAction func chooseCityAction(_ sender: UIButton) {
        performSegue(withIdentifier: SegueManager.performCityPop, sender: nil)
    }
    
    
    @IBAction func searchConditionAction(_ sender: UIButton) {
        performSegue(withIdentifier: SegueManager.performConditionPop, sender: nil)
    }
    
    @IBAction func searchCageAction(_ sender: UIButton) {
        performSegue(withIdentifier: SegueManager.performCafeList, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueManager.performCafeList{
            guard let cafeListsVC = segue.destination as? CafeListViewController else {return}
            cafeListsVC.cityBeSelectedFromSearchVC = currentCity!
            cafeListsVC.locationFromSearchVC = self.currentLocation
            cafeListsVC.conditionDicFromSearchVCorResetConditionVC = self.conditionSettingFromPopoverDic
            print("抓到的城市:\(currentCity!)")
        }
        if segue.identifier == SegueManager.performCityPop{
            guard let cityVC = segue.destination as? PopoverCityViewController else {return}
            //設定popover
            cityVC.preferredContentSize = CGSize(width: self.view.frame.width * (350/375), height: self.view.frame.height * (520/812))
            let cityPopoverVC = cityVC.popoverPresentationController
            cityPopoverVC?.delegate = self
            //設定傳值的delegate
            cityVC.delegate = self
        }
        
        if segue.identifier == SegueManager.performConditionPop{
            guard let conditionVC = segue.destination as? SearchConditionViewController else {return}
            
            //傳值而設的delegate
            conditionVC.delegate = self
            //設定popover
            conditionVC.preferredContentSize = CGSize(width: self.view.frame.width * (300/375), height: self.view.frame.height * (250/812))
            let conditionPopoverVC = conditionVC.popoverPresentationController
            conditionPopoverVC?.permittedArrowDirections = .up
            conditionPopoverVC?.delegate = self
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //如果要每次切回這頁顯示的都是使用者現在位置就寫在ViewWillAppear，如果不用就寫在ViewDidLoad
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func convertPostcodeToRegion(postCode:Int) -> String{
        let taipeiRange = 100...120
        let keelungRange = 200...208
        let taipeiRange3 = 220...253
        let lienchiangRange = 209...212
        let yilanRange = 260...290
        let hsinchuRange = 300...319
        let taoyuanRange = 320...340
        let miaoliRange = 350...369
        let taichungRange = 400...439
        let changhuaRange = 500...530
        let nantouRange = 540...558
        let chiayiRange = 600...625
        let yunlinRange = 630...655
        let tainanRange = 700...745
        let kaohsiungRange = 800...852
        let penghuRange = 880...885
        let pingtungRange = 900...947
        let taitungRange = 950...966
        let hualienRange = 970...983
        switch postCode {
        case taipeiRange, taipeiRange3:
            return "taipei"
        case keelungRange:
            return "keelung"
        case lienchiangRange:
            return "lienchiang"
        case yilanRange:
            return "yilang"
        case hsinchuRange:
            return "hsinchu"
        case taoyuanRange:
            return "taoyuan"
        case miaoliRange:
            return "miaoli"
        case taichungRange:
            return "taichung"
        case changhuaRange:
            return "changhua"
        case nantouRange:
            return "nantou"
        case chiayiRange:
            return "chiayi"
        case yunlinRange:
            return "yunlin"
        case tainanRange:
            return "tainan"
        case kaohsiungRange:
            return "kaohsiung"
        case penghuRange:
            return "penghu"
        case pingtungRange:
            return "pingtung"
        case taitungRange:
            return "taitung"
        case hualienRange:
            return "hualien"
        default:
            return ""
        }

    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            //得到現在使用者座標
            guard let coordinate = manager.location?.coordinate else {return}
            let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            self.currentLocation = userLocation
            //把座標轉成地址
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarkArray, error) in
                guard let currentAddress = placemarkArray?.first else {return}
                print(currentAddress)
                guard let currentPostCode = currentAddress.postalCode else {return}
                //現在所在城市
                let currentCity = self.convertPostcodeToRegion(postCode: Int(currentPostCode)!)
                print(currentCity)

                //把現在所在的城市存到全域變數，為了可以把這一頁的城市傳到下一頁
                self.currentCity = currentCity
                self.currentPositionLabel.text = currentAddress.subAdministrativeArea
//                guard let city = currentAddress.subAdministrativeArea as? String else             {return}
//                self.currentCity = city.deleteCityCountyWord().lowercased()
//                self.currentPositionLabel.text = currentAddress.subAdministrativeArea
            }
        }
    }
 
}
extension SearchViewController: UIPopoverPresentationControllerDelegate{
    //讓iphone可以支援popover
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    //關閉點擊旁邊空白處可以關掉popover的功能
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return false
    }
}
extension SearchViewController: PassConditionRecordDelegate{
    func passConditionRecord(conditionDic: [String : String]) {
        self.conditionSettingFromPopoverDic = conditionDic
//        print("搜尋頁面收到條件:\(self.conditionSettingFromPopoverDic)")
    }
}
extension SearchViewController: PassSelectedCityInfoDelegate{
    func passSelectedCity(city: City) {
        self.currentCity = city.cityEnglishName.lowercased()
        self.currentPositionLabel.text = city.cityChineseName
    }
}
