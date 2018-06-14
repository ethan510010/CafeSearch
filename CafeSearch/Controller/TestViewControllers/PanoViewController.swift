//
//  PanoViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/8.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import GoogleMaps

class PanoViewController: UIViewController {
    
    @IBOutlet weak var panoView: GMSPanoramaView!
    //接受前面一個畫面過來的CLLocationCoordinate2D
    var locationFromGoogleMapVC: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let locationFromGoogleMapVC = self.locationFromGoogleMapVC else {return}
        GMSPanoramaService().requestPanoramaNearCoordinate(locationFromGoogleMapVC) { (pano, error) in
            if error != nil{
                print(error!.localizedDescription)
                return
            }
            self.panoView.panorama = pano
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
