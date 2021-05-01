//
//  HelpContentsViewController.swift
//  Rise
//
//  Created by Apple on 2021/03/03.
//

import UIKit

class HelpContentsViewController: UIViewController {
    
    var parentViewName = ""
    var segueIndex = 0
    var helpTitle = ""
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
//    UI
    let titleLabel = UILabel()
    let contentsLabel = UILabel()
    let imageView = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        createUI()
        
        //        どこからのsegueか反別
        if parentViewName == "calendar" {
            fromCalendar()
        } else if parentViewName == "input" {
            fromInput()
        } else if parentViewName == "chart" {
            fromChart()
        }
    }
    

//    calendarから遷移してきた時
    func fromCalendar(){
        titleLabel.text = helpTitle
        switch segueIndex {
        case 0:
            scrollView.contentSize.height = 860
            titleLabel.text = "ようこそ、Riseへ"
            titleLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
            let imageView1 = UIImageView()
            imageView1.image = UIImage(named: "icons")
            imageView1.contentMode = .scaleAspectFit
            imageView1.frame = CGRect(x: 0, y: 70, width: Int(view.frame.size.width), height: 150)
            scrollView.addSubview(imageView1)
            
            let contentsLabel1 = UILabel()
            contentsLabel1.frame = CGRect(x: 0, y: 250, width: Int(view.frame.size.width), height: 30)
            contentsLabel1.textAlignment = .center
            contentsLabel1.textColor = .white
            contentsLabel1.font = UIFont(name: "DINAlternate-Bold", size: 22)
            contentsLabel1.text = "日々の予定をRiseで管理"
            scrollView.addSubview(contentsLabel1)
            
            let contentslabel2 = UILabel()
            contentslabel2.frame = CGRect(x: 15, y: 290, width: Int(view.frame.size.width - 30), height: 100)
            contentslabel2.attributedText = lineHeightSetting(targetText: "Riseのカレンダーで日々の予定を把握することができます。カレンダーの日付をタップするだけのシンプルな操作、もう予定を忘れることはありません。", lineHeight: 5)
            contentslabel2.font = UIFont(name: "DINAlternate-Bold", size: 16)
            contentslabel2.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            contentslabel2.numberOfLines = 0
            contentslabel2.sizeToFit()
            scrollView.addSubview(contentslabel2)
            
            
            let contentsLabel3 = UILabel()
            contentsLabel3.frame = CGRect(x: 0, y: 430, width: Int(view.frame.size.width), height: 30)
            contentsLabel3.textAlignment = .center
            contentsLabel3.textColor = .white
            contentsLabel3.font = UIFont(name: "DINAlternate-Bold", size: 22)
            contentsLabel3.text = "通知機能とグラフで継続する力を"
            scrollView.addSubview(contentsLabel3)
            
            
            let contentslabel4 = UILabel()
            contentslabel4.frame = CGRect(x: 15, y: 470, width: Int(view.frame.size.width - 30), height: 130)
            contentslabel4.attributedText = lineHeightSetting(targetText: "Riseの通知機能はタスクごとに設定できます。継続したいタスクは繰り返し設定を行うことで、簡単に作成することが可能です。日々の達成率を一目で把握できるデータ機能はあなたのモチベーションとなるはずです。", lineHeight: 5)
            contentslabel4.font = UIFont(name: "DINAlternate-Bold", size: 16)
            contentslabel4.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            contentslabel4.numberOfLines = 0
            contentslabel4.sizeToFit()
            scrollView.addSubview(contentslabel4)
            
            let contentsLabel5 = UILabel()
            contentsLabel5.frame = CGRect(x: 0, y: 630, width: Int(view.frame.size.width), height: 30)
            contentsLabel5.textAlignment = .center
            contentsLabel5.textColor = .white
            contentsLabel5.font = UIFont(name: "DINAlternate-Bold", size: 22)
            contentsLabel5.text = "行動を可視化して効率的な日々を"
            scrollView.addSubview(contentsLabel5)
            
            let contentslabel6 = UILabel()
            contentslabel6.frame = CGRect(x: 15, y: 670, width: Int(view.frame.size.width - 30), height: 130)
            contentslabel6.attributedText = lineHeightSetting(targetText: "タイマー機能を使えば、日々の行動時間をジャンル別に把握することができます。Riseはあなたのより効率的な行動をサポートし、あなたの1日はもっと長くなります。", lineHeight: 5)
            contentslabel6.font = UIFont(name: "DINAlternate-Bold", size: 16)
            contentslabel6.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            contentslabel6.numberOfLines = 0
            contentslabel6.sizeToFit()
            scrollView.addSubview(contentslabel6)
           
        case 1:
            imageView.image = UIImage(named: "addTask")
            contentsLabel.attributedText = lineHeightSetting(targetText: "新しいタスクを追加するには、画面右上の｢＋」ボタンをタップしてください。", lineHeight: 5)
        case 2:
            imageView.image = UIImage(named: "changeTask")
            contentsLabel.attributedText = lineHeightSetting(targetText: "保存したタスクの内容を変更するには、該当するタスクをタップしてください。", lineHeight: 5)
        case 3:
            imageView.image = UIImage(named: "finishTask")
            contentsLabel.attributedText = lineHeightSetting(targetText: "タスクを完了するには、画面左の白い円をタップしてください。円にチェックが入り、タスク名に打ち消し線が入ればタスクが完了できています。", lineHeight: 5)
        case 4:
            scrollView.contentSize.height = 1030
            imageView.image = UIImage(named: "deleteTask1")
            contentsLabel.attributedText = lineHeightSetting(targetText: "タスクを削除するには、タスクを左にスライドし、Deleteボタンをタップしてください。タスクを削除すると、そのタスクの取り組み時間データなどが失われるため、基本的に削除する必要はありません。また、タスク設定日から10ヶ月が経過すると、タスクは自動的に削除されます。", lineHeight: 5)
            let imageView2 = UIImageView()
            imageView2.image = UIImage(named: "deleteTask2")
            imageView2.frame = CGRect(x: 0, y: 580, width: self.view.frame.size.width, height: 300)
            imageView2.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView2)
            
            let contentsLabel2 = UILabel()
            contentsLabel2.attributedText = lineHeightSetting(targetText: "タスクの取り組み時間を計測するには、画面右の時計ボタンをタップしてタイマー画面へと進んでください。", lineHeight: 5)
                       
            contentsLabel2.frame = CGRect(x: 15, y: 880, width: self.view.frame.size.width - 30, height: 150)
            contentsLabel2.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            contentsLabel2.font = UIFont(name: "DINAlternate-Bold", size: 16)
            contentsLabel2.numberOfLines = 0
            scrollView.addSubview(contentsLabel2)
            
        case 5:
            scrollView.contentSize.height = 880
            imageView.image = UIImage(named: "timerTask1")
            contentsLabel.attributedText = lineHeightSetting(targetText: "タスクの取り組み時間を計測するには、画面右の時計ボタンをタップしてタイマー画面へと進んでください。", lineHeight: 5)
            let imageView2 = UIImageView()
            imageView2.image = UIImage(named: "timerTask2")
            imageView2.frame = CGRect(x: 0, y: 580, width: self.view.frame.size.width, height: 150)
            imageView2.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView2)
            
            let contentsLabel2 = UILabel()
            contentsLabel2.attributedText = lineHeightSetting(targetText: "タイマーが作動中のタスクは、アイコンの右上に赤丸が表示されます。正確なデータを取得するために、タイマーの停止忘れにご注意ください。", lineHeight: 5)
            contentsLabel2.frame = CGRect(x: 15, y: 730, width: self.view.frame.size.width - 30, height: 150)
            contentsLabel2.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            contentsLabel2.font = UIFont(name: "DINAlternate-Bold", size: 16)
            contentsLabel2.numberOfLines = 0
            scrollView.addSubview(contentsLabel2)
            
        default:
            break
        }
        
    }
    
    

    func fromInput(){
        titleLabel.text = helpTitle
        switch segueIndex {
        case 0:
            imageView.image =  UIImage(named: "mustInput")
            contentsLabel.attributedText = lineHeightSetting(targetText: "タスクの内容、設定日、ジャンルは必須事項であり、これらが未入力の場合エラーとなります。各項目の詳細については左上のBackボタンから画面を戻り、確認してください。", lineHeight: 5)
        case 1:
            imageView.image = UIImage(named: "repeatInput")
            contentsLabel.attributedText = lineHeightSetting(targetText: "タスクを繰り返したい場合、このボタンをタップし、繰り返す頻度と期間を設定してください。頻度と期間の変更もこのボタンから可能です。選択日から最低でも2日間経過した日を設定する必要があります。", lineHeight: 5)
        case 2:
            imageView.image = UIImage(named: "timeInput")
            contentsLabel.attributedText = lineHeightSetting(targetText: "開始時間と終了時間はここから設定できます。\n開始時間：通知が行われる時間\n終了時間：時間内にタスクが完了したか反別するのに使用\n未入力の場合、開始時間には選択日の00:00が、終了時間には23:59が設定されます。", lineHeight: 5)
        case 3:
            imageView.image = UIImage(named: "genreInput")
            contentsLabel.attributedText = lineHeightSetting(targetText: "ジャンルの入力は必須です。既存のジャンルはスクロールから選択し、新規の場合は入力してください。", lineHeight: 5)
        default:
            break
        }
    }
   
    func fromChart(){
        titleLabel.text = helpTitle
        switch segueIndex {
        case 0:
            imageView.image = UIImage(named: "sumChart")
            contentsLabel.attributedText = lineHeightSetting(targetText: "登録数：緑色の棒グラフで表されます。\n達成率：ピンクの折線グラフで表されます。登録数のうち時間内に完了したタスクの割合です。", lineHeight: 5)
        case 1:
            imageView.image = UIImage(named: "timeChart")
            contentsLabel.attributedText = lineHeightSetting(targetText: "総時間：緑色の棒グラフで表されます。タスクに取り組んだ時間の合計です。\n時間効率：ピンクの折線グラフで表されます。１時間あたりに完了できたタスク数です。", lineHeight: 5)
        case 2:
            imageView.image = UIImage(named: "pieChart")
            contentsLabel.attributedText = lineHeightSetting(targetText: "ジャンルごとの取り組み時間を円グラフで表します。ジャンルが7つ以上選択されている場合、割合の少ないものは「その他」にまとめられます。", lineHeight: 5)
        case 3:
            imageView.image = UIImage(named: "genreChange")
            contentsLabel.attributedText = lineHeightSetting(targetText: "表示するデータに含めたくないジャンルがある場合、｢Genre」ボタンをタップし、チェックを外すことで実現できます。ジャンルの変更を適用するには、もう一度ボタンをタップし、スライドを閉じてください。", lineHeight: 5)
        default:
            break
        }
    }
    
