//
//  Extensions.swift
//  YouTube
//
//  Created by Martijn van Gogh on 10-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key  = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
            
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        
    }
    
}

extension UIColor {
    static func rgb(red: CGFloat, green:CGFloat, blue: CGFloat, alpha: CGFloat ) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1 )
    }
}
var imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    var imgUrlString: String?
    func loadImgFromUrl(imgUrl: String) {
        imgUrlString = imgUrl
        guard let requestUrl = URL(string:imgUrl) else { return }
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: imgUrl as AnyObject)  {
        self.image = imageFromCache as! UIImage
        return
        }
        
        let request = URLRequest(url:requestUrl)
        URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                if self.imgUrlString == imgUrl {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: requestUrl as AnyObject)
                
            }
            
        }).resume()
    }
}
