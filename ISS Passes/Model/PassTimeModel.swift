//
//  PassTimeModel.swift
//  ISS Passes
//
//  Created by Rafael Aguilera on 1/18/18.
//  Copyright © 2018 Rafael Aguilera. All rights reserved.
//

import UIKit

class PassTimeModel{
    var duration: Int
    var timeStamp: NSDate
    
    init(duration: Int, timeStamp: Double){
        self.duration = duration
        self.timeStamp = NSDate(timeIntervalSince1970: timeStamp)
    }
    init(){
        self.duration = 0
        self.timeStamp = NSDate.init()
    }
}

