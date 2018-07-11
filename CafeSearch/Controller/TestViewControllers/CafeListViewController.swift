//
//  CafeListViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/3.
//  Copyright © 2018年 EthanLin. All rights reserved.
//

import UIKit
import CoreLocation

class CafeListViewController: UIViewController {
    
    //接收第一頁的城市
    var cityBeSelectedFromSearchVC:String = ""
    //接收第一頁的經緯度（使用者的位置）
    var locationFromSearchVC:CLLocation?
    //接收第一頁的搜尋條件字典
    var conditionDicFromSearchVCorResetConditionVC:[String:String] = [String:String]()
    
    
    //tableViewReloadData的自訂方法
    @objc func cafeTableViewReloadData(){
        DispatchQueue.main.async {
            self.cafeListTableView.reloadData()
            self.cafeListTableView.estimatedRowHeight = 0
            self.cafeListTableView.estimatedSectionHeaderHeight = 0
            self.cafeListTableView.estimatedSectionFooterHeight = 0
        }
    }
    //跳到重設條件的VC
    @IBAction func resetCondition(_ sender: UIBarButtonItem) {
//        performSegue(withIdentifier: SegueManager.performResetConditionVC, sender: nil)
    }
 
    @IBOutlet weak var cafeListTableView: UITableView!
    //利用id存成一個對應的距離dictionary
    var distanceDic = [String:Double]()
    
    //這個array要用來存距離在5000m以內的Cafe,且會依距離由小到大
    var nearbyCafeArray: [Cafe]?{
        didSet{
//            cafeTableViewReloadData()
        }
    }
    
    //單純用來存一個距離由近到遠的cafeArray沒有任何篩選條件
    var cafeArray:[Cafe]?{
        didSet{
//            cafeTableViewReloadData()
        }
    }

    //有進行篩選條件的cafeArray
    var withConditionArray: [Cafe]?
    var cafeArrayForTableView: [Cafe]? {
        didSet {
//            cafeTableViewReloadData()
        }
    }
    
    var timer: Timer?
    
