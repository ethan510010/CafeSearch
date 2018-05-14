//
//  ChooseModeViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/10.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import CoreLocation

struct NotificationLocation {
    static let location = "location"
}

class ChooseModeViewController: UIViewController {
    
    
    @IBAction func searchConditionAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: SegueManager.performSearchConditionVC, sender: nil)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var modeSegment: UISegmentedControl!
    
    //現在的座標
    var currentLocation:CLLocation?
    //現在的座標得到的城市
    var currentCity:String? = ""
    var locationManager: CLLocationManager?
    //下方ScrollView切換
    var scrollPage:Int = 0
    
    @IBAction func modeChooseAction(_ sender: UISegmentedControl) {
        self.scrollPage = sender.selectedSegmentIndex
        scrollView.setContentOffset(CGPoint(x: self.view.frame.width * CGFloat(scrollPage), y: 0), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.requestWhenInUseAuthorization()
        print("最外面的ViewController",self.currentCity)
        self.scrollView.delegate = self
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.showsHorizontalScrollIndicator = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 2, height: self.view.frame.height * (617/667))
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        //把mapVC加進去
        let mapVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIDManager.mapVC) as! MapModeViewController
        self.addChildViewController(mapVC)
        self.scrollView.addSubview(mapVC.view)
        mapVC.didMove(toParentViewController: self)
        //把listVC加進去
        let listVC = mainStoryboard.instantiateViewController(withIdentifier: StoryboardIDManager.listVC) as! ListViewController
        self.addChildViewController(listVC)
        self.scrollView.addSubview(listVC.view)
        listVC.didMove(toParentViewController: self)
        var frameOfListVC = listVC.view.frame
        frameOfListVC.origin.x = self.view.frame.width
        listVC.view.frame = frameOfListVC
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension ChooseModeViewController: UIScrollViewDelegate{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        //讓滑動下面時上面的segment跟著動
        self.modeSegment.selectedSegmentIndex = self.scrollPage
    }
}
extension ChooseModeViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse{
            guard let coordinate = manager.location?.coordinate else {return}
            let userLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let userLatitude = userLocation.coordinate.latitude
            let userLongitude = userLocation.coordinate.longitude
            self.currentLocation = userLocation
            //把座標轉成地址
            CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarkArray, error) in
                guard let currentAddress = placemarkArray?.first else {return}
                guard let currentPostCode = currentAddress.postalCode else {return}
                let currentCity = currentPostCode.convertPostcodeToRegion(postCode: Int(currentPostCode)!)
                self.currentCity = currentCity.lowercased()
                //抓到位置後發出通知
                NotificationCenter.default.post(name: .getLocationNotification, object: nil, userInfo: [NotificationLocation.location : userLocation])
            }
        }
    }
}

