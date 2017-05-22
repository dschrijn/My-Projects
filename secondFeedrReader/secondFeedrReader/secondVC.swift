//
//  secondVC.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/21/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class secondVC: UIViewController {

    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var articlesInfo: FeedrInfo!
    
    
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authorLabel.text = articlesInfo.arthor
        imageView.image = articlesInfo.image
        titleLabel.text = articlesInfo.title
        descriptionLabel.text = articlesInfo.description
             
    }
    

    

}
