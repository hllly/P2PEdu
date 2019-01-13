//
//  CanvasController.swift
//  Antidote
//
//  Created by hllly on 2019/1/10.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

class CanvasController: UIViewController {
    fileprivate var canvasBoard: CanvasBoard!
    fileprivate var backImg: UIImage!
    fileprivate var chats: OCTSubmanagerChats!
    fileprivate var chat: OCTChat!
    
    init(chat: OCTChat, chats: OCTSubmanagerChats){
        super.init(nibName: nil, bundle: nil)
        self.chat = chat
        self.chats = chats
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        self.canvasBoard = CanvasBoard(frame:self.view.frame, backImg: UIImage(named: "paper")!, chat: chat, chats: chats)
        self.view.addSubview(canvasBoard)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let fs = FSTool()
        if fs.exist(path: "/Documents/paper.png") {
            backImg = UIImage(data: fs.read(path: "/paper.png"))
        }else {
            backImg = UIImage(named: "paper")
        }
        canvasBoard.getBackImg(backImg: self.backImg)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveCanvas()
    }
    
    //保持画板
    func saveCanvas() {
        UIGraphicsBeginImageContext(self.canvasBoard.frame.size) //开始截取画图板
        self.canvasBoard.layer.render(in: UIGraphicsGetCurrentContext()!)
        let img : UIImage = UIGraphicsGetImageFromCurrentImageContext()! //截取到的图像
        UIGraphicsEndImageContext() //结束截取
        saveToDocuments(currentImage: img, persent: 99999999999, imageName: "paper.png")
    }
    
    //保存到沙盒
    private func saveToDocuments(currentImage: UIImage, persent: CGFloat, imageName: String){
        if let imageData = UIImageJPEGRepresentation(currentImage, persent) as NSData? {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending(imageName)
            imageData.write(toFile: fullPath, atomically: true)
        }
    }
}
