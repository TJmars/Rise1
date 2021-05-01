//
//  TutorialViewController.swift
//  Rise
//
//  Created by Apple on 2021/03/05.
//

import UIKit
import Lottie
import RealmSwift

class TutorialViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private var pageControl: UIPageControl!
    var animationView:AnimationView = AnimationView()
    
    let button = UIButton(type: UIButton.ButtonType.system)
    
    var userdata: UserData!
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        view.backgroundColor = .black
        scrollView.contentSize.width = view.frame.size.width * 3
        button.addTarget(self, action: #selector(buttonEvent(_:)), for: UIControl.Event.touchUpInside)
        
        if let obj = realm.objects(UserData.self).first {
            userdata = obj
        } else {
            userdata = UserData()
        }
        
        
        //        １ページ目
        let animation = Animation.named("1")
        animationView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: view.frame.size.height * 0.375)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.backgroundColor = .clear
        scrollView.addSubview(animationView)
        animationView.play()
        
        let contentsLabel1 = UILabel()
        contentsLabel1.frame = CGRect(x: 0, y: Int(view.frame.size.height * 0.5), width: Int(view.frame.size.width), height: 30)
        contentsLabel1.textAlignment = .center
        contentsLabel1.textColor = .white
        contentsLabel1.font = UIFont(name: "DINAlternate-Bold", size: 22)
        contentsLabel1.text = "日々の予定をRiseで管理"
        scrollView.addSubview(contentsLabel1)
        
        let contentslabel2 = UILabel()
        contentslabel2.frame = CGRect(x: 15, y: Int(view.frame.size.height * 0.5625), width: Int(view.frame.size.width - 30), height: 100)
        contentslabel2.attributedText = lineHeightSetting(targetText: "Riseのカレンダーで日々の予定を把握することができます。カレンダーの日付をタップするだけのシンプルな操作、もう予定を忘れることはありません。", lineHeight: 5)
        contentslabel2.font = UIFont(name: "DINAlternate-Bold", size: 16)
        contentslabel2.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        contentslabel2.numberOfLines = 0
        contentslabel2.sizeToFit()
        contentslabel2.textAlignment = .center
        scrollView.addSubview(contentslabel2)
      
        
//        ２ページ目
        let imageView2 = UIImageView()
        imageView2.frame = CGRect(x: 30 + self.view.frame.size.width , y: 50, width: self.view.frame.size.width - 60, height: view.frame.size.height * 0.375)
        imageView2.contentMode = .scaleAspectFit
        imageView2.image = UIImage(named: "chart_Image")
        scrollView.addSubview(imageView2)
        
        let contentsLabel3 = UILabel()
        contentsLabel3.frame = CGRect(x: Int(self.view.frame.size.width), y: Int(view.frame.size.height * 0.5), width: Int(view.frame.size.width), height: 30)
        contentsLabel3.textAlignment = .center
        contentsLabel3.textColor = .white
        contentsLabel3.font = UIFont(name: "DINAlternate-Bold", size: 22)
        contentsLabel3.text = "通知機能とグラフで継続する力を"
        scrollView.addSubview(contentsLabel3)
        
        
        let contentslabel4 = UILabel()
        contentslabel4.frame = CGRect(x: 15 + Int(self.view.frame.size.width), y: Int(view.frame.size.height * 0.5625), width: Int(view.frame.size.width - 30), height: 130)
        contentslabel4.attributedText = lineHeightSetting(targetText: "Riseの通知機能はタスクごとに設定できます。継続したいタスクは繰り返し設定を行うことで、簡単に作成することが可能です。日々の達成率を一目で把握できるデータ機能はあなたのモチベーションとなるはずです。", lineHeight: 5)
        contentslabel4.font = UIFont(name: "DINAlternate-Bold", size: 16)
        contentslabel4.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        contentslabel4.numberOfLines = 0
        contentslabel4.sizeToFit()
        contentslabel4.textAlignment = .center
        scrollView.addSubview(contentslabel4)
        
        
//        ３ページ目
        let imageView3 = UIImageView()
        imageView3.frame = CGRect(x: 30 + (self.view.frame.size.width * 2 ), y: 50, width: self.view.frame.size.width - 60, height: view.frame.size.height * 0.375)
        imageView3.contentMode = .scaleAspectFit
        imageView3.image = UIImage(named: "pieChart_Image")
        scrollView.addSubview(imageView3)
        
        let contentsLabel5 = UILabel()
        contentsLabel5.frame = CGRect(x:(Int(self.view.frame.size.width) * 2 ), y: Int(view.frame.size.height * 0.5), width: Int(view.frame.size.width), height: 30)
        contentsLabel5.textAlignment = .center
        contentsLabel5.textColor = .white
        contentsLabel5.font = UIFont(name: "DINAlternate-Bold", size: 22)
        contentsLabel5.text = "行動を可視化して効率的な日々を"
        scrollView.addSubview(contentsLabel5)
        
        let contentslabel6 = UILabel()
        contentslabel6.frame = CGRect(x: 15 + (Int(self.view.frame.size.width) * 2 ) , y: Int(view.frame.size.height * 0.5625), width: Int(view.frame.size.width - 30), height: 130)
        contentslabel6.attributedText = lineHeightSetting(targetText: "タイマー機能を使えば、日々の行動時間をジャンル別に把握することができます。Riseはあなたのより効率的な行動をサポートし、あなたの1日はもっと長くなります。", lineHeight: 5)
        contentslabel6.font = UIFont(name: "DINAlternate-Bold", size: 16)
        contentslabel6.textColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        contentslabel6.numberOfLines = 0
        contentslabel6.sizeToFit()
        contentslabel6.textAlignment = .center
        scrollView.addSubview(contentslabel6)
        
        button.setTitle("Riseを始める", for: UIControl.State.normal)
        button.frame = CGRect(x: 100 + (Int(self.view.frame.size.width) * 2 ) , y: Int(view.frame.size.height * 0.8), width: Int(view.frame.size.width - 200), height: 40)
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 10
        button.titleLabel?.font = UIFont(name: "DINAlternate-Bold", size: 22)
        button.setTitleColor(.white, for: .normal)
        scrollView.addSubview(button)
        
        
        // scrollViewのデリゲートになる
        scrollView.delegate = self
        // pageControlの表示位置とサイズの設定
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.frame.size.height - 50, width: self.view.frame.size.width, height: 20))
        // pageControlのページ数を設定
        pageControl.numberOfPages = 3
        // pageControlのドットの色
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        // pageControlの現在のページのドットの色
        pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
    }
    
    
    // ボタンが押された時に呼ばれるメソッド
    @objc func buttonEvent(_ sender: UIButton) {
        try! realm.write {
            self.userdata.version = 100
            self.realm.add(self.userdata)
        }
        performSegue(withIdentifier: "toCalendar", sender: nil)
    }
    
    func lineHeightSetting(targetText: String, lineHeight: Float) -> NSMutableAttributedString {
        let LineHeightStyle = NSMutableParagraphStyle()
        LineHeightStyle.lineSpacing = CGFloat(lineHeight)
        let lineHeightAttr = [NSAttributedString.Key.paragraphStyle: LineHeightStyle]
        return NSMutableAttributedString(string: targetText, attributes: lineHeightAttr)
    }
    

}


// scrollViewのページ移動に合わせてpageControlの表示も移動させる
extension TutorialViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    }
}
