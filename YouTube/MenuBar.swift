//
//  MenuBar.swift
//  YouTube
//
//  Created by Martijn van Gogh on 10-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit

//12. We maken de menuBar in deze separate class. Uitleg onder 11. Omdat dit de topview is setten we de constraint daarvan in viewcontroller. We voegen een collectionview toe aan deze menubar. We kunnen nu wel de constraints hier zetten want er is een reference naar de containerview, de menuBar. We  implementeren de delegates en krijgen daarmee de beschikking over de collectionview methods. Vergeet de class niet te registreren
//13. We willen niet steeds de init-methods opnieuw voor iedere UIView class maken. We maken voor de collectionviewcell classes dus een BaceCell class. Daarin doen we de init stuff en definieren een lege func setUpViews(). We maken nu de videocell en MenuCell classes een subclass van basecell. De setUpViews method moet je dan wel overriden. Je hoeft dan niet meer de initcode in die classes te implementeren.
//14. We willen de images een andere kleur geven als default en wit op een higlighted state. Dit doen we met withRenderingMode en .AlwaysTemplate. Vervolgens willen we op een highlighted stage state de kleur veranderen. Dit doen we met de erg handige standaard method isHighlighted (dit detects een tap). We gebruiken ook isSelected om de kleur te handhaven! In de init kiezen we alvast een eerste geselcteerde cell met selectItem.
//#15 We willen een scroll bar die meebeweegt met de geselecteerde menubarcell. We maken hiervoor eerst een separate view aan; horizontalBarView. De nieuwe manier om hier constraints aan toe te kennen is niet met cgrect, maar met anchors. We refereren bij het setten van de anchors steeds aan de self en dat is in dit geval de collectioview als geheel. de leftAnchor is degene die steeds moet veranderen als we een nieuwe cell selecteren dus daarvan maken we een reference die we kunnen aanspreken; var horizontalLeftAnchor: NSLayoutConstraint?. We gebruiken didSelectItem... method van collectionview om de indexpath.item te krijgen. In deze method vernadere we de leftAnchor constant op basis van de geselcteerde cell. We zetten een animationWithDutation en roepen layOutIfNeeded om uit te voeren. Belangrijk is dat we horizontalBarView.translatesAutoresizingMaskIntoConstraints = false ook zetten (annoying).
class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        cv.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        
        
        return cv
    }()
    
    let id = "cellId"
    let imageArray = ["home","flame","play-3","human-2"]
    var homeController: HomeController?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: id)
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        let selectedIndexPath = NSIndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: false, scrollPosition: [])
        setUpHorizontalBar()
        
        
    }
    var horizontalLeftAnchor: NSLayoutConstraint?
    
    func setUpHorizontalBar() {
        //#15
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalLeftAnchor = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalLeftAnchor?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.25).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        homeController?.scrollToMenuIndex(menuIndex: indexPath.item)
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! MenuCell
        cell.imageView.image = UIImage(named: imageArray[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        cell.tintColor = UIColor.rgb(red: 91, green: 13, blue: 14, alpha: 1.0)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuCell: BaceCell{
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        iv.tintColor = UIColor.rgb(red: 91, green: 13, blue: 14, alpha: 1.0)
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    override var isHighlighted: Bool {
        didSet {
            
            imageView.tintColor = isHighlighted ? UIColor.white : UIColor.rgb(red: 91, green: 13, blue: 14, alpha: 1.0)
            
        }
    }
    override var isSelected: Bool {
        didSet {
            
            imageView.tintColor = isSelected ? UIColor.white : UIColor.rgb(red: 91, green: 13, blue: 14, alpha: 1.0)
            
        }
    }
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(imageView)
        addConstraintsWithFormat(format: "H:[v0(20)]", views: imageView)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: imageView)
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
}
