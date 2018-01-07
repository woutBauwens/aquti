//
//  PageViewController.swift
//  aquti
//
//  Created by Wout Bauwens on 23/12/2017.
//  Copyright © 2017 Wout Bauwens. All rights reserved.
//

import Foundation
import UIKit

// Used tutorial, forgot to add source, did not find source later
class PageViewController: UIPageViewController {
    
    var waterType = String()
    var image: UIImage!
    var secondsToSunset: Int!
    private var time = Timer()
    private var seconds = 10
    private var detailList: [[String]] {
        if(waterType == "Whitewater") {
            return [["Zonsondergang","Vaartijd", "Afstand", "Gem. Snelheid", "Afdaling"], [seconds.description, 0.description, 0.description]]
        } else {
            return [["Zonsondergang","Vaartijd","Afstand", "Gem. Snelheid", "Huidige snelheid"], [seconds.description, 0.description, 0.description]]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
        }
    }
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newAqutiViewController(id: 0), self.newAqutiViewController(id: 1)]
    }()
    
    private func newAqutiViewController(id: Int) -> UIViewController {
        switch id {
        case 0:
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            controller.detailList = detailList
            controller.image = image
            controller.secondsToSunset = secondsToSunset
            return controller
        case 1:
            return UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "MapViewController")
        default:
            return UIStoryboard(name: "Main", bundle: nil) .
                instantiateViewController(withIdentifier: "DetailViewController")
        }
    }
}

extension PageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = orderedViewControllers.count
        
        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return orderedViewControllers[nextIndex]
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return orderedViewControllers.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = orderedViewControllers.index(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}
