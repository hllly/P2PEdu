//
//  CanvasBoard.swift
//  Antidote
//
//  Created by hllly on 2019/1/11.
//  Copyright © 2019年 dvor. All rights reserved.
//


import UIKit

let size = UIScreen.main.bounds.size
let use3DTouch = true;


class CanvasBoard: UIImageView {
    var chat: OCTChat!
    var chats: OCTSubmanagerChats!
    
    // 存放点集的数组
    var points:[CGPoint] = [CGPoint]()
    var pointForces:[CGFloat] = [CGFloat]()
    
    //网络传输的数组
    var networkPoints: [(points:[CGPoint], forces:[CGFloat])]!
    
    // 当前半径
    var currentWidth:CGFloat = 2
    // 初始图片
    var defaultImage:UIImage?
    // 上次图片
    var lastImage:UIImage?
    // 最大和最小宽度
    let minWidth:CGFloat = 2
    let maxWidth:CGFloat = 3
    // 设置调试
    let DEBUG = false

    //背景图片
    var backImg: UIImage!

    init(frame: CGRect, backImg: UIImage, chat: OCTChat, chats: OCTSubmanagerChats) {
        // 控件基本设定
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        // 清除按钮设定12
        let btn = UIButton(frame: CGRect(x: 0, y: self.frame.size.height-50, width: self.frame.size.width, height: 50))
        btn.backgroundColor = UIColor(white: 0.3, alpha: 0.3)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.titleLabel!.font = UIFont(name: "Zapfino", size: 18)
        btn.titleEdgeInsets = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        btn.setTitle("Clear ", for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        addSubview(btn)
        defaultImage = backImg
        lastImage = backImg
        
        self.chat = chat
        self.chats = chats
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getBackImg(backImg: UIImage){
        // 默认图片设定
        defaultImage = backImg
        lastImage = backImg
    }


    /**
     图片恢复初始化
     */
    @objc func btnClick() {
        image = defaultImage
        lastImage = defaultImage
        currentWidth = 2
    }

    /**
     触控事件画图实现
     */
    func changeImage(){
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        lastImage!.draw(in: self.bounds)
        // 贝赛尔曲线的起始点和末尾点
        let tempPoint1 = CGPoint(x:(points[0].x+points[1].x)/2, y:(points[0].y+points[1].y)/2)
        let tempPoint2 = CGPoint(x:(points[1].x+points[2].x)/2, y:(points[1].y+points[2].y)/2)
        // 贝赛尔曲线的估算长度
        let x1 = abs(tempPoint1.x-tempPoint2.x)
        let x2 = abs(tempPoint1.y-tempPoint2.y)
        let len = Int(sqrt(pow(x1, 2) + pow(x2,2))*10)
        // 如果仅仅点击一下
        // 传输一个点，并直接绘图
        if len == 0 {
            let zeroPath = UIBezierPath(arcCenter: points[1], radius: maxWidth/2-2, startAngle: 0, endAngle: CGFloat(Double.pi)*2.0, clockwise: true)
            UIColor.black.setFill()
            zeroPath.fill()
            // 绘图
            image = UIGraphicsGetImageFromCurrentImageContext()
            lastImage = image
            UIGraphicsEndImageContext()
            return
        }
        // 如果距离过短，直接画线
        // 传输起始点和结束点两个点并绘图
        if len < 1 {
            let zeroPath = UIBezierPath()
            zeroPath.move(to: tempPoint1)
            zeroPath.addLine(to: tempPoint2)
            currentWidth += 0.05
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth = minWidth}
            // 画线
            zeroPath.lineWidth = currentWidth
            zeroPath.lineCapStyle = .round
            zeroPath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.6+0.2).setStroke()
            UIColor.darkGray.setStroke()
            zeroPath.stroke()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        // 目标半径
        var aimWidth:CGFloat;
        if use3DTouch {
            aimWidth = pointForces[0]*(maxWidth-minWidth)
        }else{
            aimWidth = CGFloat(300)/CGFloat(len)*(maxWidth-minWidth)
        }
        // 获取贝塞尔点集
        // 该点集用于绘制多条线
        let curvePoints = AFBezierPath.curveFactorization(fromPoint: tempPoint1, toPoint: tempPoint2, controlPoints: [points[1]], count: len)
        // 画每条线段
        var lastPoint:CGPoint = tempPoint1
        for i in 0..<len+1 {
            let bPath = UIBezierPath()
            bPath.move(to: lastPoint)
            // 省略多余的点
            let delta = sqrt(pow(curvePoints[i].x-lastPoint.x, 2) + pow(curvePoints[i].y-lastPoint.y, 2))
            if delta < 1 {continue}
            lastPoint = CGPoint(x: curvePoints[i].x, y: curvePoints[i].y)
            bPath.addLine(to: CGPoint(x: curvePoints[i].x, y: curvePoints[i].y))
            // 计算当前点
            if currentWidth > aimWidth {
                currentWidth -= 0.05
            }else{
                currentWidth += 0.05
            }
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth=minWidth}
            // 画线
            bPath.lineWidth = currentWidth
            bPath.lineCapStyle = .round
            bPath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.3+0.1).setStroke()
            UIColor.darkGray.setStroke()
            bPath.stroke()
        }
        // 保存图片
        lastImage = UIGraphicsGetImageFromCurrentImageContext()
        let pointCount = Int(sqrt(pow(tempPoint2.x-points[2].x,2)+pow(tempPoint2.y-points[2].y,2)))*2
        let delX = (tempPoint2.x-points[2].x)/CGFloat(pointCount)
        let delY = (tempPoint2.y-points[2].y)/CGFloat(pointCount)
        var addRadius = currentWidth
        // 尾部线段
        for _ in 0..<pointCount {
            let bpath = UIBezierPath()
            bpath.move(to: lastPoint)
            let newPoint = CGPoint(x: lastPoint.x-delX, y: lastPoint.y-delY)
            lastPoint = newPoint
            bpath.addLine(to: newPoint)
            // 计算当前点
            if addRadius > aimWidth {
                addRadius -= 0.02
            }else{
                addRadius += 0.02
            }
            if addRadius > maxWidth {addRadius = maxWidth}
            if addRadius < 0 {addRadius=0}
            // 画线
            bpath.lineWidth = addRadius
            bpath.lineCapStyle = .round
            bpath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.05+0.05).setStroke()
            UIColor.darkGray.setStroke()
            bpath.stroke()
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    /**
     网络事件出发绘图
    */
    func changeImageFromNetwork(networkPointsAndForces:(points:[CGPoint], forces:[CGFloat])){
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        lastImage!.draw(in: self.bounds)
        let netPoints = networkPointsAndForces.points
        let netForces = networkPointsAndForces.forces
        // 贝赛尔曲线的起始点和末尾点
        let tempPoint1 = CGPoint(x:(netPoints[0].x+netPoints[1].x)/2, y:(netPoints[0].y+netPoints[1].y)/2)
        let tempPoint2 = CGPoint(x:(netPoints[1].x+netPoints[2].x)/2, y:(netPoints[1].y+netPoints[2].y)/2)
        // 贝赛尔曲线的估算长度
        let x1 = abs(tempPoint1.x-tempPoint2.x)
        let x2 = abs(tempPoint1.y-tempPoint2.y)
        let len = Int(sqrt(pow(x1, 2) + pow(x2,2))*10)
        // 如果仅仅点击一下
        // 传输一个点，并直接绘图
        if len == 0 {
            let zeroPath = UIBezierPath(arcCenter: netPoints[1], radius: maxWidth/2-2, startAngle: 0, endAngle: CGFloat(Double.pi)*2.0, clockwise: true)
            UIColor.black.setFill()
            zeroPath.fill()
            // 绘图
            image = UIGraphicsGetImageFromCurrentImageContext()
            lastImage = image
            UIGraphicsEndImageContext()
            return
        }
        // 如果距离过短，直接画线
        // 传输起始点和结束点两个点并绘图
        if len < 1 {
            let zeroPath = UIBezierPath()
            zeroPath.move(to: tempPoint1)
            zeroPath.addLine(to: tempPoint2)
            currentWidth += 0.05
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth = minWidth}
            // 画线
            zeroPath.lineWidth = currentWidth
            zeroPath.lineCapStyle = .round
            zeroPath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.6+0.2).setStroke()
            UIColor.darkGray.setStroke()
            zeroPath.stroke()
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return
        }
        // 目标半径
        var aimWidth:CGFloat;
        if use3DTouch {
            aimWidth = netForces[0]*(maxWidth-minWidth)
        }else{
            aimWidth = CGFloat(300)/CGFloat(len)*(maxWidth-minWidth)
        }
        // 获取贝塞尔点集
        // 该点集用于绘制多条线
        let curvePoints = AFBezierPath.curveFactorization(fromPoint: tempPoint1, toPoint: tempPoint2, controlPoints: [netPoints[1]], count: len)
        // 画每条线段
        var lastPoint:CGPoint = tempPoint1
        for i in 0..<len+1 {
            let bPath = UIBezierPath()
            bPath.move(to: lastPoint)
            // 省略多余的点
            let delta = sqrt(pow(curvePoints[i].x-lastPoint.x, 2) + pow(curvePoints[i].y-lastPoint.y, 2))
            if delta < 1 {continue}
            lastPoint = CGPoint(x: curvePoints[i].x, y: curvePoints[i].y)
            bPath.addLine(to: CGPoint(x: curvePoints[i].x, y: curvePoints[i].y))
            // 计算当前点
            if currentWidth > aimWidth {
                currentWidth -= 0.05
            }else{
                currentWidth += 0.05
            }
            if currentWidth > maxWidth {currentWidth = maxWidth}
            if currentWidth < minWidth {currentWidth=minWidth}
            // 画线
            bPath.lineWidth = currentWidth
            bPath.lineCapStyle = .round
            bPath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.3+0.1).setStroke()
            UIColor.darkGray.setStroke()
            bPath.stroke()
        }
        // 保存图片
        lastImage = UIGraphicsGetImageFromCurrentImageContext()
        let pointCount = Int(sqrt(pow(tempPoint2.x-netPoints[2].x,2)+pow(tempPoint2.y-netPoints[2].y,2)))*2
        let delX = (tempPoint2.x-netPoints[2].x)/CGFloat(pointCount)
        let delY = (tempPoint2.y-netPoints[2].y)/CGFloat(pointCount)
        var addRadius = currentWidth
        // 尾部线段
        for _ in 0..<pointCount {
            let bpath = UIBezierPath()
            bpath.move(to: lastPoint)
            let newPoint = CGPoint(x: lastPoint.x-delX, y: lastPoint.y-delY)
            lastPoint = newPoint
            bpath.addLine(to: newPoint)
            // 计算当前点
            if addRadius > aimWidth {
                addRadius -= 0.02
            }else{
                addRadius += 0.02
            }
            if addRadius > maxWidth {addRadius = maxWidth}
            if addRadius < 0 {addRadius=0}
            // 画线
            bpath.lineWidth = addRadius
            bpath.lineCapStyle = .round
            bpath.lineJoinStyle = .round
            //UIColor(white: 0, alpha: (currentWidth-minWidth)/maxWidth*0.05+0.05).setStroke()
            UIColor.darkGray.setStroke()
            bpath.stroke()
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}

