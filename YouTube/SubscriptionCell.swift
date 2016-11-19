//
//  SubscriptionCell.swift
//  YouTube
//
//  Created by Martijn van Gogh on 18-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

class SubscriptionCell: FeedCell {

    override func fetchData() {
        ApiReference.sharedInstance.fetchSubscription { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