    func attempReloadTableView() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(cafeTableViewReloadData), userInfo: nil, repeats: false)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cafeListTableView.delegate = self
        self.cafeListTableView.dataSource = self
        print("定位到的城市:\(cityBeSelectedFromSearchVC)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("接收搜尋頁面或重新設定頁面過來的條件字典:\(self.conditionDicFromSearchVCorResetConditionVC)")
        APIManager.shared.fetchCafe(url: URLManager.cafeURL + "/\(self.cityBeSelectedFromSearchVC)") { (cafeLists) in
            //cafeLists為從網絡抓下來的
            var cafeDistances = cafeLists?.map({ (cafe) -> (Cafe?, CLLocationDistance) in
                guard let cafeLat = cafe.latitude, let cafeLog = cafe.longitude else {fatalError()}
                if let cafeLatitude = CLLocationDegrees(cafeLat), let cafeLongitude = CLLocationDegrees(cafeLog), let userLocation = self.locationFromSearchVC {
                    let cafeLocation = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude)
                    let cafeDistance = cafeLocation.distance(from: userLocation)
                    guard let cafeID = cafe.id else {fatalError()}
                    self.distanceDic[cafeID] = cafeDistance
                    return (cafe, cafeDistance)
                } else {
                    return (nil, 0)
                }
            })
            
            //依照距離排序，距離是item的第一項(1),第0項代表的是Cafe
            cafeDistances?.sort(by: { (item1, item2) -> Bool in
                //按照距離由近到遠
                return item1.1 < item2.1
                
            })
            
            
            if let cafeDistances = cafeDistances {
                
                //Case 1
                //存進只有依照距離由近到遠排列的cafeArray(沒有任何篩選條件)
                self.cafeArray = cafeDistances.map({ (cafeTuple) -> Cafe in
                    return cafeTuple.0!
                })
                
                //Case 2
                //存進一個過濾條件後只有半徑5000m裡面的nearbyCafeArray
                self.nearbyCafeArray = cafeDistances.filter({ (cafeTuple) -> Bool in
                    if cafeTuple.1 < 5000 {
                        return true
                    } else {
                        return false
                    }
                }).map({ (cafeTuple) -> Cafe in
                    return cafeTuple.0!
                })
                
                //Case 3
                //存進一個有前面傳進來的篩選條件的array
                //先處理篩選條件的邏輯
                //
                self.withConditionArray = self.cafeArray
                self.conditionDicFromSearchVCorResetConditionVC.forEach({ (conditionKey, conditionValue) in
                    if conditionValue != "不限"{
                        print("有設定條件的key有:\(conditionKey),條件為:\(conditionValue)")
                        switch conditionKey{
                        case "Wifi品質":
                            if conditionValue == "普通"{
                                self.withConditionArray =  self.withConditionArray?.filter({ (cafe) -> Bool in
                                    if cafe.wifi == 3{
                                        return true
                                    }else {
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }else if conditionValue == "優良"{
                                self.withConditionArray = self.withConditionArray?.filter({ (cafe) -> Bool in
                                    guard let wifi = cafe.wifi else {fatalError()}
                                    if wifi > Double(3){
                                        return true
                                    }else{
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }
                        case "安靜程度":
                            if conditionValue == "普通"{
                                self.withConditionArray =  self.withConditionArray?.filter({ (cafe) -> Bool in
                                    if cafe.quiet == 3{
                                        return true
                                    }else {
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }else if conditionValue == "優良"{
                                self.withConditionArray = self.withConditionArray?.filter({ (cafe) -> Bool in
                                    guard let quiet = cafe.quiet else {fatalError()}
                                    if quiet > Double(3){
                                        return true
                                    }else{
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }
                        case "有無插座":
                            if conditionValue == "普通"{
                                self.withConditionArray =  self.withConditionArray?.filter({ (cafe) -> Bool in
                                    if cafe.socket == "maybe"{
                                        return true
                                    }else {
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }else if conditionValue == "優良"{
                                self.withConditionArray = self.withConditionArray?.filter({ (cafe) -> Bool in
                                    if (cafe.socket) == "yes"{
                                        return true
                                    }else{
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }
                        case "座位多寡":
                            if conditionValue == "普通"{
                                self.withConditionArray =  self.withConditionArray?.filter({ (cafe) -> Bool in
                                    if cafe.seat == 3{
                                        return true
                                    }else {
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }else if conditionValue == "優良"{
                                self.withConditionArray = self.withConditionArray?.filter({ (cafe) -> Bool in
                                    guard let seat = cafe.seat else {fatalError()}
                                    if seat > Double(3){
                                        return true
                                    }else{
                                        return false
                                    }
                                }).map({ (cafe) -> Cafe in
                                    return cafe
                                })
                            }
                        default:
                            break
                        }
                        
                        
                    }
                })
                
                self.cafeArrayForTableView = self.withConditionArray
                self.cafeTableViewReloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
extension CafeListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Case1: 如果現在想要顯示的是最一般的
//        guard let cafeListsNum = self.cafeArray?.count else { return 0 }
        
        //Case2: 如果現在想要顯示的是nearbyCafe
//        guard let cafeListsNum = self.nearbyCafeArray?.count else { return 0 }
        
        
        //Case3: 如果現在想要顯示的是有條件篩選的
//        guard let cafeListsNum = self.withConditionArray?.count else { return 0 }
//        return cafeListsNum
        if self.conditionDicFromSearchVCorResetConditionVC == [:] || self.conditionDicFromSearchVCorResetConditionVC == ["安靜程度": "不限", "座位多寡": "不限", "有無插座": "不限", "Wifi品質": "不限"]{
            guard let cafeListsNum = self.cafeArray?.count else { return 0 }
            return cafeListsNum
        }else{
            guard let cafeListsNum = self.withConditionArray?.count else { return 0 }
            return cafeListsNum
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cafeCell", for: indexPath) as! CafeTableViewCell
        
        //Case1: 如果現在想要顯示的是最一般的
//        let cafe = self.cafeArray![indexPath.row]
//        let distance = distanceDic[cafe.id] ?? 0
//        cell.updateUI(cafe: cafe, distance: distance)
        
        //Case2: 如果現在想要顯示的是nearbyCafe
//        guard let nearbyCafe = self.nearbyCafeArray?[indexPath.row] else {return UITableViewCell()}
//        let nearbyDistance = distanceDic[nearbyCafe.id] ?? 0
//        cell.updateUI(cafe: nearbyCafe, distance: nearbyDistance)
        
        //Case3: 如果現在想要顯示的是有條件篩選的
//        guard let withConditionCafe = self.withConditionArray?[indexPath.row] else {return UITableViewCell()}
//        let withConditionDistance = distanceDic[withConditionCafe.id] ?? 0
//        cell.updateUI(cafe: withConditionCafe, distance: withConditionDistance)
        
        if self.conditionDicFromSearchVCorResetConditionVC == [:] || self.conditionDicFromSearchVCorResetConditionVC == ["安靜程度": "不限", "座位多寡": "不限", "有無插座": "不限", "Wifi品質": "不限"]{
            let cafe = self.cafeArray![indexPath.row]
            guard let cafeID = cafe.id else {return UITableViewCell()}
            let distance = distanceDic[cafeID] ?? 0
            cell.updateUI(cafe: cafe, distance: distance)
        }else{
            guard let withConditionCafe = self.withConditionArray?[indexPath.row] else {return UITableViewCell()}
            guard let withConditionCafeID = withConditionCafe.id else {return UITableViewCell()}
            let withConditionDistance = distanceDic[withConditionCafeID] ?? 0
            cell.updateUI(cafe: withConditionCafe, distance: withConditionDistance)
        }
        
        //為了辨識哪個Cell的button而設的
        cell.delegate = self
        cell.index = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return self.view.frame.height * (120/690)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.conditionDicFromSearchVCorResetConditionVC == [:] || self.conditionDicFromSearchVCorResetConditionVC == ["安靜程度": "不限", "座位多寡": "不限", "有無插座": "不限", "Wifi品質": "不限"]{
            performSegue(withIdentifier: SegueManager.performGoogleMap, sender: self.cafeArray![indexPath.row])
        }else{
            performSegue(withIdentifier: SegueManager.performGoogleMap, sender: self.withConditionArray![indexPath.row])
        }
    }

}
extension CafeListViewController: WhichCafeFBButtonDidTappedDelegate{
    func whichFBButtonDidTapped(index: IndexPath) {
        if self.conditionDicFromSearchVCorResetConditionVC == [:] || self.conditionDicFromSearchVCorResetConditionVC == ["安靜程度": "不限", "座位多寡": "不限", "有無插座": "不限", "Wifi品質": "不限"]{
            performSegue(withIdentifier: SegueManager.performFB, sender: self.cafeArray?[index.row])
        }else{
            performSegue(withIdentifier: SegueManager.performFB, sender: self.withConditionArray?[index.row])
        }
    }

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == SegueManager.performFB{
                guard let fbWebVC = segue.destination as? WebViewController else {return}
                if let sender = sender as? Cafe{
                    fbWebVC.selectedCafeFromCafeListVC = sender
                }
            }
            if segue.identifier == SegueManager.performResetConditionVC{
//                guard let resetConditionNavigationController = segue.destination as? UINavigationController else {return}
//                guard let resetConditionVC = resetConditionNavigationController.viewControllers.first as? PresentResetConditionViewController else {return}
//                resetConditionVC.delegate = self
            }
            //跳轉到googleMap
            if segue.identifier == SegueManager.performGoogleMap{
                guard let googleMapVC = segue.destination as? GoogleMapViewController else {return}
                if let sender = sender as? Cafe{
                    googleMapVC.userLocationFromPreviousPage = self.locationFromSearchVC
                    googleMapVC.selectedCafeInformationFromCafeListsVC = sender
                }
            }
        }
    
}
extension CafeListViewController: PassResetConditionDelegate{
    func passResetCityDelegate(resetCity: City) {
        self.cityBeSelectedFromSearchVC = resetCity.cityEnglishName.lowercased()
    }
    func passResetConditionDelegate(resetConditionDic: [String : String]) {
        self.conditionDicFromSearchVCorResetConditionVC = resetConditionDic
    }
    
    
}
