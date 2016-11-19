//
//  AccountCell.swift
//  YouTube
//
//  Created by Martijn van Gogh on 18-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

class AccountCell: FeedCell {

    override func fetchData() {
        ApiReference.sharedInstance.fetchAccount { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
