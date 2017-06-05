//
//  initialVC.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/21/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class initialVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FilterDelegate {
    
    @IBOutlet weak var tableVC: UITableView!
    @IBOutlet weak var btnView: UIView!
    
    var spinner = UIActivityIndicatorView()
    var loadingView = UIView()
    var loadingLabel = UILabel()
    
    func newsUpdate(_ news: [FeedrInfo]) {
        self.news = news
        tableVC.reloadData()
    }
    
    // Calls FeedrInfo class
    var news = [FeedrInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableVC.separatorStyle = .none
        self.setLoadScreen()
        
        //Register the Nib
        self.tableVC.register(UINib (nibName: "customTVCell", bundle: nil), forCellReuseIdentifier: "myCell")
        
        // Configure table view cell row height
        self.tableVC.rowHeight = UITableViewAutomaticDimension
        tableVC.tableHeaderView = btnView
        
        self.tableVC.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    private func setLoadScreen () {
        
        // Sets the view which contains the loading text and the spinner
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (self.tableVC.frame.width / 2) - (width / 2)
        let y = (self.tableVC.frame.height / 2) - (height / 2)
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        // Sets loading text
        self.loadingLabel.textColor = UIColor.gray
        self.loadingLabel.textAlignment = NSTextAlignment.center
        self.loadingLabel.text = "Loading..."
        self.loadingLabel.frame = CGRect(x: -10, y: -80, width: 100, height: 70)
        
        // Sets spinner
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.spinner.frame = CGRect(x: 20, y: -80, width: 30, height: 30)
        self.spinner.startAnimating()
        
        // Adds text and spinner to the view
        loadingView.addSubview(self.spinner)
        loadingView.addSubview(self.loadingLabel)
        
        self.tableVC.addSubview(loadingView)
        
    }
    
    //Remove the activity indicator from the main view
    
    private func removeLoadingScreen() {
        
        //Hides and stops the text and the spinner
        self.spinner.stopAnimating()
        self.loadingLabel.isHidden = true
        self.tableVC.separatorStyle = .singleLine
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let apiManager = APIManager()
        let source = UserDefaults.standard.string(forKey: kSourceKey)!
        apiManager.parsedData(sort: "top", source: source) { (news) in
            self.news = news
            print(news)
            //Reloads tableview
            DispatchQueue.main.async {
                self.removeLoadingScreen()
                self.tableVC.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    //    Sets height for row
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableVC.dequeueReusableCell(withIdentifier: "myCell", for: indexPath) as! customTVCell
        
        if self.news[indexPath.row].image == nil {
            
            // Calling getImage method inside "class FeedrInfo" using the instances of FeedrInfo in the news array
            news[indexPath.row].getImage() { (valueOfImage) in
                if self.tableVC.indexPathsForVisibleRows?.contains(indexPath) == true {
                    self.news[indexPath.row].image = valueOfImage
                    DispatchQueue.main.async {
                        cell.imageReview.image = self.news[indexPath.row].image
                    }
                    
                }
            }
        } else {
            cell.imageReview.image = self.news[indexPath.row].image
        }
        
        cell.firstLabel.text = news[indexPath.row].title
        
        
        return cell
    }
    
    // Mark: - Segue to second View Controller
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let articleInfo = news[indexPath.row]
        
        performSegue(withIdentifier: "toWebView", sender: articleInfo)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WebVC {
            if let theArticle = sender as? FeedrInfo {
                destination.articlesInfo = theArticle
            }
        }
        
        if let destination = segue.destination as? filterVC {
            destination.delegate = self
        }
        
        if let destination = segue.destination as? sourcesVC {
            destination.delegate = self
        }
        
    }
    
    
    //Mark: - Buttons to segue to Sources & Filter
    
    @IBAction func sourcesBtn(_ sender: Any) {
        performSegue(withIdentifier: "toSources", sender: self)
        
    }
    @IBAction func newsAPIBtn(_ sender: Any) {
        //UIApplication.shared.openURL(URL(string: "https://newsapi.org/")!)
        if let url = NSURL(string: "https://newsapi.org/") {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
}

