//
//  SplashViewController.swift
//  Rise
//
//  Created by Apple on 2021/03/05.
//

import UIKit
import LTMorphingLabel
import RealmSwift

class SplashViewController: UIViewController {
 
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var label: LTMorphingLabel!
    
    var userdata: UserData!
    let realm = try! Realm()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let obj = realm.objects(UserData.self).first {
                    userdata = obj
                } else {
                    userdata = UserData()
                  }

        
        view.backgroundColor = .black
        imageView.image = UIImage(named: "icons")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.label.text = "Welcome to Rise!"
            self.label.morphingEffect = .scale
            self.label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30)
            self.label.textColor =  UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            if self.userdata.version == 100 {
                self.performSegue(withIdentifier: "toCalendar", sender: nil)
            } else {
                self.performSegue(withIdentifier: "toTutorial", sender: nil)
            }
            
        }

    }
    


}
