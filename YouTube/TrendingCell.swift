//
//  TrendingCell.swift
//  YouTube
//
//  Created by Martijn van Gogh on 18-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

class TrendingCell: FeedCell {

    override func fetchData() {
        ApiReference.sharedInstance.fetchTrending { (videos) in
            self.videos = videos
            self.collectionView.reloadData()
        }
    }

}
