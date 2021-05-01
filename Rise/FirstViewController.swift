//
//  FirstViewController.swift
//  Rise
//
//  Created by Apple on 2021/02/09.
//

import UIKit
import XLPagerTabStrip
import Charts
import RealmSwift

// 登録数
class FirstViewController: UIViewController, IndicatorInfoProvider {
    
    //必須
    var itemInfo: IndicatorInfo = "タスク数"
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return itemInfo
    }
    
    //    日、週、月のsegment
        var segmentNum = 0
    //    realm
        let realm = try! Realm()
    //    ジャンル用の変数
        var genreData:GenreData!
        //    charts用の変数
        var xvalues:[String] = []
    
//    グラフのデータ用変数
    var lineData = [ChartDataEntry]()
    var barData = [BarChartDataEntry]()
    
    //    chartsViewの作成
    var chartView = CombinedChartView()
//    chartViewの単位ラベル
    let leftAxisLabel = UILabel()
    let rightAxisLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        背景色を設定
        self.view.backgroundColor = .black
        
        //        chartViewのframe
        self.chartView.frame = CGRect(x: 0, y: 90, width: view.frame.size.width, height: 350)
        self.view.addSubview(chartView)
        self.chartView.backgroundColor = .clear
        self.chartView.layer.cornerRadius = 10.0
        self.chartView.layer.masksToBounds = true
        
        self.leftAxisLabel.frame = CGRect(x: 5, y: 320, width: 20, height: 10)
        self.leftAxisLabel.font = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        self.rightAxisLabel.frame = CGRect(x: chartView.frame.size.width - 20, y: 320, width: 20, height: 10)
        self.rightAxisLabel.font = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        self.leftAxisLabel.text = "(%)"
        self.leftAxisLabel.textAlignment = .center
        self.rightAxisLabel.text = "(個)"
        self.rightAxisLabel.textAlignment = .center
        self.leftAxisLabel.textColor = .white
        self.rightAxisLabel.textColor = .white
        chartView.addSubview(leftAxisLabel)
        chartView.addSubview(rightAxisLabel)
        
        
        //        segmentの作成
        let params = ["day", "week", "month"]
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
        
        self.xvalues = []
        self.lineData = [ChartDataEntry]()
        self.barData = [BarChartDataEntry]()
        let genreArray = try! Realm().objects(GenreData.self).filter("selectNum == 1")
        var genreNameList:[String] = []
        var graphDataArray:[Double] = []
        var lineGraphDataArray:[Double] = []
        
        for i in 0..<genreArray.count {
            genreNameList.append(genreArray[i].genre)
        }
        
        let today_date = Date()
        // カレンダーを取得
        let  calendar = Calendar(identifier: .gregorian)
        let formatter = DateFormatter()
        let today_date_rounded =  roundDate(today_date, calendar: calendar)
        formatter.dateFormat = "M/d"
        
        switch self.segmentNum {
        case 0:
            
//            x軸のラベルを作成
            var dateArray:[String] = []
            for i in 0...8 {
                let displayDate = Date(timeInterval: TimeInterval(-1*60*60*24*i), since: today_date_rounded)
                let dateString:String = formatter.string(from: displayDate)
                dateArray.append(dateString)
            }
            for i in 0...dateArray.count - 1 {
                self.xvalues.append(dateArray[8 - i])
            }
            
//            グラフの数値を作成
            
            for i in 0...8 {
                var dataNum:Double = 0.0
                var lineDataNum:Double = 0.0
                let startDay = Date(timeInterval: TimeInterval(-60*60*24*(8-i)), since: today_date_rounded)
                let endDay = Date(timeInterval: 60*60*24 - 1, since: startDay)
                for i2 in 0..<genreNameList.count {
                    let taskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ ", startDay, endDay, genreNameList[i2])
                    dataNum += Double(taskArray.count)
                    
                    let lineTaskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ && inTimeCheck == 2 ", startDay, endDay, genreNameList[i2])
                    lineDataNum += Double(lineTaskArray.count)
                }
                graphDataArray.append(dataNum)
                
                var lineData:Double = 0.0
                if lineDataNum != 0.0 {
                    lineData = (lineDataNum / dataNum) * 100
                }
                lineGraphDataArray.append(lineData)
            }
            
        case 1:
            //            x軸のラベルを作成
            let dateArray:[String] = ["今週","先週","先々週","3週前","4週前","5週前","6週前","7週前","8週前"]
            for i in 0...dateArray.count - 1 {
                self.xvalues.append(dateArray[8 - i])
            }
            

            //            グラフの数値を作成
           
            for i in 0...8 {
                var dataNum:Double = 0.0
                var lineDataNum:Double = 0.0
                var startDay = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "EEE", options: 0, locale: Locale.current)
                if formatter.string(from: Date()) == "Mon" {
                    startDay = Date(timeInterval: TimeInterval(-60*60*24*7*(8-i)), since: today_date_rounded)
                    
                } else {
                    startDay = Date(timeInterval: TimeInterval(-60*60*24*7*(8-i)), since:Date.today().previous(.monday))
                }
                
                let endDay = Date(timeInterval: 60*60*24*7 - 1, since: startDay)
               
                for i2 in 0..<genreNameList.count {
                    let taskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ ", startDay, endDay, genreNameList[i2])
                    dataNum += Double(taskArray.count)
                    
                    let lineTaskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ && inTimeCheck == 2 ", startDay, endDay, genreNameList[i2])
                    lineDataNum += Double(lineTaskArray.count)
                }
                graphDataArray.append(dataNum)
                var lineData:Double = 0.0
                if lineDataNum != 0.0 {
                    lineData = (lineDataNum / dataNum) * 100
                }
                lineGraphDataArray.append(lineData)
            }
           
        case 2:
            let nowDate = Date()
            let comps = calendar.dateComponents([.year, .month], from: nowDate)
            let firstday = calendar.date(from: comps)
            var dateArray:[String] = []
            formatter.dateFormat = "MMM"
            for i in 0...8 {
                let add = DateComponents(month: -i, day: 0)
                let lastday = calendar.date(byAdding: add, to: firstday!)
                let dateString:String = formatter.string(from: lastday!)
                
                dateArray.append(dateString)
            }
            for i in 0...dateArray.count - 1 {
                self.xvalues.append(dateArray[8 - i])
            }
            
            
