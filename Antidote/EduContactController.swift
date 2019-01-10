//
//  EduContactController.swift
//  Antidote
//
//  Created by hllly on 2019/1/7.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

class EduContactController: EduBaseController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = nil;
        self.view.backgroundColor = UIColor.white
        let controller = ChatListController(theme: self.theme, submanagerChats: self.toxManager.chats, submanagerObjects: self.toxManager.objects, submanagerFiles: self.toxManager.files, activeSessionCoordinatorDelegate: self.activeSessionCoordinatorDelegate)
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
    override func viewWillLayoutSubviews() {
//        var frame = self.view.frame;
//        frame.size.height = 800;
//        frame.origin.y = self.view.frame.size.height - 80;
//        self.view.frame = frame;
    }
}
