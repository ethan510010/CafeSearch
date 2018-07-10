//
//  CafeDetailViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/13.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import GoogleMaps

class CafeDetailViewController: UIViewController {
    
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var quietLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var socketLabel: UILabel!
    @IBOutlet weak var googleMapView: GMSMapView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var intermediateView: UIView!
    
    
    //選擇的咖啡店
    var selectedCafeInformationFromCafeListsVC:Cafe?
    //使用者的座標(接收前一頁傳過來的)(從ListViewController過來的)
    var userLocationFromPreviousPage:CLLocation?
    //想要把這邊的位置丟到街景頁而設的變數
    var cafeLocation: CLLocationCoordinate2D?
    
    @IBAction func navigateCafeOnGoogleMap(_ sender: UIButton) {
        guard let userLocation = self.userLocationFromPreviousPage else {return}
        guard let cafeLocation = self.cafeLocation else { return }
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps-x-callback://")!)) {
            UIApplication.shared.openURL(URL(string:
                "comgooglemaps-x-callback://?saddr=\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)&daddr=\(cafeLocation.latitude),\(cafeLocation.longitude)&directionsmode=driving&x-success=sourceapp://?resume=true&x-source=SourceApp")!)
        } else {
            let customAlertVC = CustomAlertViewController()
            customAlertVC.providesPresentationContextTransitionStyle = true
            customAlertVC.definesPresentationContext = true
            customAlertVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
            customAlertVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            customAlertVC.alertDelegate = self
            self.present(customAlertVC, animated: true, completion: nil)
//            let alert = UIAlertController(title: "找不到Google Maps應用程式", message: "請確認您是否已安裝Google Maps應用程式", preferredStyle: .alert)
//            let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            //到appStore下載Google Maps
//            let goAppStoreAction = UIAlertAction(title: "下載Google Maps", style: .default) { (action) in
//                guard let url = URL(string: "https://itunes.apple.com/US/app/google-maps-gps-navigation/id585027354?mt=8") else {return}
//                if UIApplication.shared.canOpenURL(url){
//                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
//                }
//            }
//            alert.addAction(action)
//            alert.addAction(goAppStoreAction)
//            self.present(alert, animated: true, completion: nil)
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.layer.opacity = 0.7
        intermediateView.layer.opacity = 0.5
        googleMapView.layer.cornerRadius = googleMapView.frame.width / 10
        googleMapView.layer.masksToBounds = true
        guard let selectedCafe = self.selectedCafeInformationFromCafeListsVC else {return}
        guard let cafeLat = selectedCafe.latitude, let cafeLog = selectedCafe.longitude else {return}
        guard let cafeLatitude = CLLocationDegrees(cafeLat) else {return}
        guard let cafeLogitude = CLLocationDegrees(cafeLog) else {return}
        let camera = GMSCameraPosition.camera(withLatitude: cafeLatitude, longitude: cafeLogitude, zoom: 18.0)
        googleMapView.camera = camera
        //新增大頭針
        let cafePosition = CLLocationCoordinate2D(latitude: cafeLatitude, longitude: cafeLogitude)
        self.cafeLocation = cafePosition
        let cafeMarker = GMSMarker(position: cafePosition)
        cafeMarker.map = googleMapView
        cafeMarker.title = selectedCafe.name
        //設定各個Label顯示內容
        guard let wifi = self.selectedCafeInformationFromCafeListsVC?.wifi else {return}
        self.wifiLabel.text = "Wifi品質: \(wifi)/5"
        guard let quiet = self.selectedCafeInformationFromCafeListsVC?.quiet else {return}
        self.quietLabel.text = "安靜程度: \(quiet)/5"
        guard let seat = self.selectedCafeInformationFromCafeListsVC?.seat else {return}
        self.seatLabel.text = "座位多寡: \(seat)/5"
        //有無插座的label處理
        guard let socket = self.selectedCafeInformationFromCafeListsVC?.socket else {return}
        if socket == "no"{
            self.socketLabel.text = "有無插座: 很少"
        }else if socket == "maybe"{
            self.socketLabel.text = "有無插座: 視座位而定"
        }else if socket == "yes"{
            self.socketLabel.text = "有無插座: 很多"
        }else{
            self.socketLabel.text = "有無插座: 沒有資料"
        }
        //讓NavigationItem的標題為咖啡店名稱
        self.navigationItem.title = self.selectedCafeInformationFromCafeListsVC?.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

extension CafeDetailViewController: AlertViewButtonTappedDelegate{
    func goAppStoreButtonDidTapped() {
        guard let url = URL(string: "https://itunes.apple.com/US/app/google-maps-gps-navigation/id585027354?mt=8") else {return}
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func cancelButtonDidTapped() {
        print("按下取消按鈕")
    }
    
    
}
