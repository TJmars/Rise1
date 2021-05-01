//
//  ListViewController.swift
//  Rise
//
//  Created by Apple on 2020/11/23.
//

import UIKit
import FSCalendar
import RealmSwift
import UserNotifications





class InputViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource, UIPickerViewDelegate,UIPickerViewDataSource {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
   
    var contentTextField = UITextField()
    var mySegument = UISegmentedControl()
    var segmentTextField = UITextField()
    var myCalendar = FSCalendar()
    var timeTextField = UITextField()
    var timeEndTextField = UITextField()
    var timeEndDeleatTitleButton = UIButton()
    var notiLabel = UILabel()
    var notiSwich = UISwitch()
    var timeDeleatTitleButton = UIButton()
    var postTitleButton = UIButton()
    var genreTextField = UITextField()
    var newGenreTextField = UITextField()
    var backView1 = UIView()

    //    ジャンル
    var genreList:[String] = ["指定なし"]
    var genrePickerView = UIPickerView()
    var genreData:GenreData!
    var genreArray = try! Realm().objects(GenreData.self)
    
    //    通知の設定があるか
    var notiSwitchCheck = 0
    
//    繰り返し
    var segmentPicker = UIPickerView()
    var segmentList = ["なし","毎日","毎週","毎月"]
    
    //    繰り返しの期間用
    var repeatTextField = UITextField()
    var repeatDate:Date!
    var repeatDatePicker: UIDatePicker!
    var repeatDateEnd:Date!
    
    
    //    日付、時間
    var selectDate = Date()
    var timeInt = 0
    var endTimeInt = 0
    var postDate:Date!
    var endPostDate:Date!
    var calendarNum = 0
    var totalTimeArray:[Int] = []
    var datePicker: UIDatePicker!
    var endDatePicker: UIDatePicker!
    
    
    //    realm
    let realm = try! Realm()
    var task: Task!
    
    //   segueの判別
    var segueCheckNum = 0
    //    segmentの判別
    var segmentNum = 0
    
    
    
    override func  viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        scrollView.contentSize.height = 740
        contentTextField.placeholder = "タスクを入力"
        
        
        //        ジャンル用の配列を作成
        for i in 0..<genreArray.count {
            genreData = genreArray[i]
            genreList.append(genreData.genre)
        }
        genrePickerView.delegate = self
        genreTextField.inputView = genrePickerView
        
        segmentPicker.delegate = self
        segmentTextField.inputView = segmentPicker
        
        
        createUI()
        
        
        
        //        カレンダーの作成
        myCalendar.delegate = self
        myCalendar.dataSource = self
        myCalendar.allowsSelection = true
        myCalendar.backgroundColor = .clear
        myCalendar.appearance.titleDefaultColor = .white
        myCalendar.appearance.headerTitleColor = .white
        myCalendar.appearance.weekdayTextColor = .white
        
        //        日付用ピッカーの作成
        datePicker = makePicker()
        timeTextField.inputView = datePicker
        endDatePicker = makeEndPicker()
        timeEndTextField.inputView = endDatePicker
        
        createToolBar()
        createToolBar2()
        createToolBars()
        createSegmentPicker()
        
        
        //        タイマーの表示
        var h = 0
        var m = 0
        var s = 0
        
        if segueCheckNum == 0 {
            h = task.totalTime / 3600
            m = task.totalTime % 3600 / 60
            s = task.totalTime % 3600 % 60
            
            if task.notifiNum == 0 {
                notiSwich.setOn(false, animated: true)
            } else {
                notiSwich.setOn(true, animated: true)
            }
        } else {

            notiSwich.setOn(false, animated: true)
            contentTextField.becomeFirstResponder()
        }
        
        
        
        //        cellから遷移してきた時
        
