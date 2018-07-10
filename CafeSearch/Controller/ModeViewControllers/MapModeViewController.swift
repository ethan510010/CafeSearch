//
//  MapModeViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class MapModeViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    //利用id存成一個對應的距離dictionary
    var distanceDic = [String:Double]()
    //儲存條件與地點等資訊
    var cafeArray:[Cafe]?
    var locationManager: CLLocationManager?
    var currentCity:String? = ""
    var currentLocation:CLLocation?
    var conditionFromSettingVCDic:[String:String] = [String:String]()
    @IBAction func findNearestCafeAction(_ sender: UIButton) {
        //找出距離最近的咖啡店
        guard let nearestCafe = cafeArray?.first else {return}
        
        guard let nearestCafeLat = nearestCafe.latitude, let nearestCafeLog = nearestCafe.longitude else {return}
        
        let nearestCafeLatitude = CLLocationDegrees(nearestCafeLat)
        let nearestCafeLongitude = CLLocationDegrees(nearestCafeLog)
        let nearestCafeLocation = CLLocation(latitude: nearestCafeLatitude!, longitude: nearestCafeLongitude!)
        let nearestCafePosition = CLLocationCoordinate2D(latitude: nearestCafeLatitude!, longitude: nearestCafeLongitude!)
        let nearestCafeDistance = nearestCafeLocation.distance(from: self.currentLocation!)
        let roundDistance = round(nearestCafeDistance)
        let cafeMarker = GMSMarker(position: nearestCafePosition)
        cafeMarker.map = self.mapView
        cafeMarker.title = nearestCafe.name
        cafeMarker.snippet = "\(nearestCafe.address),距離:\(roundDistance/1000)km"
        //地圖會移動到這個位置
        let sydney = GMSCameraPosition.camera(withLatitude: nearestCafeLatitude!, longitude: nearestCafeLongitude!, zoom: 14)
        self.mapView.camera = sydney
//        self.mapView.animate(toViewingAngle: 10)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.layer.opacity = 0.5
        mapView.layer.cornerRadius = 20
        mapView.layer.masksToBounds = true
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        //接收最一開始定位後傳過來的通知
        NotificationCenter.default.addObserver(self, selector: #selector(getLocationForAPI), name: .getLocationNotification, object: nil)
        //接收傳過來的條件與城市通知
        NotificationCenter.default.addObserver(self, selector: #selector(getConditionAndCityNotification), name: .passConditionToMapVCAndListVCNotification, object: nil)
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
        }
    }
    
    @objc func getConditionAndCityNotification(notification:Notification){
        guard let notificationUserInfo = notification.userInfo else {return}
        guard let selectedConditions = notificationUserInfo[NotificationCondiitonAndCity.conditionNotification] as? [String:String] else {return}
        self.conditionFromSettingVCDic = selectedConditions
        print("地圖接收到設定條件",self.conditionFromSettingVCDic)
        guard let selectedCity = notificationUserInfo[NotificationCondiitonAndCity.cityNotification] as? City else {
            print("沒有重新選城市")
            return}
        self.currentCity = selectedCity.cityEnglishName.lowercased()
        print("地圖接收到新城市",self.currentCity!)
        self.sendAPIRequest()
    }
    
    //發送API請求
    func sendAPIRequest(){
        APIManager.shared.fetchCafe(url: URLManager.cafeURL + "/\(self.currentCity!)") { (cafes) in
            self.cafeArray = cafes
            var cafeDistances = self.cafeArray?.map({ (cafe) -> (Cafe?, CLLocationDistance) in
                guard let cafeLat = cafe.latitude, let cafeLog = cafe.longitude else {fatalError()}
                if let cafeLatitude = CLLocationDegrees(cafeLat), let cafeLongitude = CLLocationDegrees(cafeLog), let userLocation = self.currentLocation{
                    let cafeLocation = CLLocation(latitude: cafeLatitude, longitude: cafeLongitude)
                    let cafeDistance = cafeLocation.distance(from: userLocation)
                    guard let cafeID = cafe.id else {fatalError()}
                    self.distanceDic[cafeID] = cafeDistance
                    return (cafe, cafeDistance)
                }else{
                    return (nil,0)
                }
            })
            cafeDistances?.sort(by: { (cafeTuple1, cafeTuple2) -> Bool in
                return cafeTuple1.1 < cafeTuple2.1
            })
            if let cafeDistances = cafeDistances {
                if self.conditionFromSettingVCDic == [:] || self.conditionFromSettingVCDic == ["安靜程度":"不限","座位多寡":"不限","有無插座":"不限","Wifit品質":"不限"]{
                    self.cafeArray = cafeDistances.map({ (cafeTuple) -> Cafe? in
                        guard let eachCafe = cafeTuple.0 else { return nil }
                        return eachCafe
//                        return cafeTuple.0!
                    }) as? [Cafe]
                }else{
                    //避免距離排序亂掉要再存一次
                    self.cafeArray = cafeDistances.map({ (cafeTuple) -> Cafe? in
                        guard let eachCafe = cafeTuple.0 else {return nil}
                        return eachCafe
//                        return cafeTuple.0!
                    }) as? [Cafe]
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
                                        guard let wifiValue = cafe.wifi else {fatalError()}
                                        if wifiValue > Double(3){
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
                                        guard let quietValue = cafe.quiet else {fatalError()}
                                        if quietValue > Double(3){
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
                                        guard let seatValue = cafe.seat else {fatalError()}
                                        if seatValue > Double(3){
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
                
            }
        }
    }
    
    func showConditionCafesOnMap(){
        guard let conditionCafesNumber = self.cafeArray?.count else {return}
        let range = 0...conditionCafesNumber
        for i in range{
            guard let eachCafe = self.cafeArray?[i] else {return}
            guard let eachCafeLat = eachCafe.latitude, let eachCafeLog = eachCafe.longitude else {return}
            guard let eachCafeLatitude = CLLocationDegrees(eachCafeLat) else {return}
            guard let eachCafeLongitude = CLLocationDegrees(eachCafeLog) else {return}
            let eachCafeLocation = CLLocationCoordinate2D(latitude: eachCafeLatitude, longitude: eachCafeLongitude)
            let cafeMarker = GMSMarker(position: eachCafeLocation)
            cafeMarker.map = self.mapView
            cafeMarker.title = eachCafe.name
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.sendAPIRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension MapModeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            guard let coordinate = manager.location?.coordinate else {return}
            let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let userLatitude = userLocation.coordinate.latitude
            let userLongitude = userLocation.coordinate.longitude
            let camera = GMSCameraPosition.camera(withLatitude: userLatitude, longitude: userLongitude, zoom: 16.0)
            mapView.camera = camera
            mapView.isMyLocationEnabled = true
            self.currentLocation = userLocation
            //把座標轉成地址
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarkArray, error) in
                guard let currentAddress = placemarkArray?.first else {return}
                guard let currentPostCode = currentAddress.postalCode else {return}
                let currentCity = currentPostCode.convertPostcodeToRegion(postCode: Int(currentPostCode)!)
//                self.currentCity = currentCity.lowercased()
            }
        }
    }
}
