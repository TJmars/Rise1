//
//  CalendarViewController.swift
//  Rise
//
//  Created by Apple on 2020/11/23.
//

import UIKit
import RealmSwift
import XLPagerTabStrip
import FSCalendar
import UserNotifications
import Gecco

    
class CalendarViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource, UNUserNotificationCenterDelegate{
    
    
    @IBOutlet weak var myCalendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
   
    //    Realmのインスタンスを取得
    let realm = try! Realm()
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)
    
//    タイマーのindex
    var timerIndex = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ユーザに通知の許可を求める --- ここから ---
                let center = UNUserNotificationCenter.current()
                center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                    // Enable or disable features based on authorization
                } // ---
        
        view.backgroundColor = .black
        
        myCalendar.delegate = self
        myCalendar.dataSource = self
        myCalendar.backgroundColor = .clear
        
        
        let endDate:Date = Date(timeInterval: 60*60*24, since: myCalendar.today!)
       
        taskArray = try! Realm().objects(Task.self).filter("date >= %@ && date < %@", myCalendar.today!, endDate)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 55
        tableView.backgroundColor = .clear
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        時間内にtaskが終わっていなかったら、inTimeCheck = 1にする
        let timeCheckTaskArray = try! Realm().objects(Task.self).filter("finish == 0")
        for i in 0..<timeCheckTaskArray.count {
            let TCTask = timeCheckTaskArray[i]
            let taskTime = TCTask.endDate.timeIntervalSinceNow
            if taskTime < 0 {
                try! realm.write {
                    TCTask.inTimeCheck = 1
                    self.realm.add(TCTask, update: .modified)
                }
            }
        }
       
        self.tableView.reloadData()
    }
    
   
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let endDate:Date = Date(timeInterval: 60*60*24, since: myCalendar.selectedDate!)
         taskArray = try! Realm().objects(Task.self).filter("date >= %@ && date < %@", myCalendar.selectedDate!, endDate)
        
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.subviews.forEach { $0.removeFromSuperview()}
        if taskArray.count == 0 {
            noDataLabel()
        }
        return taskArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell
            = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.subviews.forEach { $0.removeFromSuperview()}
        let task = taskArray[indexPath.row]
        
        let backView = UIView()
        backView.backgroundColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        backView.layer.cornerRadius = 5.0
        backView.frame = CGRect(x: 5, y: 5, width: view.frame.size.width - 10, height: 50)
        cell.addSubview(backView)
        
        
        let checkButton = UIButton()
        checkButton.frame = CGRect(x: 5, y: 5, width: 40, height: 40)
        checkButton.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        checkButton.tag = indexPath.row
        
        
        let titleLabel = UILabel()
        titleLabel.frame = CGRect(x: 50, y: 0, width: view.frame.size.width - 50, height: 50)
        titleLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
        if task.finish != 0 {
            let atr =  NSMutableAttributedString(string: task.contents)
            atr.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, atr.length))
            titleLabel.attributedText = atr
            titleLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            
            
        } else {
            titleLabel.text = task.contents
            titleLabel.textColor = .white
        }
        let timerButton = UIButton()
        timerButton.frame = CGRect(x: backView.frame.size.width - 75, y: 5, width: 70, height: 40)
        timerButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        timerButton.layer.cornerRadius = 5.0
        if task.timerOff == 0 {
            timerButton.setImage(UIImage(named: "clock"), for: .normal)
        } else {
            timerButton.setImage(UIImage(named: "nowClock"), for: .normal)
        }
        timerButton.imageView?.contentMode = .scaleAspectFit
        timerButton.addTarget(self, action: #selector(timerCheckButton(_:)), for: .touchUpInside)
        timerButton.tag  = indexPath.row
        
        backView.addSubview(titleLabel)
        backView.addSubview(checkButton)
        backView.addSubview(timerButton)
        if task.finish == 0 {
            checkButton.setImage(UIImage(named: "noCheck"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // セルが削除が可能なことを伝えるメソッド
        func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath)-> UITableViewCell.EditingStyle {
            return .delete
        }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let dialog = UIAlertController(title: "消去しますか?", message: "タスクを消去した場合、アプリに登録されたそのタスクのデータは失われます", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                
                // 削除するタスクを取得する
                let task = self.taskArray[indexPath.row]
                
                if task.repeatNum == 0 {
                    // ローカル通知をキャンセルする
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

                    
                    //                データベースから削除
                    try!self.realm.write {
                        self.realm.delete(task)
                    }
                    // 未通知のローカル通知一覧をログ出力
                    center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                        for request in requests {
                            print("/---------------")
                            print(request)
                            print("---------------/")
                        }
                    }

                    tableView.reloadData()
                } else {
                    let df = DateFormatter()
                    df.dateStyle = .short
                    df.locale = Locale(identifier: "ja_JP")
                    let showDate = df.string(from: task.date)
                    let dialogs = UIAlertController(title: "繰り返しが設定されているタスクです", message: "繰り返しを終了しますか", preferredStyle: .alert)
                    dialogs.addAction(UIAlertAction(title: "はい", style: .default, handler: { action in
                        let repeatId = task.repeatId
                        //                選択日より後に設定されている繰り返しタスクを削除
                        let deleatTaskArray = try! Realm().objects(Task.self).filter("endDate >= %@ && repeatId == %@", task.endDate, repeatId)
                        for i in 0..<deleatTaskArray.count  {
                            let deleatTask = deleatTaskArray[i]
                          
                            // ローカル通知をキャンセルする
                            let center = UNUserNotificationCenter.current()
                            center.removePendingNotificationRequests(withIdentifiers: [String(deleatTask.id)])
                            
                        }
//                                        データベースから削除
                        try!self.realm.write {
                            self.realm.delete(deleatTaskArray)
                        }
                        
                        self.tableView.reloadData()
                        
                    }))
                    dialogs.addAction(UIAlertAction(title: "いいえ", style: .default, handler: { action in
                        // ローカル通知をキャンセルする
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])

                        
                        //                データベースから削除
                        try!self.realm.write {
                            self.realm.delete(task)
                        }
                        // 未通知のローカル通知一覧をログ出力
                        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
                            for request in requests {
                                print("/---------------")
                                print(request)
                                print("---------------/")
                            }
                        }

                        tableView.reloadData()

                        }))

                    self.present(dialogs, animated: true, completion: nil)
                }

            }))
            dialog.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            
        }
    }
    
    func noDataLabel() {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height)
        label.text = "右上の＋をタップ"
        label.font = UIFont.systemFont(ofSize: 23.0)
        label.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        label.textAlignment = .center
        tableView.addSubview(label)
        
    }
    
    @objc func tapCheckButton(_ sender:UIButton) {
        let task = taskArray[sender.tag]
        if task.finish == 0 {
            try! realm.write {
                task.finish = 1
                if task.inTimeCheck == 0 {
                    task.inTimeCheck = 2
                }
                self.realm.add(task, update: .modified)
            }
        } else {
            try! realm.write {
                task.finish = 0
                task.inTimeCheck = 0
                self.realm.add(task, update: .modified)
            }
        }
        tableView.reloadData()
    }
    
    @objc func timerCheckButton(_ sender:UIButton) {
        self.timerIndex = sender.tag
        self.performSegue(withIdentifier: "toTimer", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toTimer" {
            let timerViewControler:timerViewController = segue.destination as! timerViewController
            timerViewControler.task =  taskArray[timerIndex]
        } else if segue.identifier == "helpSegue" {
            let calenderHelpViewController:CalendarHelpViewController = segue.destination as! CalendarHelpViewController
            calenderHelpViewController.parentViewName = "calendar"
        } else {
            let inputViewController:InputViewController = segue.destination as! InputViewController
            if segue.identifier == "cellSegue" {
                let indexPath = self.tableView.indexPathForSelectedRow
                inputViewController.task = taskArray[indexPath!.row]
                inputViewController.segueCheckNum = 0
            } else {
                inputViewController.segueCheckNum = 1
            }
        }
        
    }
}



