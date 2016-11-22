//
//  ApiReference.swift
//  YouTube
//
//  Created by Martijn van Gogh on 17-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

class ApiReference: NSObject {
//Dit is een manier om meerdere datasets binnen te halen zodat je die kunt toekennen aan verschillende cellen in de eigen cell-classes (TrendingCell, Subsscriptioncell, Accountcell. Die cellen zijn eigenlijk een Feedcellclass, maar dan met een fetchData-func op basis van een andere url. In deze APIReference class maken we dus verschillende funcs voor iedere verschillende url. Deze roep je aan in de verschillende cell-classes door fetchData te overriden. In homecontroller switch je vervolgens tussen de cellen op basis van hun cellId die steeds een andere identifier heeft onder cellForItemAtIndexpath.
    static let sharedInstance = ApiReference()
    
    func fetchVideos(completion: @escaping ([Video]) ->()) {
        fetcghFeedUrlForString(url: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json", completion: completion)
        
    }
    
    func fetchTrending(completion: @escaping ([Video]) ->()) {
        fetcghFeedUrlForString(url: "https://s3-us-west-2.amazonaws.com/youtubeassets/trending.json", completion: completion)
    }
    
    func fetchSubscription(completion: @escaping ([Video]) ->()) {
        fetcghFeedUrlForString(url: "https://s3-us-west-2.amazonaws.com/youtubeassets/subscriptions.json", completion: completion)
    }
    
    func fetchAccount(completion: @escaping ([Video]) ->()) {
        fetcghFeedUrlForString(url: "https://s3-us-west-2.amazonaws.com/youtubeassets/account.json", completion: completion)        
    }
    
    func fetcghFeedUrlForString(url: String, completion: @escaping ([Video]) ->()) {
        let url = url
        guard let requestUrl = URL(string:url) else { return }
        let request = URLRequest(url:requestUrl)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error)
                return
            }
            do {
                
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                var videos = [Video]()
                for dict in json as! [[String: AnyObject]] {
                    let video = Video()
                    video.title = (dict["title"] as? String?)!
                    video.thumbNailImage = dict["thumbnail_image_name"] as? String
                    video.numberOfViews = dict["number_of_views"] as? NSNumber
                    
                    
                    let channelDict = dict["channel"]  as! [String: AnyObject]
                    let channel = Channel()
                    channel.name = channelDict["name"] as? String
                    channel.profileImage = channelDict["profile_image_name"] as? String
                    video.channel = channel
                    
                    
                    videos.append(video)
                    
                }
                DispatchQueue.main.async {
                    completion(videos)
                }
                
                
            } catch let jsonError {
                print(jsonError)
            }
            }.resume()
    }
}

