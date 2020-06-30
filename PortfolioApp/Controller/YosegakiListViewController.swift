//
//  YosegakiListViewController.swift
//  PortfolioApp
//
//  Created by Yusuke Mitsugi on 2020/06/28.
//  Copyright © 2020 Yusuke Mitsugi. All rights reserved.
//
protocol YosegakiDelegate {
    
    func yosegakiMessage(title: String, note: String)
}
//protocol CreateMessageDelegate {
//
//    func createMessage(note: String)
//}



import UIKit

class YosegakiListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    @IBOutlet var table: UITableView!
    @IBOutlet var label: UILabel!
    
    var models: [(title: String, note: String)] = []
    
    var delegate: YosegakiDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        title = "Messages"
        
        if UserDefaults.standard.object(forKey: "yosegaki") != nil {
            models = UserDefaults.standard.object(forKey: "yosegaki") as! [(title: String, note: String)]
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        cell.detailTextLabel?.text = models[indexPath.row].note
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let title = models[indexPath.row].title
        let note = models[indexPath.row].note
        if models[indexPath.row].title != nil && models[indexPath.row].note != nil {
            delegate?.yosegakiMessage(title: title, note: note)
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    
    
    @IBAction func didTapNewNote() {
        guard let vc = storyboard?.instantiateViewController(identifier: "entry") as? EntryYosegakiViewController else {
            return
        }
        vc.title = "感謝の気持ち"
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.completion = { noteTitle, note in
            self.navigationController?.popViewController(animated: true)
            self.models.append((title: noteTitle, note: note))
            self.label.isHidden = true
            self.table.isHidden = false
            self.table.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    //消去
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            //モデルを削除したら、セルも削除しないとクラッシュする。
            models.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}
