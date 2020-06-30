//
//  PostViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/05/19.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostViewController: UIViewController {
    
    var passedImage = UIImage()
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentImageView.frame = CGRect(x: 0,
                                        y: 100,
                                        width: view.frame.size.width,
                                        height: view.frame.size.width)
        
        ref = Database.database().reference()
        contentImageView.image = passedImage
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    @IBAction func postAction(_ sender: Any) {
        
        //DBのchildを決める
        let timeLineDB = Database.database().reference().child("timeLine").childByAutoId()
        //        var reference: DatabaseReference!
        ref = Database.database().reference()
        let keyValue = self.ref.child("timeLine").childByAutoId().key
        print("PostActionを押された時のautoId: \(keyValue!)")
        //ストレージサーバーのURLを取得する
        let storage = Storage.storage().reference(forURL: "gs://yosegakiapp-97cab.appspot.com")
        //フォルダを作る。フォルダの中に画像に入っていく
        let key = timeLineDB.child("timeLine").childByAutoId().key
        let imageRef = storage.child("Contents").child("\(String(describing: key!)).jpeg")
        //　データ型
        var contentImageData:Data = Data()
        if contentImageView.image != nil {
            contentImageData = (contentImageView.image?.jpegData(compressionQuality: 0.01))!
        }
        //最初のストレージに画像を送る段階. metaDataの中に入らないと先には進めない
        let upLoadTask = imageRef.putData(contentImageData, metadata: nil) {
            (metaData, error) in
            if error != nil {
                print("エラー: error")
                return
            }
            //ストレージに送った画像URLを受け取る
            imageRef.downloadURL { (url, error) in
                if url != nil {
                    //キーバリュー型でDBに送信するデータを準備をする　Stringで渡さなきゃいけない！
                    let  timeLineInfo = [
                        "Contents":url?.absoluteString as Any,
                        "autoId": keyValue as Any
                        ] as [String:Any]
                    print("DB送信直前のautoId: \(keyValue!)")
                    // autIdを取得
                    self.ref.child("timeLine").child(keyValue!).setValue(timeLineInfo)
                    print("DB送信情報: \(timeLineInfo)")
                    //下の１行でDBに送信したという意味
                    // timeLineDB.updateChildValues(timeLineInfo)
                    print("DB送信後のautoId: \(keyValue!)")
                    //これでnavigationControllerで画面遷移した時に戻るという指示
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        //続けてください
        upLoadTask.resume()
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
