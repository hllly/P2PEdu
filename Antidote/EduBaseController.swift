//
//  EduBaseController.swift
//  Antidote
//
//  Created by hllly on 2019/1/7.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

class EduBaseController: UIViewController {
    var toxManager: OCTManager!
    var theme: Theme!
    var activeSessionCoordinatorDelegate: ChatPrivateControllerDelegate!
    
    func getOptions(toxManager: OCTManager, theme: Theme, activeSessionCoordinatorDelegate: ChatPrivateControllerDelegate){
        self.toxManager = toxManager
        self.theme = theme
        self.activeSessionCoordinatorDelegate = activeSessionCoordinatorDelegate
   
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        let leftBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        leftBtn.setImage(UIImage(named:"backIcon"), for: UIControlState.normal)
        leftBtn.addTarget(self, action: #selector(doBackAction(btn:)), for: UIControlEvents.touchUpInside)
    }
    
    @objc func doBackAction(btn: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
