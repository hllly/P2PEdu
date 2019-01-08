//
//  EduBaseNavigationController.swift
//  Antidote
//
//  Created by hllly on 2019/1/7.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

class EduBaseNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
        self.navigationBar.isTranslucent = false
        self.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationBar.titleTextAttributes =
            [NSAttributedStringKey.foregroundColor: UIColor(red: 0x55/255, green: 0x55/255, blue: 0x55/255, alpha:1),
             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20)]
    }
}

extension EduBaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.childViewControllers.count == 1 {
            return false
        }
        return true
    }
}
