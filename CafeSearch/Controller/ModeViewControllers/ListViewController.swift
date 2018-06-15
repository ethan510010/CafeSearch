//
//  ListViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import CoreLocation

class ListViewController: UIViewController {
    
    @IBOutlet weak var cafeListTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //設定activity Indicator
    var activityIndicator:UIActivityIndicatorView!
    
    var distanceDic = [String:Double]()
    var cafeArray:[Cafe]?
    var locationManager: CLLocationManager?
    var currentCity:String = ""
    var currentLocation:CLLocation?
    var conditionFromSettingVCDic:[String:String] = [String:String]()
    lazy var searchResult:[Cafe] = []
    //搜尋功能
    //    var searchController:UISearchController!
    //    搜尋後的結果
    //    var searchResults:[Cafe] = []{
    //        didSet{
    //            self.listTableViewReload()
    //        }
    //    }
    
    //配合搜尋可以進行過濾
    //    func searchFilterContent(for searchText: String){
    //        searchResults = (cafeArray?.filter({ (cafe) -> Bool in
    //            let isMatch = cafe.name.localizedCaseInsensitiveContains(searchText)
    //            return isMatch
    //        }))!
    //    }
    
    //用來RelaodTableView的function
    func listTableViewReload(){
        DispatchQueue.main.async {
            self.cafeListTableView.reloadData()
            self.cafeListTableView.estimatedRowHeight = 0
            self.cafeListTableView.estimatedSectionHeaderHeight = 0
            self.cafeListTableView.estimatedSectionFooterHeight = 0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //設定activityIndicator
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.center = self.view.center
        self.view.addSubview(activityIndicator)
        self.activityIndicator.startAnimating()
        
        cafeListTableView.delegate = self
        cafeListTableView.dataSource = self
        cafeListTableView.separatorStyle = .none
        //接收一開始定位後的通知
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationForAPI), name: .getLocationNotification, object: nil)
        
        //接收傳過來條件與城市通知
        NotificationCenter.default.addObserver(self, selector: #selector(getConditionAndCityNotification), name: .passConditionToMapVCAndListVCNotification, object: nil)
        
        //設定searchBar
        searchBar.delegate = self
        searchBar.placeholder = "搜尋店名"
        //1. searchBar的樣式
        searchBar.tintColor = UIColor.white
        searchBar.barTintColor = UIColor.clear
        if let searchField = searchBar.value(forKey: "searchField") as? UITextField{
            searchField.backgroundColor = UIColor.black
            searchField.layer.cornerRadius = 10
            searchField.layer.borderColor = UIColor.white.cgColor
            searchField.layer.borderWidth = 2
            searchField.layer.masksToBounds = true
        }
        //初始化SearchController，並將結果顯示在同一頁，所以後面傳入nil
        //        searchController = UISearchController(searchResultsController: nil)
        //         搜尋時是否使用燈箱效果 (會將畫面變暗以集中搜尋焦點)
        //        searchController.dimsBackgroundDuringPresentation = false
        //        搜尋時隱藏navigationbar
        //        searchController.hidesNavigationBarDuringPresentation = false
        //        接著把Searchbar加到tableView的Header
        //        cafeListTableView.tableHeaderView = searchController.searchBar
        //        searchController.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.cafeListTableView.contentInset = UIEdgeInsetsMake(0, 0, (self.navigationController?.navigationBar.frame.height)!, 0)
//        self.cafeListTableView.frame.size = CGSize(width: self.view.frame.width, height: self.view.frame.height)
//        self.view.layoutIfNeeded()
    }
    
    @objc func getConditionAndCityNotification(notification:Notification){
        guard let notificationUserInfo = notification.userInfo else {return}
        guard let selectedConditions = notificationUserInfo[NotificationCondiitonAndCity.conditionNotification] as? [String:String] else {return}
        self.conditionFromSettingVCDic = selectedConditions
        print("設定條件",self.conditionFromSettingVCDic)
        guard let selectedCity = notificationUserInfo[NotificationCondiitonAndCity.cityNotification] as? City else {
            print("沒有重新選城市")
            return}
        self.currentCity = selectedCity.cityEnglishName.lowercased()
        print("重新選城市",self.currentCity)
        self.sendAPIRequest()
    }
    
