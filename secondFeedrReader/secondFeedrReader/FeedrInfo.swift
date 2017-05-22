//
//  FeedrInfo.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/20/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import Foundation
import UIKit

class FeedrInfo {
    
    //Input variables
    var arthor: String
    var title: String
    var description: String
    var pageUrl: String
    var image: UIImage?
    var imageURL: String
    
    //Initialize variables
    init (author: String, title: String, description: String, pageUrl: String, imageURL: String) {
        self.arthor = author
        self.title = title
        self.description = description
        self.pageUrl = pageUrl
        self.imageURL = imageURL
        
    }
    
    //UIImage URL request function
    
    func getImage(_ completion: @escaping (UIImage) -> Void) {
        
        guard let url = URL(string: self.imageURL) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            guard let responseData = data else {
                return
            }
            guard let image = UIImage(data: responseData) else {
                return
            }
            
            completion(image)
        }
        task.resume()
    }
    
    
    
    //Static function for FeedrInfo
    
    static func create(from dictionary: [String: Any]) -> FeedrInfo? {
        
        
        guard let author = dictionary["author"] as? String else {
            return nil
        }
        guard let title = dictionary["title"] as? String else {
            return nil
        }
        guard let description = dictionary["description"] as? String else {
            return nil
        }
        guard let imageLinks = dictionary["urlToImage"] as? String else {
            return nil
        }
        guard let pageUrl = dictionary["url"] as? String else {
            return nil
        }
        return FeedrInfo(author: author, title: title, description: description, pageUrl: pageUrl, imageURL: imageLinks)
    }
}

