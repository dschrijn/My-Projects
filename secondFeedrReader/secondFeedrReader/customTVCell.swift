//
//  customTVCell.swift
//  secondFeedrReader
//
//  Created by David A. Schrijn on 3/20/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class customTVCell: UITableViewCell {

    
    @IBOutlet weak var imageReview: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
