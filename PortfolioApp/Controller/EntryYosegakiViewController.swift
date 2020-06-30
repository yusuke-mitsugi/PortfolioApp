//
//  EntryYosegakiViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/06/28.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit

class EntryYosegakiViewController: UIViewController {
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
    
    public var completion: ((String, String) -> Void)?
    var update: (() -> Void)?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleField.becomeFirstResponder()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapSave))
    }
    
    
    @objc func didTapSave() {
        
        if let text = titleField.text, !text.isEmpty, !noteField.text!.isEmpty {
            completion?(text, noteField.text!)
        }
        //        guard let count = UserDefaults.standard.value(forKey: "count") as? Int else {
        //            return
        //        }
        //        let newCount = count + 1
    //        UserDefaults
        }

}
