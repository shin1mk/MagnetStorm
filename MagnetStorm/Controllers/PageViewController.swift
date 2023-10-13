//
//  PageViewController.swift
//  MagnetStorm
//
//  Created by SHIN MIKHAIL on 13.10.2023.
//

import Foundation
import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var viewControllerList: [UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let stormVC = StormViewController()
        let auroraVC = AuroraViewController()

        viewControllerList = [stormVC, auroraVC]
        setViewControllers([stormVC], direction: .forward, animated: true, completion: nil)

        dataSource = self
        delegate = self
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        if previousIndex >= 0 {
            return viewControllerList[previousIndex]
        }
        return nil
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        if nextIndex < viewControllerList.count {
            return viewControllerList[nextIndex]
        }
        return nil
    }
}
