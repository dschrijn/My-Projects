//
//  sourcesVC.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/22/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

let kSourceKey = "globalSourceKey"

class sourcesVC: UIViewController {
    
    weak var delegate: FilterDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func newAPIBtn(_ sender: Any) {
        if let url = NSURL(string: "https://newsapi.org/") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    
    }
    
    //Mark: Buttons - to change "News Sources"
    
    @IBAction func abcBtn(_ sender: Any) {
        let apiManager = APIManager()
        UserDefaults.standard.set("abc-news-au", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
        //No latest feature
    }
    @IBAction func engadgetBtn(_ sender: UIButton) {
        let apiManager = APIManager()
        UserDefaults.standard.set("engadget", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func ewBtn(_ sender: Any) {
        
        let apiManager = APIManager()
        UserDefaults.standard.set("entertainment-weekly", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
        //No latest feature
    }
    @IBAction func ignBtn(_ sender: Any) {
        let apiManager = APIManager()
        UserDefaults.standard.set("ign", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func vergeBtn(_ sender: Any) {
        let apiManager = APIManager()
        UserDefaults.standard.set("the-verge", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func usaBtn(_ sender: Any) {
        let apiManager = APIManager()
        UserDefaults.standard.set("usa-today", forKey: kSourceKey)
        let source = UserDefaults.standard.string(forKey: kSourceKey)
        apiManager.parsedData(sort: "top", source: source!) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
