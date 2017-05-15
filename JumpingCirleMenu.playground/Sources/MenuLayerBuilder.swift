import Foundation
import UIKit

extension MenuButtonLayer {

    // MARK: LayersBuilder
    class LayerBuilder {
        
        private let frame:CGRect
        private let bottomRightPoint:CGPoint
        private let center:CGPoint
        
        init(frame: CGRect) {
            self.frame = frame
            
            self.bottomRightPoint = CGPoint(x:  frame.maxX,
                                            y:  frame.maxY)
            
            self.center = CGPoint( x: frame.width / 2,
                                   y: frame.height / 2) 
        }
        
        func buildImagesIconLayers(size: CGSize, imgs: [UIImage], imgColor: UIColor, positionRadius: CGFloat) -> [CALayer] {
            
            let centerPositionRadius = positionRadius + size.width/2
            let calcPosition = { (angle:Int) -> CGPoint in
                let y = sin(angle.degreesToRadians) * Double(centerPositionRadius)
                let x = cos(angle.degreesToRadians) * Double(centerPositionRadius)
                return CGPoint(x: self.frame.maxX - CGFloat(x),
                               y: self.frame.maxY - CGFloat(y))
            }
            let angleStep = 90 / (imgs.count*2)
            
            
            let getAngleForItem = { (itemNum: Int) -> Int in
                
                return  2*itemNum * angleStep -  angleStep 
            }
            
            
            var itemIterator = 1
            let layers = imgs.map { img -> CALayer in
                let imgLayer = CALayer()
                imgLayer.contents = img.imageWithColor(color: imgColor)?.cgImage
                imgLayer.contentsGravity = kCAGravityCenter
                imgLayer.bounds =  CGRect(x: 0, y: 0, width: size.width, height: size.height)
                imgLayer.position = calcPosition(getAngleForItem(itemIterator)) 
                itemIterator += 1
                print(img.size)
                return imgLayer
            }
  
            return layers
        }
         
        
        func buildSegment1Layer(radius: CGFloat, layerColor: UIColor) -> CAShapeLayer {
            
            let layerFrame = CGRect(x: 0,
                                    y: 0,
                                    width: radius,
                                    height: radius)
            
            let mask = CAShapeLayer()
            mask.fillColor = UIColor.black.cgColor
            mask.frame = layerFrame
            
            
            let path = UIBezierPath()
            let botRightPoint = CGPoint(x: radius, y: radius)
            
            path.move(to: botRightPoint)
            path.addArc(withCenter: botRightPoint,
                        radius: radius,
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat.pi*1.5,
                        clockwise: true)
            path.close()
            mask.path = path.cgPath
            
            let layer = CAShapeLayer()
            layer.backgroundColor = layerColor.cgColor
            layer.frame = layerFrame
            layer.mask = mask 
            layer.position = bottomRightPoint
            layer.anchorPoint = CGPoint(x:1, y:1)
            
            return layer
        }
        
        func buildSegment2Layer(radius: CGFloat, layerColor: UIColor) -> CAShapeLayer {
             
            let layerFrame = CGRect(x: 0,
                                    y: 0,
                                    width: radius,
                                    height: radius)
            
            
            let botRightPoint = CGPoint(x: radius, y: radius)
            
            let path = UIBezierPath()
            path.move(to: botRightPoint)
            path.addArc(withCenter: botRightPoint,
                        radius: CGFloat(radius),
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat.pi*1.5,
                        clockwise: true)
            path.close()
            
            
            let layer = CAShapeLayer()
            layer.fillColor = layerColor.cgColor
            layer.path = path.cgPath
            layer.frame = layerFrame
            layer.position = bottomRightPoint
            layer.anchorPoint = CGPoint(x:1, y:1)
            
            return layer
        }
        
        func buildMinimizedMenuIconLayer(iconColor: UIColor,
                                         margingBot: CGFloat,
                                         marginRight: CGFloat,
                                         size: CGSize) -> CAShapeLayer
        {
            
            let lineWidth = size.width
            let lineHeight = size.height/5
            
            let cornerRadius = lineHeight / 2
            let linePath1 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: lineWidth, height: lineHeight), cornerRadius: cornerRadius)
            let linePath2 = UIBezierPath(roundedRect: CGRect(x: 0, y: lineHeight*2, width: lineWidth, height: lineHeight), cornerRadius: cornerRadius)
            let linePath3 = UIBezierPath(roundedRect: CGRect(x: 0, y: lineHeight*4, width: lineWidth, height: lineHeight), cornerRadius: cornerRadius)
            
            let menuPath = UIBezierPath()
            menuPath.append(linePath1)
            menuPath.append(linePath2)
            menuPath.append(linePath3)
            
            let centerPosX = frame.maxX - marginRight - size.width/2
            let centerPosY = frame.maxY - margingBot - size.height/2
            
            let layer = CAShapeLayer()
            layer.fillColor = iconColor.cgColor
            layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.position = CGPoint(x: centerPosX, y: centerPosY)
            layer.path = menuPath.cgPath
            
           
            return layer
        }
        
        func buildExpandMenuIconLayer(iconColor: UIColor,
                                            margingBot: CGFloat,
                                            marginRight: CGFloat,
                                            size: CGSize) -> CAShapeLayer
        {
          
            let linePath1 = UIBezierPath()
            linePath1.move(to: CGPoint.zero)
            linePath1.addLine(to: CGPoint(x: size.width,
                                          y: size.height))
            
            let linePath2 = UIBezierPath()
            linePath2.move(to: CGPoint(x: size.width, y: 0))
            linePath2.addLine(to: CGPoint(x: 0, y: size.height))
            
            
            let path = UIBezierPath()
            path.append(linePath1)
            path.append(linePath2)
            
            let centerPosX = frame.maxX - marginRight - size.width/2
            let centerPosY = frame.maxY - margingBot - size.height/2
            
            let layer = CAShapeLayer()
            layer.strokeColor = iconColor.cgColor
            layer.lineWidth =  size.width / CGFloat(4)
            layer.lineCap = "round"
            layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            layer.position = CGPoint(x: centerPosX, y: centerPosY)
            layer.path = path.cgPath
             
            return layer
        }
        
        
        func buildHighlightLayer(inerRadius: CGFloat,
                                 maxRadius: CGFloat,
                                 color: UIColor,
                                 strokeRange: Range<CGFloat>) -> CAShapeLayer{
        
            let layerFrame = CGRect(x: 0,
                                    y: 0,
                                    width: maxRadius,
                                    height: maxRadius)
            
            let botRightPoint = CGPoint(x: maxRadius, y: maxRadius)
            
           // let path = UIBezierPath(ovalIn: layerFrame)
            let path = UIBezierPath()
            path.addArc(withCenter: botRightPoint,
                        radius: inerRadius + (maxRadius - inerRadius)/2,
                        startAngle: CGFloat.pi,
                        endAngle: CGFloat.pi*1.5,
                        clockwise: true)
            
            
            let layer = CAShapeLayer()
            layer.frame = layerFrame
            layer.strokeStart = strokeRange.lowerBound
            layer.strokeEnd = strokeRange.upperBound
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = color.cgColor
            layer.lineWidth =  maxRadius - inerRadius
            layer.path = path.cgPath
            layer.position = bottomRightPoint
            layer.anchorPoint = CGPoint(x:1, y:1)
            return layer
        }
    }

}