//    UI作成
    func createUI(){
        titleLabel.frame = CGRect(x: 0, y: 15, width: self.view.frame.size.width, height: 50)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "DINAlternate-Bold", size: 25)
        titleLabel.textColor = .white
        scrollView.addSubview(titleLabel)
        
        imageView.frame = CGRect(x: 0, y: 65, width: self.view.frame.size.width, height: 300)
        imageView.contentMode = .scaleAspectFit
        scrollView.addSubview(imageView)
        
        contentsLabel.frame = CGRect(x: 15, y: 370, width: self.view.frame.size.width - 30, height: 180)
//        contentsLabel.sizeToFit()
        contentsLabel.font = UIFont(name: "DINAlternate-Bold", size: 16)
        contentsLabel.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        contentsLabel.numberOfLines = 0
        
        
        scrollView.addSubview(contentsLabel)
                
    }
    
    func lineHeightSetting(targetText: String, lineHeight: Float) -> NSMutableAttributedString {
        let LineHeightStyle = NSMutableParagraphStyle()
        LineHeightStyle.lineSpacing = CGFloat(lineHeight)
        let lineHeightAttr = [NSAttributedString.Key.paragraphStyle: LineHeightStyle]
        return NSMutableAttributedString(string: targetText, attributes: lineHeightAttr)
    }
    
}

