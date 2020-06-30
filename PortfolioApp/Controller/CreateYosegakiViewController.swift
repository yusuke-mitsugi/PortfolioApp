////
////  CreateYosegakiViewController.swift
////  PortfolioApp
////
////  Created by Yusuke Mitsugi on 2020/06/28.
////  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
////
//
//import UIKit
//
//class CreateYosegakiViewController: UIViewController {
//
//    @IBOutlet var titleLabel: UILabel!
//    @IBOutlet var noteLabel: UITextView!
//
//    public var noteTitle: String = ""
//    public var note: String = ""
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "決定",
//                                                            style: .done,
//                                                            target: self,
//                                                            action: #selector(didTapSave))
//
//        titleLabel.text = noteTitle
//        noteLabel.text = note
//    }
//
//
//
//    @objc func didTapSave() {
//
//        NotificationCenter.default.post(name: Notification.Name("text"), object: [titleLabel.text, noteLabel.text])
//
//        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
//    }
//
//
//
//}
