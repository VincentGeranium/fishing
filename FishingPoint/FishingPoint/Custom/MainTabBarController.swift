//
//  MainTabBarController.swift
//  FishingPoint
//
//  Created by Fury on 24/05/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    // 탭바에 올릴 뷰컨트롤러 생성
    let homeVC = MainViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭바 이미지 설정해주기
        homeVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(named: AppImageData.homeNomal), selectedImage: UIImage(named: AppImageData.homeSelected))
        
        tabBar.backgroundColor = UIColor(red: 0.36, green: 0.57, blue: 0.78, alpha: 1)
        
        // homeVC에 네비게이션 적용시키기
        self.viewControllers = [UINavigationController(rootViewController: homeVC)]
    }
}
