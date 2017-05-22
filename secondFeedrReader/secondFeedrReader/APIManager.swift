//
//  APIManager.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/20/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class APIManager {
    
    //Mark: JSON
    
    //create func to Parse JSON Dara
    func parsedData (sort: String, source: String, completion: @escaping ([FeedrInfo]) -> Void) {
        
        
        // API Key & URL
        let apiKey = "2731242f9c9a40b18bf24d8feced3fc3"
        let kURL = "https://newsapi.org/v1/articles?source=\(source)&sortBy=\(sort)"
        
        print(kURL)
        // URL Session here
        guard let url = URL(string: kURL) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            //Check for data errors
            guard error == nil else { return }
            
            guard let data = data else {
                print("Error with task & receiving data!")
                return
            }
            //Do, try, catch statement
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                guard let info = json?["articles"] as? [[String: Any]] else {
                    sendAlertController()
                    return
                }
                
                var news = [FeedrInfo]()
                for articles in info {
                    if let newsArticle = FeedrInfo.create(from: articles) {
                        news.append(newsArticle)
                    }
                }
                completion(news)
            }catch {
                print("Error Caught!")
            }
        }
        task.resume()
    }
}

    //Mark: Notification function

func sendAlertController() {
    
    
    //No latest feature
    let alertController = UIAlertController(title: "Message", message: "Source does not have a latest filter", preferredStyle: UIAlertControllerStyle.actionSheet)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
    
    if var topController = UIApplication.shared.keyWindow?.rootViewController {
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }
        
        // topController should now be your topmost view controller
        topController.present(alertController, animated: true, completion: nil)
    }
}



