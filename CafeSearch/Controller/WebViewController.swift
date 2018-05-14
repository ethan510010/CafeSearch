//
//  WebViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/5/7.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {

    var selectedCafeFromCafeListVC:Cafe?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let wkWebViewFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let fbWebView = WKWebView(frame: wkWebViewFrame)
        guard let validSelectedCafe = selectedCafeFromCafeListVC else {return}
        print(validSelectedCafe.url)
        guard let validFBURL = URL(string: validSelectedCafe.url) else {return}
        
        let urlRequest = URLRequest(url: validFBURL)
        fbWebView.load(urlRequest)
        view.addSubview(fbWebView)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
