//
//  MemeTableViewCell.swift
//  MemeMe
//
//  Created by Sulaiman Azhar on 5/18/15.
//  Copyright (c) 2015 kazmi. All rights reserved.
//

import UIKit

class MemeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var memedImageView: UIImageView!
    @IBOutlet weak var memeTextLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
