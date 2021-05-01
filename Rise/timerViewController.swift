//
//  timerViewController.swift
//  Rise
//
//  Created by Apple on 2021/02/20.
//

import UIKit
import RealmSwift

class timerViewController: UIViewController, backgroundTimerDelegate {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var stopTitleButton: UIButton!
    @IBOutlet weak var resetTitleButton: UIButton!
    
    
    // タイマー
    var timer: Timer!
    //タイマー起動中にバックグラウンドに移行したか
    var timerIsBackground = false
    
    // タイマー用の時間のための変数
    var timer_sec = 0
    var hourNum = 0
    var minutesNum = 0
    var secondNum = 0
    
    //    realm
    let realm = try! Realm()
    var task: Task!
    var timeDataArray = try! Realm().objects(TimeData.self)
    var timeData: TimeData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate else {
            return
        }
        sceneDelegate.delegate = self
        
        stopTitleButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 0.4)
        stopTitleButton.layer.cornerRadius = stopTitleButton.frame.size.width * 0.5
        stopTitleButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 17)
        resetTitleButton.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5)
        resetTitleButton.layer.cornerRadius = resetTitleButton.frame.size.width * 0.5
        resetTitleButton.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 17)
        
        
        //        総時間の取得準備
//        TimeDataは同一ジャンル、同一日のタスクのtotalTimeを加算したものをtotalTimeとして持つオブジェクト
        let today = Calendar.current.startOfDay(for: Date())
        let endDate = Date(timeInterval: TimeInterval(60*60*24 - 1), since: today)
        timeDataArray = try! Realm().objects(TimeData.self).filter("genre == %@ && date >= %@ && date <= %@",task.genre,today,endDate)
        if timeDataArray.count == 0 {
            timeData = TimeData()
            let alltimeData = try! Realm().objects(TimeData.self)
            if alltimeData.count != 0 {
                timeData.id = alltimeData.max(ofProperty: "id")! + 1
            }
            try! realm.write {
                timeData.date = today
                timeData.genre = task.genre
                self.realm.add(self.timeData, update: .modified)
            }
        } else {
            self.timeData = timeDataArray[0]
        }
        
//        タイマーの数字表示処理
        
        titleLabel.text = "\(task.contents)"
        titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 25)
        timerLabel.font = UIFont(name:"DINAlternate-Bold", size: 90.0)!
        if task.timerOff == 0 {
//            タイマーが止まってる
            self.timer_sec = task.totalTime
        } else {
//            タイマーが動いている
            let runningTimer = Int(Date().timeIntervalSince(task.time))
            self.timer_sec = task.totalTime + runningTimer
            self.stopTitleButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.4)
        }
        
