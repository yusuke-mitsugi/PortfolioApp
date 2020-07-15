//
//  MessageListViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/05/19.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage
import AlamofireImage

import YPImagePicker
import AVFoundation
import AVKit
import Photos





class MessageListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
     var selectedItems = [YPMediaItem]()
    
    var postArray = [Contents]()
    var contentImageString = String()
    var imageURLString = String()
    let refresh = UIRefreshControl()
    var selectedImage = UIImage()
    
    var autoId = String()
    var ref: DatabaseReference!
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cameraButton: UIButton!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self,
                                            action: #selector(didPullToRefresh),
                                            for: .valueChanged)
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        fetchContentsData()
        tableView.reloadData()
    }
    
    //画面遷移
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //deatailVCをインスタンス化する
        let detailVC = segue.destination as! DetailViewController
        detailVC.contentImage = contentImageString
    }
    
    
    @objc func didPullToRefresh() {
        //        tableView.reloadData()
        //        refresh.beginRefreshing()
        // Re- fetchData
        print("start Refresh")
        fetchContentsData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
   //タッチされて、画面遷移
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        contentImageString = postArray[indexPath.row].contentImageString
        print("選択された寄せ書き: \(contentImageString)")
//        let post = postArray[indexPath.row]
        guard let vc = storyboard?.instantiateViewController(identifier: "detailVC") as? DetailViewController else {
            return
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.title = "Yosegaki Create"
        vc.contentImage = contentImageString
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.width
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .blue
        let contentImageView = cell.viewWithTag(1) as! UIImageView
        contentImageView.sd_setImage(with: URL(string: postArray[indexPath.row].contentImageString, relativeTo: nil))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    //消去
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deletePost(delete: indexPath)
            tableView.deleteRows(at: [indexPath as IndexPath], with: .fade)
        }
    }
    
    
    
    
    
    func deletePost(delete indexPath: IndexPath) {
        ref = Database.database().reference()
        //        let keyValue = ref.child("timeLine").child("autoId").key
        self.ref.child("timeLine").child(postArray[indexPath.row].autoId).removeValue()
        print("DB削除: \(autoId)")
        postArray.remove(at: indexPath.row)
    }
    
    
    @IBAction func cameraAction(_ sender: Any) {
        
        showAlert()
    }
    
    
    func doCamera() {
        //カメラ立ち上げメソッド
        let sourceType:UIImagePickerController.SourceType = .camera
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //アルバムメソッド
    func doAlbum() {
        let sourceType:UIImagePickerController.SourceType = .photoLibrary
        //カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    //アラートを出す
    func showAlert() {
        let alertController = UIAlertController(title: "選択",
                                                message: "どちらを使用しますか？",
                                                preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
            self.doCamera()
        }
        let action2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
            self.doAlbum()
        }
        let action3 = UIAlertAction(title: "キャンセル", style: .cancel)
        alertController.addAction(action1)
        alertController.addAction(action2)
        alertController.addAction(action3)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    //　撮影が完了時した時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        //navigationを用いて画面遷移
        let createVC = self.storyboard?.instantiateViewController(identifier: "create") as! PostViewController
        createVC.passedImage = selectedImage
        self.navigationController?.pushViewController(createVC, animated: true)
        //閉じる処理
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    func fetchContentsData() {
        self.postArray.removeAll()
        if tableView.refreshControl?.isRefreshing == true {
            print("refreshing Data")
        }
        else {
            print("fetching Data")
        }
        let ref = Database.database().reference().child("timeLine").observe(.value) { (snapShot) in
            
            //    if != nilに置き換えられる。
            if let snapShot = snapShot.children.allObjects as? [DataSnapshot] {
                //snapShotのキー値を元に、値を取得するのに必要とするのが「snap」。
                for snap in snapShot {
                    //String:Any型（辞書型）で、snapの中の値を、postDataに入れる。dictionaly型に変換した。
                    if let postData = snap.value as? [String: Any] {
                        print("\(postData)")
                        guard let contents = postData["Contents"] as? String else {
                            return
                        }
                        guard let autoId = postData["autoId"] as? String else {
                            return
                        }
                        self.postArray.append(Contents(contentImageString: contents, autoId: autoId))
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.refreshControl?.endRefreshing()
                    self.tableView.reloadData()
                }
            }
            //下にスクロールすると、上のコンテンツが見れるようにする
            //let indexPath = IndexPath(row: self.postArray.count - 1, section: 0)
            //受信が５個以上なら画面からはみ出してしまうので、ボトムに持っていく。
            // if self.postArray.count >= 5 {
            //テーブルビューを自動的に下まで表示させる
            //  self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            //}
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}















