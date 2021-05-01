//
//  Task.swift
//  Rise
//
//  Created by Apple on 2020/11/23.
//

import RealmSwift

class Task: Object {
    @objc dynamic var id = 0
    
//    内容
    @objc dynamic var contents = ""
//    日付
    @objc dynamic var date = Date()
    @objc dynamic var endDate = Date()
//    タイマー
    @objc dynamic var time = Date()
//    タイマーが実行中か
    @objc dynamic var timerOff = 0
//    タイマートータル時間
    @objc dynamic var totalTime = 0
//    日付に時間があるか
    @objc dynamic var timeCheck = 0
    @objc dynamic var endTimeCheck = 0
//    時間の加算用
    @objc dynamic var timeInt = 0
    @objc dynamic var endTimeInt = 0
//    ジャンル
    @objc dynamic var genre = ""
//    完了タスクかどうか
    @objc dynamic var finish = 0
//    時間内かどうか
    @objc dynamic var inTimeCheck = 0
//    繰り返しの有無
    @objc dynamic var repeatNum = 0
//    繰り返し用のid
    @objc dynamic var repeatId = 0
//    繰り返しの期間
    @objc dynamic var repeatDateEnd = Date()
//  　通知があるか
    @objc dynamic var notifiNum = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class GenreData: Object {
    @objc dynamic var id = 0
    @objc dynamic var genre = ""
    @objc dynamic var selectNum = 1
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class TimeData: Object {
    @objc dynamic var id = 0
    @objc dynamic var genre = ""
    @objc dynamic var date = Date()
    @objc dynamic var totalTime = 0
    override static func primaryKey() -> String? {
        return "id"
    }
}

class UserData: Object {
    @objc dynamic var version:Double = 0
}
