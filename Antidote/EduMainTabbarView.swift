//
//  EduMainTabbarView.swift
//  Antidote
//
//  Created by hllly on 2019/1/7.
//  Copyright © 2019年 dvor. All rights reserved.
//

import UIKit

protocol EduMainTabbarDelegate {
    func didChooseItem(itemIndex: Int)
}

class EduMainTabbarView: UIView {
    var delegate:EduMainTabbarDelegate? //代理,点击item
    var itemArray:[EduMainTabbarItem] = [] //标签Item数组
    
    init(frame: CGRect,tabbarConfigArr:[Dictionary<String,String>]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        let screenW = UIScreen.main.bounds.size.width
        let itemWidth = screenW / CGFloat(tabbarConfigArr.count)
        for i in 0..<tabbarConfigArr.count{
            let itemDic = tabbarConfigArr[i];
            let itemFrame = CGRect(x: itemWidth * CGFloat(i) , y: 0, width: itemWidth, height: frame.size.height)
            //创建Item视图
            let itemView = EduMainTabbarItem(frame: itemFrame, itemDic:itemDic, itemIndex: i)
            self.addSubview(itemView)
            self.itemArray.append(itemView)
            //添加事件点击处理
            itemView.tag = i
            itemView.addTarget(self, action:#selector(self.didItemClick(item:))  , for: UIControlEvents.touchUpInside)
            
            //默认点击第一个,即首页
            if i == 0 {
                self .didItemClick(item: itemView)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //点击单个标签视图，通过currentSelectState的属性观察器更新标签的显示
    //并且通过代理方法切换标签控制器的当前视图控制器
    @objc func didItemClick(item:EduMainTabbarItem){
        for i in 0..<itemArray.count{
            let tempItem = itemArray[i]
            if i == item.tag{
                tempItem.currentSelectState = true
            }else{
                tempItem.currentSelectState = false
            }
        }
        //执行代理方法
        self.delegate?.didChooseItem(itemIndex: item.tag)
    }
}
