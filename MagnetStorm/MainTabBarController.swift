//
//  MainTabBarController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 10.01.2024.
//

//import Foundation
//import UIKit
//
//final class MainTabBarController: UITabBarController {
//    //MARK: Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        generateTabBar()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//         super.viewWillAppear(animated)
//     }
//    
//    //MARK: Create TabBar
//    private func generateTabBar() {
//        
//        viewControllers = [
//            generateVC(
//                viewController: StormViewController(),
//                title: "Storm",
//                image: UIImage(systemName: "sun.max.trianglebadge.exclamationmark")),
//            generateVC(
//                viewController: AuroraViewController(),
//                title: "Aurora",
//                image: UIImage(systemName: "wind")),
//        ]
//    }
//    // Generate View Controllers
//    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
//        viewController.tabBarItem.title = title
//        viewController.tabBarItem.image = image
//        return viewController
//    }
//}