    func sendAPIRequest(){
        APIManager.shared.fetchCafe(url: URLManager.cafeURL + "/\(self.currentCity)") { (cafes) in
            self.cafeArray = cafes
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
            }
            var cafeDistances = self.cafeArray?.map({ (cafe) -> (Cafe?, CLLocationDistance) in
                if let cafeLatitude = CLLocationDegrees(cafe.latitude), let cafeLongitude = CLLocationDegrees(cafe.longitude), let userLocation = self.currentLocation{
                    let cafeLocation = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude)
                    let cafeDistance = cafeLocation.distance(from: userLocation)
                    self.distanceDic[cafe.id] = cafeDistance
                    return (cafe, cafeDistance)
                }else{
                    return (nil,0)
                }
            })
            cafeDistances?.sort(by: { (cafeTuple1, cafeTuple2) -> Bool in
                return cafeTuple1.1 < cafeTuple2.1
            })
            if let cafeDistances = cafeDistances {
                if self.conditionFromSettingVCDic == [:] || self.conditionFromSettingVCDic == ["安靜程度": "不限", "座位多寡": "不限", "有無插座": "不限", "Wifi品質": "不限"]{
                    self.cafeArray = cafeDistances.map({ (cafeTuple) -> Cafe in
                        return cafeTuple.0!
                    })
                }else{
                    //避免距離排序亂掉要再存一次
                    self.cafeArray = cafeDistances.map({ (cafeTuple) -> Cafe in
                        return cafeTuple.0!
                    })
                    //篩選條件
                    self.conditionFromSettingVCDic.forEach({ (conditionKey,conditionValue) in
                        if conditionValue != "不限"{
                            switch conditionKey{
                            case "Wifi品質":
                                if conditionValue == "普通"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.wifi == 3{
                                            return true
                                        }else{
                                            return false
                                        }
                                    }).map({ (cafe) -> Cafe in
                                        return cafe
                                    })
                                }else if conditionValue == "優良"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if (cafe.wifi) > Double(3){
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
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.quiet == 3{
                                            return true
                                        }else {
                                            return false
                                        }
                                    })
                                }else if conditionValue == "優良"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.quiet > Double(3){
                                            return true
                                        }else {
                                            return false
                                        }
                                    })
                                }
                            case "有無插座":
                                if conditionValue == "普通"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.socket == "maybe"{
                                            return true
                                        }else{
                                            return false
                                        }
                                    }).map({ (cafe) -> Cafe in
                                        return cafe
                                    })
                                }else if conditionValue == "優良"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.socket == "yes"{
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
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.seat == 3{
                                            return true
                                        }else {
                                            return false
                                        }
                                    }).map({ (cafe) -> Cafe in
                                        return cafe
                                    })
                                }else if conditionValue == "優良"{
                                    self.cafeArray = self.cafeArray?.filter({ (cafe) -> Bool in
                                        if cafe.seat > Double(3){
                                            return true
                                        }else {
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
                    
                }
                self.searchResult = self.cafeArray!
                self.listTableViewReload()
            }
        }
        
    }
    
    @objc func getLocationForAPI(notification:Notification){
        if let location = notification.userInfo![NotificationLocation.location], let okLocation = location as? CLLocation{
            CLGeocoder().reverseGeocodeLocation(okLocation) { (placemarkArray, error) in
                guard let currentAddress = placemarkArray?.first else {return}
                guard let currentPostCode = currentAddress.postalCode else {return}
                let currentCity = currentPostCode.convertPostcodeToRegion(postCode: Int(currentPostCode)!)
                self.currentCity = currentCity
                print("List VC",self.currentCity)
                //進行網路請求
                self.locationManager = CLLocationManager()
                self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
                self.locationManager?.delegate = self
                self.sendAPIRequest()
            }
            //            self.currentCity = okLocation.
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.locationManager = CLLocationManager()
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.delegate = self
        
        
        
        //        self.sendAPIRequest()
        //回來時在把searchbar隱藏取消掉
        //        self.searchController.searchBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("CafeListVCTableView高",self.cafeListTableView.frame.height)
    }
    
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //Case1. 用searchController
        //        if searchController.isActive{
        //            return searchResults.count
        //        }else{
        //            guard let numberOfCafes = self.cafeArray?.count else {return 0}
        //            return numberOfCafes
        //        }
        //Case2. 不用search功能
        //        guard let numberOfCafes = self.cafeArray?.count else {return 0}
        //        return numberOfCafes
        //Case3. 用searchBar
        return self.searchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Case1. 用searchController
        //        let cafe = (searchController.isActive) ? searchResults[indexPath.row]: cafeArray![indexPath.row]
        //Case2. 不用搜尋功能
        //        let cafe = self.cafeArray![indexPath.row]
        //Case3. 用searchBar
        let cafe = self.searchResult[indexPath.row]
        let distance = distanceDic[cafe.id] ?? 0
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifierManager.cafeListCell, for: indexPath) as! CafeListCell
        cell.updateUI(cafe: cafe, distance: distance)
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height * (120/560)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Case3. 用searchBar
        let selectedCafe = self.searchResult[indexPath.row]
        //Case2. 不用search功能
        //        guard let selectedCafe = self.cafeArray?[indexPath.row] else {return}
        //Case1. 用searchController
        //        let selectedCafe = (searchController.isActive) ? searchResults[indexPath.row] : self.cafeArray![indexPath.row]
        //        跳轉頁面同時把SearchController的searbar隱藏起來
        //        self.searchController.searchBar.isHidden = true
        performSegue(withIdentifier: SegueManager.performCafeDetail, sender: selectedCafe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueManager.performCafeDetail{
            guard let cafeDetailVC = segue.destination as? CafeDetailViewController else {return}
            //把使用者的現在的位置傳過去
            cafeDetailVC.userLocationFromPreviousPage = self.currentLocation
            if let sender = sender as? Cafe{
                cafeDetailVC.selectedCafeInformationFromCafeListsVC = sender
            }
            
        }
    }
}
extension ListViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            guard let coordinate = manager.location?.coordinate else {return}
            let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let userLatitude = userLocation.coordinate.latitude
            let userLongitude = userLocation.coordinate.longitude
            //使用者現在位置
            self.currentLocation = userLocation
            //把座標轉成地址
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarkArray, error) in
                if error != nil{
                    return
                }
                guard let currentAddress = placemarkArray?.first else {return}
                guard let currentPostCode = currentAddress.postalCode else {return}
                let currentCity = currentPostCode.convertPostcodeToRegion(postCode: Int(currentPostCode)!)
                //                self.currentCity = currentCity.lowercased()
            }
        }
    }
}
//extension ListViewController: UISearchResultsUpdating{
//    //遵守搜尋列Delegate的方法
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text{
//            self.searchFilterContent(for: searchText)
//        }
//    }
//}
extension ListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            self.searchResult = self.cafeArray!
        }else{
            searchResult = []
            for eachCafe in self.cafeArray!{
                if eachCafe.name.lowercased().contains(searchText.lowercased()){
                    searchResult.append(eachCafe)
                }
            }
        }
        cafeListTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchResult = self.cafeArray!
        self.cafeListTableView.reloadData()
    }
    
}
