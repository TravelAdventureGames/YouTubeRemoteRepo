//
//  ViewController.swift
//  YouTube
//
//  Created by Martijn van Gogh on 09-11-16.
//  Copyright © 2016 Martijn van Gogh. All rights reserved.
//

import UIKit
//1. We werken zonder storyboards. Je definieert dus in appdelegate deze viewcontroller, die een subclass is van collectionViewController. Je moet wel de cellclass registreren en 2 methods implementeren. cmd build en je ziet 5 kleine celletjes.
//2.Resize de cellen. Gebruik de resizeForItem-method en creeer de grootte van de cell. Maak ook de backgroundcolor van de cell red ipv de default white
//3. Creeer een class voor de collectionviewcell, genaamd videoCell. je geeft deze het frame van zijn superclass en de reuired init. Verder ga je in deze class de verdere layout van je cell maken.
//4. Eerst maak je een imageView als computed property. Je gaat zelf de constraints in code definieren. Let op: dit luistert heel precies!! In de computed property. Vergeet niet deze imageView als subview toe te voegen.!!
//5. Idem voor seperatorView. Dit is een 1-pixel lijn tussen de collectioncells in. Horizontaal zet je m over de volle breedte, vertikaal alleen tegen de onderkant met 1 pixel groot.
//6. Alle constraints zetten we in code. For the sake of clean code maken we daar een func voor, addConstraintsWithFormat. Je kunt deze gebruiken in combinatie met de swift standaar constraints functie zoals je ziet bij het titlelabel waarin we zowel de eigen als de standaard swift func door elkaar gebruiken. Over de constraintcode: H:[v0] -> dit is de eerste view, horizontale contsraints, H:[v0(44)]-> dit is een view meteen width van 44,
//7. Uitgebreid voorbeeld: "V:|-16-[v0]-[v1(44)]-16-[v2(1)]| betekent: er zijn 3 views. View 0 is 16 pixels van de top van de cell en aan de andere kant tegen view1 die een height heeft van 44 pixels. Deze heeft op zijn beurt een afstand van 16 pixels naar view3 (de seperatorview) die 1 pixel hoog is.
//8. Om goed te alignen gebruiken we de textView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0). Dit zorgt ervoor dat de text iets minder inspringt.
//9 De hoogte van de cell is berekent door uit te gaan van het filmformaat 9/16. We moeten hier nog wel de hoogte van de userProfileImage en de whitespace hoogte aan toevoegen.
//10. Maak een view genaamd titleLabel voor de Home aan en zet deze als titleView op het navigationitem van de navbar.
//11. In de MenuBar class maken we een collectionview aan. De constraints en de addsubview in de ovveride init, alle settings in een computed property
//12. we maken een instance van van Settingslauncher zodat we de funcs uit die class kunnen aanroepen. Echter, we maken hier een lazy var van omdat we willen dat de code erin niet iedere keer wordt aangeroepen. In dit geval zetten we de homecontroller-instance in de SettingLauncher-class op 'self' (de Homecontroller VC). Dit is nodig omdat deze anders de homecontroller-instance in de SettingLauncher-class iedere keer wordt gezet en dat is niet nodig!
//#13 Deze line zorgt ervoor dat de topanchor van de menubar alines to de bottomanchor van de tops maximale y-waarde. Dit heb je nodig in combi met de navigationController.HidesOnSwipe = true
//#14 Er ontstaat nu wel een gap, dus we maken een view om het geheel te bedekken met dezelfde kleur.




class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {


   
    var cellId = "celIId"
    var trendingCellId = "trendingId"
    var subscriptionCellId = "subscriptionCellId"
    var accounCellId = "var accounCellId"
    let titles = ["  Home","  Trending","  Subscriptions","  Account"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        navigationController?.navigationBar.isTranslucent = false
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "  Home"
        navigationItem.titleView = titleLabel
        setUpMenuBar()
        setUpCollectionView()
        setUpNavBarButtons()

        
        
    }
    
    
    func setUpCollectionView() {
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        collectionView?.isPagingEnabled = true
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(SubscriptionCell.self, forCellWithReuseIdentifier: subscriptionCellId)
        collectionView?.register(TrendingCell.self, forCellWithReuseIdentifier: trendingCellId)
        collectionView?.register(AccountCell.self, forCellWithReuseIdentifier: accounCellId)
    
        collectionView?.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsetsMake(50, 0, 0, 0)
    }
    
    func setUpNavBarButtons() {

        let barButton = createBarButtonItems(imgName: "search")
        barButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: barButton)
        let moreButton = createBarButtonItems(imgName: "dots")
        moreButton.addTarget(self, action: #selector(handleMore), for: .touchUpInside)
        let moreItem = UIBarButtonItem(customView: moreButton)
        navigationItem.rightBarButtonItems = [moreItem, searchItem]
        
    }
    
    func handleSearch() {
        print("123")
    }
    //#12
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore() {
        settingsLauncher.handleShow()
   
    }
    
    func showControllerForSetting(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.navigationItem.title = setting.name.rawValue
        dummySettingsViewController.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
    func createBarButtonItems(imgName: String) -> UIButton {
        let searchButton: UIButton = UIButton(type: .custom)
        let img = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        searchButton.setImage(img, for: UIControlState.normal)
        searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        searchButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        return searchButton
    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setUpMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        //#14
        let redView = UIView()
        redView.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        //#13
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier: String
        if indexPath.item == 1 {
            identifier = trendingCellId
        } else if indexPath.item == 2 {
            identifier = subscriptionCellId
        } else {
            identifier = cellId
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalLeftAnchor?.constant = scrollView.contentOffset.x / 4
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        setTitleLabelForIndex(index: menuIndex)
    }
    
    func setTitleLabelForIndex(index: Int) {
        if let titLabel = navigationItem.titleView as? UILabel {
            titLabel.text = titles[Int(index)]
        }
    }
    
    
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = Int(targetContentOffset.pointee.x / view.frame.width)
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        setTitleLabelForIndex(index: index)
        
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition: [])
        
    }
    
}


