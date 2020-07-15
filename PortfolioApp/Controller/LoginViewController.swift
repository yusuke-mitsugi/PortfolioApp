//
//  LoginViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/05/16.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import Firebase
import Photos
import JGProgressHUD
import NendAd



class LoginViewController: UIViewController, NADViewDelegate {
    
     private var nadView: NADView!
    
    let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "login")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Log In"
        view.backgroundColor = .white
        
        self.view.addSubview(imageView)
        self.view.addSubview(loginButton)
        
        loginButton.setTitle("Log In", for: .normal)
        loginButton.backgroundColor = .link
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        
        // NADViewクラスを生成
//        nadView.frame = CGRect(x: 0, y: view.frame.size.height-50, width: view.frame.size.width, height: 50)
//        nadView = NADView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
        nadView = NADView(frame: CGRect(x: 0,
                                        y: view.frame.size.height-50,
                                        width: view.frame.size.width,
                                        height: 50))
        nadView.backgroundColor = .secondarySystemBackground
        // 広告枠のspotIDとapiKeyを設定(必須)
        nadView.setNendID("ac57c9b8b460aa72a2644742dc29072a5e2333ce", spotID: "1003811")
        // delegateを受けるオブジェクトを指定(必須)
        nadView.delegate = self
                // 読み込み開始(必須)
                nadView.load()
                // 通知有無にかかわらずViewに乗せる場合
                self.view.addSubview(nadView)
        
       PHPhotoLibrary.requestAuthorization { (status) in
            switch(status) {
            case .authorized:
                print("許可されています")
            case .denied:
                print("拒否されています")
            case .notDetermined:
                print("決まっていません")
            case .restricted:
                print("制限されています")
            @unknown default:
                fatalError()
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        view.frame = view.bounds
        let size = view.width/3
        imageView.frame = CGRect(x: (view.width-size)/2,
                                 y: 220,
                                 width: size,
                                 height: size)
        loginButton.frame = CGRect(x: 30,
                                   y: imageView.bottom+20,
                                   width: view.width-60,
                                   height: 52)
        nadView = NADView(frame: CGRect(x: 0, y: 0, width: 320, height: 50))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nadView.resume()
    }
    
    
    
    @IBAction func login(_ sender: Any) {
        
        spinner.show(in: view)
        Auth.auth().signInAnonymously { (authResult, error) in
            let user = authResult?.user
            self.spinner.dismiss()
            print(user as Any)
            //画面遷移
            let messageVC = self.storyboard?.instantiateViewController(identifier: "messageVC") as! MessageListViewController
            self.navigationController?.pushViewController(messageVC, animated: true)
        }
    }
    
    
    
}
