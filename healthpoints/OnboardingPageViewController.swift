//
//  OnboardingPageViewController.swift
//  healthpoints
//
//  Created by Joseph Smith on 4/17/20.
//  Copyright © 2020 Joseph Smith. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIPageViewController, UIPageViewControllerDelegate {
    lazy var pages: [UIViewController] = {
           return [
               self.getViewController(withIdentifier: "Page1"),
               self.getViewController(withIdentifier: "Page2")
           ]
       }()
       
       fileprivate func getViewController(withIdentifier identifier: String) -> UIViewController
       {
           return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
       }
       
       
       func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            
           guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0          else { return pages.last }
            
            guard pages.count > previousIndex else { return nil        }
            
            return pages[previousIndex]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
        {
           guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
            
            let nextIndex = viewControllerIndex + 1
            
            guard nextIndex < pages.count else { return pages.first }
            
            guard pages.count > nextIndex else { return nil         }
            
            return pages[nextIndex]
        }

       override func viewDidLoad() {
           super.viewDidLoad()
           super.viewDidLoad()
           self.delegate   = self
           
           if let firstVC = pages.first
           {
               setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
           }
       }
}
