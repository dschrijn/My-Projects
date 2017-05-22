//
//  filterVC.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/22/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func newsUpdate(_ news: [FeedrInfo])
}

class filterVC: UIViewController {
    
    weak var delegate: FilterDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func topBtn(_ sender: Any) {
        let apiManager = APIManager()
        let source = UserDefaults.standard.string(forKey: kSourceKey)!
        apiManager.parsedData(sort: "top", source: source) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func latestBtn(_ sender: Any) {
        let apiManager = APIManager()
        let source = UserDefaults.standard.string(forKey: kSourceKey)!
        apiManager.parsedData(sort: "latest", source: source) { (news) in
            self.delegate?.newsUpdate(news)
            self.dismiss(animated: true, completion: nil)
        }
    }
}
