//
//  ChartViewController.swift
//  Rise
//
//  Created by Apple on 2020/11/23.
//

import UIKit
import XLPagerTabStrip
import Charts
import RealmSwift



class ChartViewController: ButtonBarPagerTabStripViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var slideMenuView = UIView()
    var slideMenuLabel = UILabel()
    var tableView = UITableView()
    var isExpanded: Bool = true
    
    
    let firstVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "First") as! FirstViewController

    let fourthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fourth") as! FourthViewController
    let fifthVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Fifth") as! FifthViewController
    
    let realm = try! Realm()
    var genreArray = try! Realm().objects(GenreData.self)
    
    @IBOutlet weak var collectionView: ButtonBarView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        
        settings.style.buttonBarBackgroundColor = .clear
        settings.style.buttonBarItemTitleColor = .white
        settings.style.buttonBarItemFont = UIFont.boldSystemFont(ofSize: 15.0)
        settings.style.selectedBarHeight = 1.0
        settings.style.selectedBarBackgroundColor = .white
        settings.style.buttonBarItemBackgroundColor = .clear
        settings.style.buttonBarMinimumInteritemSpacing = 0
        
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.rowHeight = 40
        tableView.allowsSelection = false
        
        
        
        let height = self.view.frame.size.height - (scrollView.frame.size.height + collectionView.frame.size.height)
        let height2 = scrollView.frame.size.height + collectionView.frame.size.height
        let tabHeight = height / 2
        
        collectionView.backgroundColor = .clear
        self.view.backgroundColor = .black
        
        slideMenuLabel.frame = CGRect(x: 0, y: 10, width: view.frame.size.width / 2, height: 20)
        slideMenuLabel.text = "ジャンルを選択"
        slideMenuLabel.font = UIFont(name: "DINAlternate-Bold", size: 16)
        slideMenuLabel.textColor = .white
        slideMenuLabel.textAlignment = .center
        slideMenuLabel.backgroundColor = .clear
        slideMenuView.addSubview(slideMenuLabel)
        
        tableView.frame = CGRect(x: 0, y: 30, width: view.frame.size.width / 2, height: (height2 * 2 / 3) - 20)
        tableView.backgroundColor = .clear
        tableView.separatorColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        slideMenuView.layer.cornerRadius = 5.0
        slideMenuView.layer.borderWidth = 2.0
        slideMenuView.layer.borderColor = UIColor.black.cgColor
        slideMenuView.addSubview(tableView)
        
        slideMenuView.frame = CGRect(x: -(view.frame.size.width / 2), y: tabHeight, width: view.frame.size.width / 2, height: height2 * 2 / 3)
        slideMenuView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        self.view.addSubview(slideMenuView)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
                
        cell.subviews.forEach { $0.removeFromSuperview()}
        cell.backgroundColor = .clear
        let label = UILabel()
        label.frame = CGRect(x: 50, y: 0, width: (self.view.frame.size.width/2)-50, height: 40)
        label.text = genreArray[indexPath.row].genre
        label.textColor = .white
        label.font = UIFont(name: "DINAlternate-Bold", size: 16)
        cell.addSubview(label)
        
        let genre = genreArray[indexPath.row]
        
        let checkButton = UIButton()
        checkButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        checkButton.addTarget(self, action: #selector(tapCheckButton(_:)), for: .touchUpInside)
        checkButton.tag = indexPath.row
        if genre.selectNum == 0 {
            checkButton.setImage(UIImage(named:"noCheck"), for: .normal)
        } else {
            checkButton.setImage(UIImage(named: "check"), for: .normal)
        }
        
        cell.contentView.addSubview(checkButton)
        
                return cell
    }
    
    @objc func tapCheckButton(_ sender:UIButton) {
        let genre = genreArray[sender.tag]
        if genre.selectNum == 0 {
            try! realm.write {
                genre.selectNum = 1
                self.realm.add(genre, update: .modified)
            }
        } else {
            try! realm.write {
                genre.selectNum = 0
                self.realm.add(genre, update: .modified)
            }
        }
        tableView.reloadData()
    }
   
    
    @IBAction func filterButton(_ sender: Any) {
        isExpanded = !isExpanded
            showMenu(shouldExpand: isExpanded)
        if isExpanded {
            firstVC.createGraph()
            fourthVC.createGraph()
            fifthVC.createGraph()
        }
      
        
    }
    
    func showMenu(shouldExpand: Bool) {
        if shouldExpand {
            // show menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {

                self.slideMenuView.frame.origin.x = -(self.view.frame.size.width / 2)

            }, completion: nil)
        } else {
            // hide menu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {


                self.slideMenuView.frame.origin.x = 0
            }, completion: nil)
        }
    }
    
    

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
            //管理されるViewControllerを返す処理
            
        let childViewControllers:[UIViewController] = [firstVC,fourthVC,fifthVC]
            return childViewControllers
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let calenderHelpViewController:CalendarHelpViewController = segue.destination as! CalendarHelpViewController
        calenderHelpViewController.parentViewName = "chart"
    }


    
}





extension Date {

  static func today() -> Date {
      return Date()
  }

  func next(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.Next,
               weekday,
               considerToday: considerToday)
  }

  func previous(_ weekday: Weekday, considerToday: Bool = false) -> Date {
    return get(.Previous,
               weekday,
               considerToday: considerToday)
  }

  func get(_ direction: SearchDirection,
           _ weekDay: Weekday,
           considerToday consider: Bool = false) -> Date {

    let dayName = weekDay.rawValue

    let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

    assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

    let searchWeekdayIndex = weekdaysName.index(of: dayName)! + 1

    let calendar = Calendar(identifier: .gregorian)

    if consider && calendar.component(.weekday, from: self) == searchWeekdayIndex {
      return self
    }

    var nextDateComponent = DateComponents()
    nextDateComponent.weekday = searchWeekdayIndex


    let date = calendar.nextDate(after: self,
                                 matching: nextDateComponent,
                                 matchingPolicy: .nextTime,
                                 direction: direction.calendarSearchDirection)

    return date!
  }

}

// MARK: Helper methods
extension Date {
  func getWeekDaysInEnglish() -> [String] {
    var calendar = Calendar(identifier: .gregorian)
    calendar.locale = Locale(identifier: "en_US_POSIX")
    return calendar.weekdaySymbols
  }

  enum Weekday: String {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday
  }

  enum SearchDirection {
    case Next
    case Previous

    var calendarSearchDirection: Calendar.SearchDirection {
      switch self {
      case .Next:
        return .forward
      case .Previous:
        return .backward
      }
    }
  }
}

