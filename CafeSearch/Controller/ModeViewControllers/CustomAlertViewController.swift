//
//  CustomAlertViewController.swift
//  CafeSearch
//
//  Created by EthanLin on 2018/6/15.
//  Copyright © 2018 EthanLin. All rights reserved.
//

import UIKit

protocol AlertViewButtonTappedDelegate:class {
    func goAppStoreButtonDidTapped()
    func cancelButtonDidTapped()
}

class CustomAlertViewController: UIViewController {
    
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    var alertDelegate:AlertViewButtonTappedDelegate?
    
    @IBAction func downloadAPPAction(_ sender: UIButton) {
        alertDelegate?.goAppStoreButtonDidTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
        alertDelegate?.cancelButtonDidTapped()
        self.dismiss(animated: true, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        alertView.layer.cornerRadius = 20
        alertView.layer.masksToBounds = true
        alertView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.alertView.alpha = 1.0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
