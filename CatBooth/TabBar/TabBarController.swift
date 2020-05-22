//
//  TabBarController.swift
//  CatBooth
//
//  Created by cr3w on 21.05.2020.
//  Copyright © 2020 Dmitriy Holovnia. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let firstVC = UINavigationController(rootViewController: GalleryViewController())
        firstVC.tabBarItem = UITabBarItem(title: "Gallery", image: nil, tag: 0)
        
        let secondVC = UINavigationController(rootViewController: BreedListController())
        secondVC.tabBarItem = UITabBarItem(title: "Breeds", image: nil, tag: 1)
        
        let thirdVC = QuizViewController()
        thirdVC.tabBarItem = UITabBarItem(title: "Quiz", image: nil, tag: 2)
//
        let dvc = FavoritesViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let fourthVC = UINavigationController(rootViewController: dvc)
        fourthVC.tabBarItem = UITabBarItem(title: "Favorites", image: nil, tag: 2)
        
        viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        selectedIndex = 1
    }


}
