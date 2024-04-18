//
//  stockCell.swift
//  Capstone Project
//
//  Created by X Y on 4/15/24.
//

import UIKit

class stockCell: UITableViewCell {
    
    @IBOutlet weak var stockLogo: UIImageView!
    @IBOutlet weak var stockTicker: UILabel!
    @IBOutlet weak var stockPrice: UILabel!
    @IBOutlet weak var stockVolume: UILabel!
    @IBOutlet weak var dailyChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
