//
//  FifthViewController.swift
//  Rise
//
//  Created by Apple on 2021/02/09.
//

import UIKit
import XLPagerTabStrip
import Charts
import RealmSwift

//　効率
class FifthViewController: UIViewController, IndicatorInfoProvider {
    
    //必須
    var itemInfo: IndicatorInfo = "ジャンル割合"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    
   
    let scrollView = UIScrollView()

    var mySegument = UISegmentedControl()
    var segmentNum = 0
        
    let realm = try! Realm()
    var genreData:GenreData!
    var genreArray = try! Realm().objects(GenreData.self).filter("selectNum == 1")
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.subviews.forEach { $0.removeFromSuperview() }
            view.backgroundColor = .black
            self.scrollView.frame = CGRect(x: 0, y: 90, width: view.frame.size.width, height: view.frame.size.height - 40)
            view.addSubview(scrollView)
            //        segmentの作成
            let params = ["week", "month"]
            // UISegmentedControlを生成
            let mySegment = UISegmentedControl(items: params)
            mySegment.frame = CGRect(x: 30, y: 40, width: view.frame.size.width - 60, height: 40)
            // セグメントの選択
            mySegment.selectedSegmentIndex = 0
            // セグメントが変更された時に呼び出すメソッドの設定
            mySegment.addTarget(self, action: #selector(segmentChanged(_:)), for: UIControl.Event.valueChanged)
            mySegment.backgroundColor = .black
            mySegment.layer.borderWidth = 1.0
            mySegment.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1).cgColor
            mySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
            mySegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            mySegment.selectedSegmentTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
            // UISegmentedControlを追加
            view.addSubview(mySegment)
            
           
            self.scrollView.contentSize.height = 2800
           
            
            createGraph()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        createGraph()
    }
    
    
    //    日、週、月のsegment
    @objc func segmentChanged(_ segment:UISegmentedControl) {
        self.segmentNum = segment.selectedSegmentIndex
        createGraph()
    }
    
    func createGraph() {
        
//        円グラフのviewを作成
        var pieChartsViewArray:[PieChartView] = []
        var centerTextArray:[UILabel] = []
        var centerTimeArray:[UITextField] = []
        scrollView.subviews.forEach { $0.removeFromSuperview() }
        
        for i in 1...7 {
            let pieChart = PieChartView()
            pieChart.frame = CGRect(x: 10, y: CGFloat(10*i + 350*(i-1)), width: view.frame.size.width - 20, height: 350)
            pieChart.backgroundColor = .black
            pieChart.layer.cornerRadius = 10.0
            pieChart.layer.masksToBounds = true
            pieChart.usePercentValuesEnabled = false
            pieChart.rotationEnabled = false
            pieChart.drawEntryLabelsEnabled = false
            pieChart.holeColor = .clear
            pieChart.legend.textColor = .white
            pieChart.highlightPerTapEnabled = false
            
            
            self.scrollView.addSubview(pieChart)
            
            let label = UILabel()
            label.frame = CGRect(x: (pieChart.frame.size.width / 2) - 65, y: (pieChart.frame.size.height / 2) - 35, width: 130, height: 30)
            label.textColor = .white
            label.textAlignment = .center
            label.font = UIFont(name:"DINAlternate-Bold", size: 20.0)!
            pieChart.addSubview(label)
            
            let timeTextField = UITextField()
            timeTextField.frame = CGRect(x: (pieChart.frame.size.width) - 110, y: 0, width: 110, height: 30)
            timeTextField.textColor = .white
            timeTextField.addBorderBottom(height: 1.0, color: UIColor.lightGray)
            timeTextField.textAlignment = .center
            timeTextField.isUserInteractionEnabled = false
            timeTextField.font = UIFont(name:"DINAlternate-Bold", size: 17.0)!
            pieChart.addSubview(timeTextField)
            
            
            pieChartsViewArray.append(pieChart)
            centerTextArray.append(label)
            centerTimeArray.append(timeTextField)
        }
        
//        円グラフのデータを作成
        let genreArray = try! Realm().objects(GenreData.self).filter("selectNum == 1")
        var pieChartsDataArray = [[Double]]()
//        その他用のデータ配列
 
//        var pieChartsNameArray = [[String]]()
        var pieChartsNameArray:[String] = []
        
       
//        週・月単位の日付を取得
        let today_date = Date()
        // カレンダーを取得
        let  calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        let today_date_rounded =  roundDate(today_date, calendar: calendar)
        formatter.dateFormat = "MM/dd"

        var startDateArray:[Date] = []
        var endDateArray:[Date] = []
        var dateTitleArray:[String] = []
        
        for i in 0...6 {
            var startDate = Date()
            switch segmentNum {
            case 0:
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
                if formatter.string(from: Date()) == "Mon" {
                    startDate = Date(timeInterval: TimeInterval(-60*60*24*7*i), since: today_date_rounded)
                    
                } else {
                    startDate = Date(timeInterval: TimeInterval(-60*60*24*7*i), since:Date.today().previous(.monday))
                }
                let endDate = Date(timeInterval: 60*60*24*7 - 1, since: startDate)
                startDateArray.append(startDate)
                endDateArray.append(endDate)
                dateTitleArray = ["This week","1 week ago","2 weeks ago","3 weeks ago","4 weeks ago","5 weeks ago","6 weeks ago"]
            case 1:
                let nowDate = Date()
                let comps = calendar.dateComponents([.year, .month], from: nowDate)
                let firstday = calendar.date(from: comps)
                let add = DateComponents(month: -i, day: 0)
                let startMonth = calendar.date(byAdding: add, to: firstday!)
                let addLast = DateComponents(month: 1, day: -1)
                let LastMonth = calendar.date(byAdding: addLast, to: startMonth!)
                let lastMonth = Date(timeInterval: 60*60*24 - 1, since: LastMonth!)
                startDateArray.append(startMonth!)
                endDateArray.append(lastMonth)
                let formatter = DateFormatter()
                formatter.dateFormat = "MMMM"
                let dateString:String = formatter.string(from: lastMonth)
                dateTitleArray.append(dateString)
            default:
                break
            }
        }

//        中心に表示する総時間用の配列
        var centerTotalTimeArray:[Double] = [0,0,0,0,0,0,0]
//        円グラフに表示するジャンルごとの総時間データの取得
        for i in 0...6 {
            pieChartsDataArray.append([])
            var otherTotalTime:Double = 0.0
            for i2 in 0..<genreArray.count {
                    var totalTime:Double = 0.0
                    let taskArray = try! Realm().objects(TimeData.self).filter("date >= %@ && date <= %@ && genre == %@ ", startDateArray[i], endDateArray[i], genreArray[i2].genre)
                if  taskArray.count != 0 {
                    totalTime += Double(taskArray[0].totalTime)
                }
                    pieChartsDataArray[i].append(totalTime)
                centerTotalTimeArray[i] += totalTime
                    if i == 0 {
                        pieChartsNameArray.append(genreArray[i2].genre)
                    }
            }
        }
        
        
        
//        直近のジャンル別総時間を降順にする
        var genreIndexArray:[Int] = []
        var keepArray = pieChartsDataArray[0].map{$0 + 1}
        for _ in 0..<genreArray.count {
            let index = keepArray.firstIndex(of: keepArray.max()!)
            genreIndexArray.append(index!)
            keepArray[index!] = 0
        }
        
        
        
        var colorArray:[UIColor] = []
        
        for i in 0..<genreArray.count {
            switch i {
            case 0:
                colorArray.append(UIColor(red: 0.0, green: 1.0, blue: 0.7, alpha: 1))
            case 1:
                colorArray.append(UIColor(red: 0.0, green: 0.7, blue: 1.0, alpha: 1))
            case 2:
                colorArray.append(UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1))
            case 3:
                colorArray.append(UIColor(red: 1.0, green: 1.0, blue: 0.0, alpha: 1))
            case 4:
                colorArray.append(UIColor(red: 1.0, green: 0.7, blue: 0.2, alpha: 1))
            case 5:
                colorArray.append(UIColor(red: 1.0, green: 0.3, blue: 0.3, alpha: 1))
            case 6:
                colorArray.append(UIColor(red: 0.0, green: 1.0, blue: 1.0, alpha: 1))
            default:
                print("no")
            }
        }
        colorArray.append(UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        
//        genreIndexArrayをもとにグラフ用のデータを格納
        for i in 0...6 {
            var dataEntries = [PieChartDataEntry]()
            var otherTotalTime:Double = 0.0
            for i2 in 0..<genreArray.count {
                let num = genreIndexArray[i2]
                if i2 < 7 {
                    dataEntries.append(PieChartDataEntry(value: pieChartsDataArray[i][num], label: pieChartsNameArray[num]))
                } else {
                    otherTotalTime += pieChartsDataArray[i][num]
                }
                
            }
            dataEntries.append(PieChartDataEntry(value: otherTotalTime, label: "その他"))

            let dataset = PieChartDataSet(entries: dataEntries, label: "")
            dataset.drawValuesEnabled = false
            
            dataset.colors = colorArray
            pieChartsViewArray[i].data = PieChartData(dataSet: dataset)
            centerTextArray[i].text = "\(dateTitleArray[i])"
            
            
        }
        

        for i in 0...centerTotalTimeArray.count - 1 {
            var hourNum = 0
            var minutesNum = 0
            var secondNum = 0
            if centerTotalTimeArray[i] != 0 {
                hourNum = Int(centerTotalTimeArray[i]) / 3600
                minutesNum = (Int(centerTotalTimeArray[i]) - (hourNum*3600)) / 60
                secondNum = Int(centerTotalTimeArray[i]) - (hourNum*3600) - (minutesNum*60)
            }
            let hourStr: String = String(format: "%02d", hourNum)
            let minutesStr: String = String(format: "%02d", minutesNum)
            let secondStr: String = String(format: "%02d", secondNum)
            centerTimeArray[i].text = "Total  \(hourStr):\(minutesStr):\(secondStr)"

        }
        
      
    }

    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }
    
}