        if segueCheckNum == 0 {
            //            カレンダーに日付を表示
            let Yformatter = DateFormatter()
            Yformatter.dateFormat = "yyyy"
            let dateString:String = Yformatter.string(from: task.date)
            let YdateInt:Int = Int(dateString)!
            
            let Mformatter = DateFormatter()
            Mformatter.dateFormat = "MM"
            let MdateString:String = Mformatter.string(from: task.date)
            let MdateInt:Int = Int(MdateString)!
            
            let Dformatter = DateFormatter()
            Dformatter.dateFormat = "dd"
            let DdateString:String = Dformatter.string(from: task.date)
            let DdateInt:Int = Int(DdateString)!
            
            let calendars = Calendar.current
            let selectsDate = calendars.date(from: DateComponents(year: YdateInt, month: MdateInt, day: DdateInt))
            
            myCalendar.select(selectsDate)
            
            self.selectDate = myCalendar.selectedDate!
            self.calendarNum = 1
            contentTextField.text = task.contents
            self.segmentNum = task.repeatNum
            mySegument.selectedSegmentIndex = task.repeatNum
            
            //            ピッカーに時刻を設定
            if task.timeCheck != 0 {
                self.timeInt = task.timeInt
                datePicker.date = task.date
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                timeTextField.text = df.string(from: task.date)
            }
            
            if task.endTimeCheck != 0 {
                self.endTimeInt = task.endTimeInt
                endDatePicker.date = task.endDate
                let df = DateFormatter()
                df.dateFormat = "HH:mm"
                timeEndTextField.text = df.string(from: task.endDate)
            }
            
            repeatDateEnd = task.repeatDateEnd
            
            if self.segmentNum != 0 {
                let df = DateFormatter()
                df.dateStyle = .long
                df.locale = Locale(identifier: "ja_JP")
                self.segmentTextField.text = "\(segmentList[self.segmentNum])    \(df.string(from: task.repeatDateEnd))まで"
            }
            
        }
    }
    
    //   ジャンルのピッカー
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerView {
            return genreList.count
        } else {
            return segmentList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerView {
            return genreList[row]
        } else {
            return segmentList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerView {
            if row == 0 {
                self.genreTextField.text = ""
            } else {
                self.genreTextField.text = genreList[row]
            }
        } else {
            self.segmentNum = row
        }
    }
    
    
    //    時間の削除ボタン
    @objc func timeDeleatButton(_ sender:UIButton) {
        timeTextField.text = ""
        self.timeInt = 0
    }
    
    @objc func timeEndDeleatButton(_ sender:UIButton) {
        timeEndTextField.text = ""
        self.endTimeInt = 0
    }
    
    

    
    //    保存ボタン
    @objc func postButton(_ sender:UIButton) {
        
        
        if calendarNum != 0 && contentTextField.text != ""{
            
            if newGenreTextField.text != "" || genreTextField.text != "" {
                //            日付と内容の入力があれば保存を開始
                
                //            repeatIDの作成
                var repeatId = 0
                
                if segueCheckNum == 0 {
                    repeatId = self.task.repeatId
                    let date = Date()
                    //                現在より後に設定されている繰り返しタスクを削除
                    let deleatTaskArray = try! Realm().objects(Task.self).filter("endDate > %@ && repeatId == %@", date, repeatId)
                    
                    
                    for i in 0..<deleatTaskArray.count  {
                        let deleatTask = deleatTaskArray[i]
                        
                        self.totalTimeArray.append(deleatTask.totalTime)
                        
                        // ローカル通知をキャンセルする
                        let center = UNUserNotificationCenter.current()
                        center.removePendingNotificationRequests(withIdentifiers: [String(deleatTask.id)])
                        
                    }
                    //                データベースから削除
                    try!self.realm.write {
                        self.realm.delete(deleatTaskArray)
                    }
                    
                    
                } else {
                    let allTask = realm.objects(Task.self)
                    if allTask.count != 0 {
                        repeatId = allTask.max(ofProperty: "repeatId")! + 1
                    }
                }
                
                //            何回繰り返すかを計算
                var i2 = 0
                postDate = Date(timeInterval: TimeInterval(timeInt), since: selectDate)
                switch segmentNum {
                case 0:
                    i2 = 1
                    repeatDateEnd = Date()
                case 1:
                    
                    while postDate <= repeatDateEnd {
                        postDate = Date(timeInterval: TimeInterval(timeInt + (60*60*24*i2)), since: selectDate)
                        if postDate >= repeatDateEnd {
                            break
                        }
                        i2 += 1
                    }
                    postDate = Date(timeInterval: TimeInterval(timeInt), since: selectDate)
                case 2:
                    while postDate <= repeatDateEnd {
                        postDate = Date(timeInterval: TimeInterval(timeInt + (60*60*24*7*i2)), since: selectDate)
                        if postDate >= repeatDateEnd {
                            break
                        }
                        i2 += 1
                    }
                    postDate = Date(timeInterval: TimeInterval(timeInt), since: selectDate)
                case 3:
                    while postDate <= repeatDateEnd {
                        let addMonth = DateComponents(month: i2, day: 0)
                        let postCalendar = Calendar(identifier: .gregorian)
                        let nextMonth = postCalendar.date(byAdding: addMonth, to: selectDate)
                        postDate = Date(timeInterval: TimeInterval(timeInt), since: nextMonth!)
                        if postDate >= repeatDateEnd {
                            break
                        }
                        i2 += 1
                    }
                    postDate = Date(timeInterval: TimeInterval(timeInt), since: selectDate)
                    
                    
                default:
                    break
                }
                
                //           taskを保存する
                for i in 0..<i2 {
                    
                    
                    task = Task()
                    let allTasks = realm.objects(Task.self)
                    if allTasks.count != 0 {
                        task.id = allTasks.max(ofProperty: "id")! + 1
                    }
                    
                    if timeTextField.text != "" {
                        
                        let  postCalendar = Calendar(identifier: .gregorian)
                        
                        switch segmentNum {
                        case 0:
                            postDate = Date(timeInterval: TimeInterval(timeInt), since: selectDate)
                        case 1:
                            postDate = Date(timeInterval: TimeInterval(timeInt + (60*60*24*i)), since: selectDate)
                        case 2:
                            postDate = Date(timeInterval: TimeInterval(timeInt + (60*60*24*7*i)), since: selectDate)
                        case 3:
                            let addMonth = DateComponents(month: i, day: 0)
                            let nextMonth = postCalendar.date(byAdding: addMonth, to: selectDate)
                            postDate = Date(timeInterval: TimeInterval(timeInt), since: nextMonth!)
                        default:
                            break
                        }
                        
                        try! realm.write {
                            self.task.contents = self.contentTextField.text!
                            self.task.date = postDate!
                            self.task.timeCheck = 1
                            self.task.timeInt = self.timeInt
                            self.task.repeatId = repeatId
                            self.task.repeatNum = segmentNum
                            self.task.repeatDateEnd = self.repeatDateEnd
                            if i <= self.totalTimeArray.count - 1 {
                                task.totalTime = totalTimeArray[i]
                            } else {
                                task.totalTime = 0
                            }
                            self.realm.add(self.task, update: .modified)
                            
                        }
                        
                        if task.notifiNum != 0 {
                            let center = UNUserNotificationCenter.current()
                            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
                        }
                        
                        if notiSwitchCheck != 0 {
                            setNotification(task: task)
                            try! realm.write {
                                self.task.notifiNum = 1
                                self.realm.add(self.task, update: .modified)
                            }
                            
                        } else {
                            try! realm.write {
                                self.task.notifiNum = 0
                                self.realm.add(self.task, update: .modified)
                            }
                            
                        }
                        
                    } else {
                        
                        
                        let  postCalendar = Calendar(identifier: .gregorian)
                        
                        switch segmentNum {
                        case 0:
                            postDate = selectDate
                        case 1:
                            postDate = Date(timeInterval: TimeInterval(60*60*24*i), since: selectDate)
                        case 2:
                            postDate = Date(timeInterval: TimeInterval(60*60*24*7*i), since: selectDate)
                        case 3:
                            let addMonth = DateComponents(month: i, day: 0)
                            postDate = postCalendar.date(byAdding: addMonth, to: selectDate)
                            
                        default:
                            break
                        }
                        
                        try! realm.write {
                            self.task.contents = self.contentTextField.text!
                            self.task.date = postDate!
                            self.task.timeCheck = 0
                            self.timeInt = 0
                            self.task.repeatId = repeatId
                            self.task.repeatNum = segmentNum
                            self.task.repeatDateEnd = self.repeatDateEnd
                            if i <= self.totalTimeArray.count - 1 {
                                task.totalTime = totalTimeArray[i]
                            } else {
                                task.totalTime = 0
                            }
                            self.realm.add(self.task, update: .modified)
                            
                        }
                    }
                    
                    
                    if timeEndTextField.text != "" {
                        let  postCalendar = Calendar(identifier: .gregorian)
                        
                        switch segmentNum {
                        case 0:
                            endPostDate = Date(timeInterval: TimeInterval(endTimeInt), since: selectDate)
                        case 1:
                            endPostDate = Date(timeInterval: TimeInterval(endTimeInt + (60*60*24*i)), since: selectDate)
                        case 2:
                            endPostDate = Date(timeInterval: TimeInterval(endTimeInt + (60*60*24*7*i)), since: selectDate)
                        case 3:
                            let addMonth = DateComponents(month: i, day: 0)
                            let nextMonth = postCalendar.date(byAdding: addMonth, to: selectDate)
                            endPostDate = Date(timeInterval: TimeInterval(endTimeInt), since: nextMonth!)
                        default:
                            break
                        }
                        try! realm.write {
                            self.task.endDate = endPostDate!
                            self.task.endTimeCheck = 1
                            self.task.endTimeInt = self.endTimeInt
                            self.realm.add(self.task, update: .modified)
                        }
                    } else {
                        let  postCalendar = Calendar(identifier: .gregorian)
                        
                        switch segmentNum {
                        case 0:
                            endPostDate = Date(timeInterval: TimeInterval(60*60*24 - 1), since: selectDate)
                        case 1:
                            endPostDate = Date(timeInterval: TimeInterval(60*60*24 - 1 + (60*60*24*i)), since: selectDate)
                        case 2:
                            endPostDate = Date(timeInterval: TimeInterval(60*60*24 - 1 + (60*60*24*7*i)), since: selectDate)
                        case 3:
                            let addMonth = DateComponents(month: i, day: 0)
                            let nextMonth = postCalendar.date(byAdding: addMonth, to: selectDate)
                            endPostDate = Date(timeInterval: TimeInterval(60*60*24 - 1), since: nextMonth!)
                        default:
                            break
                        }
                        try! realm.write {
                            self.task.endDate = endPostDate!
                            self.task.endTimeCheck = 0
                            self.endTimeInt = 0
                            self.realm.add(self.task, update: .modified)
                            
                        }
                    }
                    
                    if newGenreTextField.text != "" {
                        
                        try! realm.write {
                            self.task.genre = newGenreTextField.text!
                            self.realm.add(self.task, update: .modified)
                        }
                    } else {
                        try! realm.write {
                            self.task.genre = genreTextField.text!
                            self.realm.add(self.task, update: .modified)
                        }
                    }
                    
                }
                
                if newGenreTextField.text != "" {
                    let postGenre = GenreData()
                    if genreArray.count != 0{
                        postGenre.id = genreArray.max(ofProperty: "id")! + 1
                    }
                    try! realm.write {
                        postGenre.genre = newGenreTextField.text!
                        self.realm.add(postGenre, update: .modified)
                    }
                }
                
                self.navigationController?.popViewController(animated: true)
            } else {
                let dialog = UIAlertController(title: "空欄があります", message: "ジャンルを指定してください", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
            
        } else {
            let dialog = UIAlertController(title: "空欄があります", message: "内容、日にちは必ず選択してください", preferredStyle: .alert)
            dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(dialog, animated: true, completion: nil)
        }
        
    }
    

    
    //    繰り返しの期間設定
    func repeatFunc() {
        let ac = UIAlertController(title: "繰り返しの期間を設定", message: "", preferredStyle: .alert)
        let aa = UIAlertAction(title: "OK", style: .default) { [self] (action) in
            let date = Date()
            if self.repeatTextField.text != "" && self.repeatDatePicker.date >= date{
                let calendar = Calendar(identifier: .gregorian)
                let endDate = calendar.startOfDay(for: self.repeatDatePicker.date)
                self.repeatDateEnd = Date(timeInterval: 60*60*24 - 1, since: endDate)
                
                let df = DateFormatter()
                df.dateStyle = .long
                df.locale = Locale(identifier: "ja_JP")
                self.segmentTextField.text = "\(segmentList[self.segmentNum])    \(df.string(from: self.repeatDatePicker.date))まで"
                
            } else {
                let dialog = UIAlertController(title: "入力内容に誤りがあります", message: "", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
            }
        }
        ac.addTextField { (textField) in
            self.repeatTextField = textField
            //        繰り返し日付用ピッカーの作成
            self.repeatDatePicker = self.makeRepeatPicker()
            self.repeatTextField.inputView = self.repeatDatePicker
            self.createRepeatToolBar()
            self.repeatTextField.placeholder = "終了日"
            self.repeatTextField.contentMode = .center
            
        }
        
        ac.addAction(aa)
        present(ac, animated: true, completion: nil)
        
    }
    
    //            通知の関数
    
    func setNotification(task:Task) {
        let content = UNMutableNotificationContent()
        content.title = task.contents
        content.body = "今日もがんばりましょう!"
        
        content.sound = UNNotificationSound.default
        
        // ローカル通知が発動するtrigger（日付マッチ）を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        // identifier, content, triggerからローカル通知を作成（identifierが同じだとローカル通知を上書き保存）
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        // ローカル通知を登録
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録 OK")  // error が nil ならローカル通知の登録に成功したと表示します。errorが存在すればerrorを表示します。
            
        }
        
        // 未通知のローカル通知一覧をログ出力
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
        
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.selectDate = myCalendar.selectedDate!
        self.calendarNum = 1
        
    }
    
    func createToolBar() {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePicker))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        timeTextField.inputAccessoryView = toolBar
        
    }
    
    func createToolBar2() {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePicker2))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        
        
        timeEndTextField.inputAccessoryView = toolBar
        
    }
    
    func createToolBars() {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePickers))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        // textViewのキーボードにツールバーを設定
        
        contentTextField.inputAccessoryView = toolBar
        genreTextField.inputAccessoryView = toolBar
        newGenreTextField.inputAccessoryView = toolBar
        
    }
    
    func createRepeatToolBar() {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.repeatdonePicker))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        repeatTextField.inputAccessoryView = toolBar
    }
    
    func createSegmentPicker() {
        // ツールバー生成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        // スタイルを設定
        toolBar.barStyle = UIBarStyle.default
        // 画面幅に合わせてサイズを変更
        toolBar.sizeToFit()
        // 閉じるボタンを右に配置するためのスペース?
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.segmentDonePicker))
        // スペース、閉じるボタンを右側に配置
        toolBar.items = [spacer, commitButton]
        segmentTextField.inputAccessoryView = toolBar
    }
    
    
    
    @objc func donePicker() {
        timeTextField.endEditing(true)
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        timeTextField.text = df.string(from: datePicker.date)
        let dfH = DateFormatter()
        dfH.dateFormat = "HH"
        let dateHString = dfH.string(from: datePicker.date)
        let dateHInt = Int(dateHString)!
        
        let dfM = DateFormatter()
        dfM.dateFormat = "mm"
        let dateMString = dfM.string(from: datePicker.date)
        let dateMInt = Int(dateMString)!
        
        self.timeInt = dateHInt*60*60+dateMInt*60
        
    }
    
    @objc func donePicker2() {
        timeEndTextField.endEditing(true)
        
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        timeEndTextField.text = df.string(from: endDatePicker.date)
        let dfH = DateFormatter()
        dfH.dateFormat = "HH"
        let dateHString = dfH.string(from: endDatePicker.date)
        let dateHInt = Int(dateHString)!
        
        let dfM = DateFormatter()
        dfM.dateFormat = "mm"
        let dateMString = dfM.string(from: endDatePicker.date)
        let dateMInt = Int(dateMString)!
        
        self.endTimeInt = dateHInt*60*60+dateMInt*60
        
    }
    
    @objc func repeatdonePicker() {
        repeatTextField.endEditing(true)
        let df = DateFormatter()
        df.dateStyle = .full
        repeatTextField.text = df.string(from: repeatDatePicker.date)
        
    }
    
    @objc func segmentDonePicker() {
        segmentTextField.endEditing(true)
        if segmentNum != 0 {
            repeatFunc()
        } else {
            segmentTextField.text = ""
        }
    }
    
    
    
    
    @objc func donePickers() {
        contentTextField.endEditing(true)
        genreTextField.endEditing(true)
        newGenreTextField.endEditing(true)
    }
    
    func makePicker() -> UIDatePicker {
        let myPicker: UIDatePicker!
        myPicker = UIDatePicker()
        myPicker.datePickerMode = .time
        myPicker.preferredDatePickerStyle = .wheels
        return myPicker
    }
    
    func makeRepeatPicker() -> UIDatePicker {
        let myPicker: UIDatePicker!
        myPicker = UIDatePicker()
        myPicker.datePickerMode = .date
        myPicker.preferredDatePickerStyle = .wheels
        return myPicker
    }
    
    func makeRepeatPicker2() -> UIDatePicker {
        let myPicker: UIDatePicker!
        myPicker = UIDatePicker()
        myPicker.datePickerMode = .date
        myPicker.preferredDatePickerStyle = .wheels
        return myPicker
    }
    
    
    
    func makeEndPicker() -> UIDatePicker {
        let myPicker: UIDatePicker!
        myPicker = UIDatePicker()
        myPicker.datePickerMode = .time
        myPicker.preferredDatePickerStyle = .wheels
        return myPicker
    }
    
    //    viewにUIをセット
    func createUI() {
        

        
        contentTextField.frame = CGRect(x: 20, y: 30, width: view.frame.size.width - 40, height: 35)
        contentTextField.font = UIFont.systemFont(ofSize: 16.0)
        contentTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        contentTextField.attributedPlaceholder = NSAttributedString(string: "タスクを入力",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        contentTextField.textColor = .white
        scrollView.addSubview(contentTextField)
        
        backView1.frame = CGRect(x: 10, y: 400, width: view.frame.size.width - 20, height: 250)
        backView1.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        scrollView.addSubview(backView1)
        

        
        segmentTextField.frame = CGRect(x: 20, y: 45, width: backView1.frame.size.width - 60, height: 35)
        segmentTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        segmentTextField.attributedPlaceholder = NSAttributedString(string: "繰り返し",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        segmentTextField.textColor = .white
        backView1.addSubview(segmentTextField)
        
        myCalendar.frame = CGRect(x: 10, y: 80, width: view.frame.size.width - 20, height: 300)
        myCalendar.layer.cornerRadius = 5.0
        scrollView.addSubview(myCalendar)
        
        backView1.layer.cornerRadius = 5.0

        
        
        notiLabel.frame = CGRect(x: 20, y: 10, width: backView1.frame.size.width - 90, height: 35)
        notiLabel.text = "通知"
        notiLabel.textColor = .white
        backView1.addSubview(notiLabel)
        
        notiSwich.frame = CGRect(x: backView1.frame.size.width - 70, y: 10, width: 60, height: 35)
        notiSwich.addTarget(self, action: #selector(changeSwitch), for: UIControl.Event.valueChanged)
        
        backView1.addSubview(notiSwich)
        
        
        timeTextField.frame = CGRect(x: 20, y: 85, width: backView1.frame.size.width - 60, height: 35)
        timeTextField.attributedPlaceholder = NSAttributedString(string: "開始時間",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        timeTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        timeTextField.textColor = .white
        backView1.addSubview(timeTextField)
//
        timeDeleatTitleButton.frame = CGRect(x: backView1.frame.size.width - 40, y: 85, width: 30, height: 35)
        timeDeleatTitleButton.setTitle("×", for: .normal)
        timeDeleatTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        timeDeleatTitleButton.setTitleColor(UIColor.gray, for: .normal)
        timeDeleatTitleButton.addTarget(self, action: #selector(timeDeleatButton(_:)), for: .touchUpInside)
        backView1.addSubview(timeDeleatTitleButton)
//
        timeEndTextField.frame = CGRect(x: 20, y: 125, width: backView1.frame.size.width - 60, height: 35)
        timeEndTextField.attributedPlaceholder = NSAttributedString(string: "終了時間",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        timeEndTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        backView1.addSubview(timeEndTextField)
//
        timeEndDeleatTitleButton.frame = CGRect(x: backView1.frame.size.width - 40, y: 125, width: 30, height: 35)
        timeEndDeleatTitleButton.setTitle("×", for: .normal)
        timeEndDeleatTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30.0)
        timeEndDeleatTitleButton.setTitleColor(UIColor.gray, for: .normal)
        timeEndDeleatTitleButton.addTarget(self, action: #selector(timeEndDeleatButton(_:)), for: .touchUpInside)
        timeEndTextField.textColor = .white
        backView1.addSubview(timeEndDeleatTitleButton)
//
        genreTextField.frame = CGRect(x: 20, y: 165, width: backView1.frame.size.width - 60, height: 35)
        genreTextField.attributedPlaceholder = NSAttributedString(string: "ジャンル",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        genreTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        genreTextField.textColor = .white
        
        if segueCheckNum == 0 {
            genreTextField.text = task.genre
        }
        backView1.addSubview(genreTextField)
//
        newGenreTextField.frame = CGRect(x: 20, y: 205, width: backView1.frame.size.width - 60, height: 35)
        newGenreTextField.attributedPlaceholder = NSAttributedString(string: "ジャンル(新規)",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)])
        newGenreTextField.addBorderBottom(height: 1.0, color: UIColor.gray)
        newGenreTextField.textColor = .white
        backView1.addSubview(newGenreTextField)
        

        postTitleButton.frame = CGRect(x: 50, y: 670, width: view.frame.size.width - 100, height: 50)
        postTitleButton.backgroundColor = .clear
        postTitleButton.setTitle("保存", for: .normal)
        postTitleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23.0)
        postTitleButton.setTitleColor(.white, for: .normal)
        postTitleButton.layer.cornerRadius = 5.0
        postTitleButton.addTarget(self, action: #selector(postButton(_:)), for: .touchUpInside)
        postTitleButton.layer.borderWidth = 3.0
        postTitleButton.layer.borderColor = UIColor.white.cgColor
        postTitleButton.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        scrollView.addSubview(postTitleButton)
        
    }
    
    //    switchが押されたとき
    @objc func changeSwitch(sender: UISwitch) {
        let onCheck: Bool = sender.isOn
        if onCheck {
            if (UIApplication.shared.currentUserNotificationSettings?.types.contains( UIUserNotificationType.alert))! {
                notiSwitchCheck = 1
            } else {
                let dialog = UIAlertController(title: "通知設定が未許可です", message: "設定→通知より通知を許可してください。", preferredStyle: .alert)
                dialog.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(dialog, animated: true, completion: nil)
                notiSwich.setOn(false, animated: true)
            }
        } else {
            notiSwitchCheck = 0
        }
    }
    
    
    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let calenderHelpViewController:CalendarHelpViewController = segue.destination as! CalendarHelpViewController
        calenderHelpViewController.parentViewName = "input"
        
    }

}

extension UITextField {
    func addBorderBottom(height: CGFloat, color: UIColor) {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: self.frame.height - height, width: self.frame.width, height: height)
        border.backgroundColor = color.cgColor
        self.layer.addSublayer(border)
    }
}
