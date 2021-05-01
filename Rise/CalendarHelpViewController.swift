//
//  CalendarHelpViewController.swift
//  Rise
//
//  Created by Apple on 2021/03/03.
//

import UIKit

class CalendarHelpViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var helpList:[String] = []
    
    var parentViewName = ""
    var segueIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black

        self.tableView.delegate = self
        self.tableView.dataSource = self
        tableView.rowHeight = 70
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        
//        どこからのsegueか反別
        if parentViewName == "calendar" {
            helpList = ["このアプリについて","タスクの追加","タスクの変更","タスクの完了","タスクの削除","タイマーについて"]
        } else if parentViewName == "input" {
            helpList = ["入力が必要な項目","繰り返しについて","開始時間、終了時間について","ジャンルについて"]
        } else if parentViewName == "chart" {
            helpList = ["タスク数画面について","総時間画面について","ジャンル割合画面について","表示ジャンルの変更について"]
        }
    }
    
    
   

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return helpList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.text = helpList[indexPath.row]
        cell.textLabel?.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        cell.textLabel?.font = UIFont(name: "DINAlternate-Bold", size: 20)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.segueIndex = indexPath.row
        performSegue(withIdentifier: "helpSegue", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let helpContentsViewController:HelpContentsViewController = segue.destination as! HelpContentsViewController
        helpContentsViewController.parentViewName = self.parentViewName
        helpContentsViewController.segueIndex = self.segueIndex
        helpContentsViewController.helpTitle = self.helpList[segueIndex]
        
        if let indexPatth = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPatth, animated: true)
        }
        
    }

}
