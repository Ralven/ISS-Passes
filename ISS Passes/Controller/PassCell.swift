//
//  PassCell.swift
//  ISS Passes
//
//  Created by Rafael Aguilera on 1/19/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//

import UIKit

class PassCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    func setPassTime(passTime:PassTimeModel){
        dateLabel.text = "Date: \(passTime.timeStamp)"
        durationLabel.text = "Duration: \(passTime.duration) Seconds"
    }

}