// 触摸事件
extension CanvasBoard {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let p = touch!.location(in: self)
        points = [p,p,p]
        if use3DTouch {
            if #available(iOS 9.0, *) {
                pointForces = [touch!.force,touch!.force,touch!.force]
            } else {
                // Fallback on earlier versions
            };
        }
        //networkPoints.append((points:points, forces:pointForces))
        //chats.sendMessage(to: chat, text: "hello wrold1", type: .normal, successBlock: nil, failureBlock: nil)
        currentWidth = 13
        changeImage()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let p = touch!.location(in: self)
        if use3DTouch {
            if #available(iOS 9.0, *) {
                print(touch?.force)
            } else {
                // Fallback on earlier versions
            }
        }
        points = [points[1],points[2],p]
        if use3DTouch {
            if #available(iOS 9.0, *) {
                pointForces = [pointForces[1],pointForces[2],touch!.force]
            } else {
                // Fallback on earlier versions
            };
        }
        //networkPoints.append((points:points, forces:pointForces))
        //chats.sendMessage(to: chat, text: "hello wrold", type: .normal, successBlock: nil, failureBlock: nil)
        changeImage()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastImage = image
    }


}

/**
 *分解贝塞尔曲线
 */
class AFBezierPath {

    /**
     fromPoint:起始点
     toPoint:终止点
     controlPoints:控制点数组
     count:分解数量
     返回:分解的点集
     */
    class func curveFactorization(fromPoint:CGPoint, toPoint: CGPoint, controlPoints:[CGPoint], count:Int) -> [CGPoint]{
        var count = count
        //如果分解数量为0，生成默认分解数量
        if count == 0 {
            let x1 = abs(fromPoint.x-toPoint.x)
            let x2 = abs(fromPoint.y-toPoint.y)
            count = Int(sqrt(pow(x1, 2) + pow(x2,2)))
        }
        // 贝赛尔曲线的计算
        var s:CGFloat = 0.0
        var t:[CGFloat] = [CGFloat]()
        let pc:CGFloat = 1/CGFloat(count)
        let power = controlPoints.count + 1
        for _ in 0...count+1 {t.append(s);s=s+pc}
        var newPoint:[CGPoint] = [CGPoint]()
        for i in 0...count+1 {
            var resultX = fromPoint.x * bezMaker(n: power, k:0, t:t[i])
                + toPoint.x * bezMaker(n: power, k:power, t:t[i])
            for j in 1...power-1 {
                resultX += controlPoints[j-1].x * bezMaker(n: power, k:j, t:t[i])
            }
            var resultY = fromPoint.y * bezMaker(n: power, k:0, t:t[i])
                + toPoint.y * bezMaker(n: power, k:power, t:t[i])
            for j in 1...power-1 {
                resultY += controlPoints[j-1].y * bezMaker(n: power, k:j, t:t[i])
            }
            newPoint.append(CGPoint(x: resultX, y: resultY))
        }
        return newPoint
    }

    private class func comp(n:Int, k:Int) -> CGFloat{
        var s1:Int = 1
        var s2:Int = 1
        if k == 0 {return 1}
        var i = n
        while i >= n - k + 1 {
            s1 = s1*i
            i -= 1
        }
        i = k
        while i >= 2 {
            s2 = s2*i
            i -= 1
        }
        return CGFloat(s1/s2)
    }

    private class func realPow(n:CGFloat, k:Int) -> CGFloat{
        if k==0 {return 1.0}
        return pow(n, CGFloat(k))
    }

    private class func bezMaker(n:Int, k:Int, t:CGFloat) -> CGFloat{
        return comp(n: n, k: k) * realPow(n: 1-t, k: n-k) * realPow(n: t, k: k)
    }
}



