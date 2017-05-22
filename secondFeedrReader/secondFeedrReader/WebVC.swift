//
//  WebVC.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/23/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class WebVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var articlesInfo: FeedrInfo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = URL(string:articlesInfo.pageUrl) {
            let request = NSURLRequest(url: url)
            webView.loadRequest(request as URLRequest)
        }
        
    }
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
