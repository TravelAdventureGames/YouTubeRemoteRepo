//
//  Video.swift
//  YouTube
//
//  Created by Martijn van Gogh on 11-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

class Video: NSObject {
    
    var thumbNailImage: String?
    var title: String?
    var channel: Channel?
    var numberOfViews: NSNumber?
    var date: NSData?
}

class Channel: NSObject {
    var profileImage: String?
    var name: String?
    
}
