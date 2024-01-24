//
//  ViewController.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 08/09/23.
//

import UIKit

class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController:  UpcommingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UIImagePickerController(rootViewController: DownloadsViewController())
//        let vc5 = UINavigationController(rootViewController: resultvcViewController())
        vc1.tabBarItem.image = UIImage(systemName:"house" )
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
//        vc5.tabBarItem.image = UIImage(systemName: "pencil")
        
        
        vc1.title = "Home"
        vc2.title = "Coming Soon"
        vc3.title = "Top Search"
        vc4.title = "Downloads"
//        vc5.title = "nothing"
        
        tabBar.tintColor = .label
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        // Do any additional setup after loading the view.
    }


}

