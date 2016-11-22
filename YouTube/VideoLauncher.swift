//
//  VideoLauncher.swift
//  YouTube
//
//  Created by Martijn van Gogh on 20-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let durationView: UILabel = {
       let dv = UILabel()
        dv.text = "00:00"
        dv.textColor = .white
        dv.font = UIFont.boldSystemFont(ofSize: 14)
        dv.textAlignment = .right
        dv.translatesAutoresizingMaskIntoConstraints = false
        return dv
    }()
    
    lazy var videoLengthSlider: UISlider = {
        let sl = UISlider()
        sl.minimumTrackTintColor = .red
        sl.setThumbImage(UIImage(named: "reddot-2"), for: .normal)
        sl.translatesAutoresizingMaskIntoConstraints = false
        sl.maximumTrackTintColor = .white
        sl.addTarget(self, action: #selector(handleSliderChange), for: UIControlEvents.valueChanged)
        
        return sl
    }()
    
    func handleSliderChange() {
        if let totalDuration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(totalDuration)
            let currentVideoTime = Float64(videoLengthSlider.value) * totalSeconds
            let seekTime = CMTime(value: Int64(currentVideoTime), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completedSeek) in
                //do something
            })
        }
    }
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.isHidden = true
        
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        
        return button
    }()
    
    var isPlaying = false
    
    func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named:"play"), for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(durationView)
        durationView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        durationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        durationView.widthAnchor.constraint(equalToConstant: 60)
        durationView.heightAnchor.constraint(equalToConstant: 24)
        
        controlsContainerView.addSubview(videoLengthSlider)
        videoLengthSlider.rightAnchor.constraint(equalTo: durationView.leftAnchor).isActive = true
        videoLengthSlider.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        videoLengthSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backgroundColor = .black
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        //warning: use your own video url here, the bandwidth for google firebase storage will run out as more and more people use this file
        let urlString = "https://firebasestorage.googleapis.com/v0/b/gameofchats-762ca.appspot.com/o/message_movies%2F12323439-9729-4941-BA07-2BAE970967C7.mov?alt=media&token=3e37a093-3bc8-410f-84d3-38332af9c726"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        //this is when the player is ready and rendering frames
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            isPlaying = true
            
            if let videoDuration = player?.currentItem?.duration {
                let duration = CMTimeGetSeconds(videoDuration)
                let seconds = Int(duration) % 60
                durationView.text = "00:\(seconds)"
            }  
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
        print("Showing video player animation....")
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.white
            
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            //16 x 9 is the aspect ratio of all HD videos
            let height = keyWindow.frame.width * 9 / 16
            let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
            view.addSubview(videoPlayerView)
            
            keyWindow.addSubview(view)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                view.frame = keyWindow.frame
                
                }, completion: { (completedAnimation) in
                    //maybe we'll do something here later...
                    UIApplication.shared.setStatusBarHidden(true, with: .fade)
            })
        }
    }
}