//        titleLabel.text = "\(task.contents)"
//        timerLabel.font = UIFont(name:"DINAlternate-Bold", size: 90.0)!
//        if task.timerOff == 0 {
//            self.timer_sec = task.totalTime
//        } else {
//            try! realm.write {
//                timeData.totalTime += Int(Date().timeIntervalSince(task.time))
//                self.realm.add(self.timeData, update: .modified)
//            }
//            try! realm.write {
//                task.totalTime += Int(Date().timeIntervalSince(task.time))
//                task.time = Date()
//                self.realm.add(self.task, update: .modified)
//            }
//            self.timer_sec = task.totalTime
//
//        }
        if timer_sec != 0{
            hourNum = timer_sec / 3600
            minutesNum = (timer_sec - (hourNum*3600)) / 60
            secondNum = timer_sec - (hourNum*3600) - (minutesNum*60)
        }
        
        let hourStr: String = String(format: "%02d", hourNum)
        let minutesStr: String = String(format: "%02d", minutesNum)
        let secondStr: String = String(format: "%02d", secondNum)
        timerLabel.text = "\(hourStr):\(minutesStr):\(secondStr)"
        
        if task.timerOff == 0 {
            self.stopTitleButton.setTitle("Start", for: .normal)
        } else {
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
            }
            self.stopTitleButton.setTitle("Stop", for: .normal)
        }
        
        

    }
    
    @objc func updateTimer(_ timer: Timer) {
        self.timer_sec += 1
        hourNum = timer_sec / 3600
        minutesNum = (timer_sec - (hourNum*3600)) / 60
        secondNum = timer_sec - (hourNum*3600) - (minutesNum*60)
        
        let hourStr: String = String(format: "%02d", hourNum)
        let minutesStr: String = String(format: "%02d", minutesNum)
        let secondStr: String = String(format: "%02d", secondNum)
        timerLabel.text = "\(hourStr):\(minutesStr):\(secondStr)"
        
    }
    
    @IBAction func stopButton(_ sender: Any) {
        if task.timerOff == 0 {
//            タイマーが停止している時
            self.stopTitleButton.backgroundColor = UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 0.4)
            if self.timer == nil {
                self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
            }
            try! realm.write {
                task.time = Date()
                task.timerOff = 1
                self.realm.add(self.task, update: .modified)
            }
            stopTitleButton.setTitle("Stop", for: .normal)

        } else {
//            タイマーが動いている時
            self.stopTitleButton.backgroundColor = UIColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 0.4)
            if self.timer != nil {
                self.timer.invalidate()   // タイマーを停止する
                self.timer = nil
            }
            
            try! realm.write {
                task.totalTime += Int(Date().timeIntervalSince(task.time))
                task.timerOff = 0
                self.realm.add(self.task, update: .modified)
            }
            
            try! realm.write {
                timeData.totalTime += Int(Date().timeIntervalSince(task.time))
                self.realm.add(self.timeData, update: .modified)
            }
            stopTitleButton.setTitle("Start", for: .normal)
            
        }
        
    }
    
    @IBAction func resetButton(_ sender: Any) {
        
        if task.timerOff != 0 {
            let dialogs = UIAlertController(title: "タイマーを停止してください", message: "", preferredStyle: .alert)
            dialogs.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialogs, animated: true, completion: nil)
        } else {
            let dialog = UIAlertController(title: "リセットしますか？", message: "タイマーをリセットすると、このタスクの取り組み時間に関する情報は失われます", preferredStyle: .alert)
            
            dialog.addAction(UIAlertAction(title: "リセット", style: .default, handler: { action in
                
                try! self.realm.write {
                    self.timeData.totalTime -= self.task.totalTime
                    self.realm.add(self.timeData, update: .modified)
                }
                try! self.realm.write {
                    self.task.totalTime = 0
                    self.task.timerOff = 0
                    self.realm.add(self.task, update: .modified)
                }
                
                self.timer_sec = 0
                self.timerLabel.text = "00:00:00"
            }))
            dialog.addAction(UIAlertAction(title: "キャンセル", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
            
            self.stopTitleButton.backgroundColor = UIColor(red: 0, green: 0.3, blue: 0, alpha: 0.5)
        }
        
    }
    
    
    
    
    func setCurrentTimer(_ elapsedTime: Int) {
        var runningTimer = 0
        if task.timerOff == 1 {
            runningTimer = Int(Date().timeIntervalSince(task.time))
        }
        self.timer_sec = task.totalTime + runningTimer
        hourNum = timer_sec / 3600
        minutesNum = (timer_sec - (hourNum*3600)) / 60
        secondNum = timer_sec - (hourNum*3600) - (minutesNum*60)
        let hourStr: String = String(format: "%02d", hourNum)
        let minutesStr: String = String(format: "%02d", minutesNum)
        let secondStr: String = String(format: "%02d", secondNum)
        timerLabel.text = "\(hourStr):\(minutesStr):\(secondStr)"
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer(_:)), userInfo: nil, repeats: true)
        
    }
    
    func deleteTimer() {
        //起動中のタイマーを破棄
        if let _ = timer {
            timer.invalidate()
        }
    }
    
    func checkBackground() {
        //バックグラウンドへの移行を確認
        if let _ = timer {
            timerIsBackground = true
        }
    }
    
    
}
