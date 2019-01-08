//
//  EduMainTabbarItem.swift
//  Antidote
//
//  Created by hllly on 2019/1/7.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

class EduMainTabbarItem: UIControl {
    var itemDic:Dictionary<String, String>
    let imgView: UIImageView
    let titleLabel: UILabel
    
    //属性观察器
    var currentSelectState = false {
        didSet{
            if currentSelectState {
                //被选中
                imgView.image = UIImage(named:itemDic["SelectedImg"]!)
                titleLabel.textColor = UIColor(red: 0xfe/255, green: 0xdc/255, blue: 0x00/255, alpha: 1)
            }else{
                //没被选中
                imgView.image = UIImage(named: itemDic["NormalImg"]!)
                titleLabel.textColor = UIColor(red: 0x55/255, green: 0x55/255, blue: 0x55/255, alpha: 1)
            }
        }
    }
    
    init(frame:CGRect, itemDic:Dictionary<String, String>, itemIndex:Int) {
        self.itemDic = itemDic
        
        //布局使用的参数
        let defaulutLabelH:CGFloat = 20.0 //文字的高度
        let imgTop:CGFloat = -10
        let imgWidth:CGFloat = 50
        let imgLeft:CGFloat = (frame.size.width - imgWidth)/2
        let imgHeight:CGFloat  = frame.size.height - defaulutLabelH - imgTop
        //图片
        imgView = UIImageView(frame: CGRect(x: imgLeft, y: imgTop, width:imgWidth, height:imgHeight))
        imgView.image = UIImage(named: itemDic["NormalImg"]!)
        imgView.contentMode = UIViewContentMode.scaleAspectFit
        //title
        titleLabel = UILabel(frame:CGRect(x: 0, y: frame.height - defaulutLabelH, width: frame.size.width, height: defaulutLabelH))
        titleLabel.text = itemDic["Title"]!
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.textColor = UIColor.lightGray
        
        super.init(frame: frame)
        self.addSubview(imgView)
        self.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