//            グラフの数値を作成
            for i in 0...8 {
                var dataNum:Double = 0.0
                var lineDataNum:Double = 0.0
                let add = DateComponents(month: -(8-i), day: 0)
                let startMonth = calendar.date(byAdding: add, to: firstday!)
                let addLast = DateComponents(month: 1, day: -1)
                let LastMonth = calendar.date(byAdding: addLast, to: startMonth!)
                let lastMonth = Date(timeInterval: 60*60*24 - 1, since: LastMonth!)
                
                for i2 in 0..<genreNameList.count {
                    let taskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ ", startMonth as Any, lastMonth, genreNameList[i2])
                    dataNum += Double(taskArray.count)
                    
                    let lineTaskArray = try! Realm().objects(Task.self).filter("date >= %@ && date <= %@ && genre == %@ && inTimeCheck == 2 ", startMonth as Any, lastMonth, genreNameList[i2])
                    lineDataNum += Double(lineTaskArray.count)
                }
                graphDataArray.append(dataNum)
                var lineData:Double = 0.0
                if lineDataNum != 0.0 {
                    lineData = (lineDataNum / dataNum) * 100
                }
                lineGraphDataArray.append(lineData)
            }
        
            
        default:
            break
        }
        
        // グラフにいれるデータ
        for i in 0...8 {
            
            lineData.append(BarChartDataEntry(x: Double(i), y:lineGraphDataArray[i] ))
            barData.append(BarChartDataEntry(x: Double(i), y: graphDataArray[i]))
        }
        
        let lineDataSet = LineChartDataSet(entries: lineData, label: "達成率")
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        lineDataSet.colors = [UIColor(red: 1.0, green: 0.0, blue: 1.0, alpha: 1)]
        lineDataSet.lineWidth = 2.0
        lineDataSet.axisDependency = .left
        
        let barDataSet = BarChartDataSet(entries: barData, label: "登録数")
        barDataSet.drawValuesEnabled = false
        barDataSet.colors = [UIColor(red: 0.0, green: 1.0, blue: 0.8, alpha: 1)]
        barDataSet.axisDependency = .right
        
        
        
        let lineChartData = LineChartData(dataSets: [lineDataSet])
        
        let barChartData = BarChartData(dataSets: [barDataSet])

        let barWidth = 0.7

        barChartData.setDrawValues(false)
        barChartData.barWidth = barWidth
        
        
        let combinedData = CombinedChartData()
        combinedData.lineData = lineChartData
        combinedData.barData = barChartData
        
        //legend
        let legend = chartView.legend
        
        legend.enabled = true
        
        chartView.data = combinedData
        self.chartView.legend.textColor = .white
        self.chartView.legend.font = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        self.chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: xvalues)
        chartView.xAxis.labelCount = 9
        chartView.xAxis.spaceMin = 0.5
        chartView.xAxis.spaceMax = 0.5
        chartView.xAxis.yOffset = 0
        chartView.xAxis.labelTextColor = .white
        chartView.xAxis.axisLineColor = .white
        chartView.xAxis.axisLineWidth = 0.13
        chartView.xAxis.labelFont = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        chartView.leftAxis.labelCount = 5
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.labelTextColor = .white
        chartView.leftAxis.axisLineColor = .white
        chartView.leftAxis.axisLineWidth = 0.13
        chartView.leftAxis.labelFont = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        chartView.rightAxis.labelFont = UIFont(name:"DINAlternate-Bold", size: 11.0)!
        chartView.rightAxis.labelCount = 5
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisMaximum = 100
        chartView.leftAxis.axisMinimum = 0
        chartView.rightAxis.axisMinimum = 0
        chartView.rightAxis.granularity = 1.0
        chartView.rightAxis.labelTextColor = .white
        chartView.rightAxis.axisLineColor = .white
        chartView.rightAxis.axisLineWidth = 0.13
        chartView.chartDescription?.text = ""
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.scaleXEnabled = false
        chartView.scaleYEnabled = false
        chartView.dragEnabled = false
        chartView.notifyDataSetChanged()
        chartView.highlightPerTapEnabled = false
        

        chartView.leftAxis.valueFormatter = YAxisValueFormatter()
        chartView.leftAxis.spaceBottom = 0.0
        chartView.rightAxis.spaceBottom = 0.0
    }
    
    
    // Dateから年日月を抽出する関数
    func roundDate(_ date: Date, calendar cal: Calendar) -> Date {
        return cal.date(from: DateComponents(year: cal.component(.year, from: date), month: cal.component(.month, from: date), day: cal.component(.day, from: date)))!
    }
    
}

class YAxisValueFormatter: NSObject, IAxisValueFormatter {
    let numFormatter: NumberFormatter
    
    override init() {
        numFormatter = NumberFormatter()
        numFormatter.numberStyle = NumberFormatter.Style.decimal
        numFormatter.groupingSeparator = ","
        numFormatter.groupingSize = 3
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return numFormatter.string(from: NSNumber(floatLiteral: value))!
    }
}
