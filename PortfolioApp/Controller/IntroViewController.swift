//
//  IntroViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/05/14.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import Lottie


class IntroViewController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var onboardArray = ["1","2","3","4","5"]
    
    var onboardStringAray = ["オンラインで寄せ書き♡","お世話になった職場の方へ","結婚祝いや出産祝いに","感謝の気持ちを伝えたい","Thank you for everything"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //ページを作れる
        scrollView.isPagingEnabled = true
        
        setUpScroll()
        
        for i in 0...4 {
            
            let animationView = AnimationView()
            let animation = Animation.named(onboardArray[i])
            
            animationView.center = self.view.center
            
            animationView.frame = CGRect(x: CGFloat(i) * view.frame.size.width,
                                         y: 0,
                                         width: view.frame.size.width,
                                         height: view.frame.size.height)
            
            animationView.animation = animation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
            scrollView.addSubview(animationView)
        }
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    
    
    func setUpScroll() {
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.size.width * 5,
                                        height: 0)
        
        for i in 0...4 {
            
            let onboardLabel = UILabel(frame: CGRect(x: CGFloat(i) * view.frame.size.width+10,
                                                     y: view.frame.size.height-160,
                                                     width: view.frame.size.width-20,
                                                     height: 50))
            
            onboardLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            onboardLabel.textAlignment = .center
            onboardLabel.text = onboardStringAray[i]
            scrollView.addSubview(onboardLabel)
        }
    }
    
    
    
    
    
    
    
}
