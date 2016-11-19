//
//  SettingsLauncher.swift
//  YouTube
//
//  Created by Martijn van Gogh on 15-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
//#13. In de SettingsLauncher roep je on completion de func showControllerForSetting aan uit HomeController. deze func heeft een parameter van type Setting (de modelclass) zodat je name, etc kunt doorpassen naar de Homecontroller. In HomeController gebruik je name om de navbar title te zetten.

class Setting: NSObject {
    let name: SettingName
    let imageName: String
    
    init(name: SettingName, imageName: String) {
        self.name = name
        self.imageName = imageName
    }
}

enum SettingName: String {
    case Settings = "Settings", Privacy = "Terms & privacy policy", Feedback = "Send feedback", Help = "Help", SwitchAccount = "Switch account", Cancel = "Cancel", None = ""
    
}

class SettingsLauncher: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let backgroundView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    
    func handleShow() {
        if let window = UIApplication.shared.keyWindow {
            let heigth: CGFloat = CGFloat(settings.count) * cellHeight
            backgroundView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            backgroundView.frame = window.frame
            backgroundView.alpha = 0
            backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            window.addSubview(backgroundView)
            window.addSubview(collectionView)
            
            let y = window.frame.height - heigth
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: heigth)
            
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.backgroundView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: heigth)
                }, completion: nil)

        }
    }
    func handleDismiss(setting: Setting) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.backgroundView.alpha = 0.0
            let heigth: CGFloat = CGFloat(self.settings.count) * self.cellHeight
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: heigth)
            }
            
        }) { (completed: Bool) in
            //#13
            
            if setting.name != .Cancel || setting.name != nil {
                self.homeController?.showControllerForSetting(setting: setting)
            }
            
        }
    }
    
    let cellId = "cellId"
    let cellHeight: CGFloat = 50
    var homeController: HomeController?

    
    let settings: [Setting] = {
        return [Setting(name: SettingName.Settings, imageName: "gear"),
                Setting(name: SettingName.Privacy, imageName: "privacy"),
                Setting(name: SettingName.Feedback, imageName: "suitcaseExclamation"),
                Setting(name: SettingName.Help, imageName: "question"),
                Setting(name: SettingName.SwitchAccount, imageName: "account"),
                Setting(name: SettingName.Cancel, imageName: "cancel")]
    }()
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.width, height: cellHeight)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
        
    }
    override init() {
        super.init()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
}
