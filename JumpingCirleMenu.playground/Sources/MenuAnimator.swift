import Foundation
import UIKit

extension MenuButtonLayer {
    
    // MARK: LayersBuilder
    class Animate {
     
       
        
        
        private static func animate(_ layer: CALayer,_ animation: CAAnimation){
             layer.add(animation, forKey: nil )
        }
        
        static func ChangeBackgroundColorFor(_ layer: CAShapeLayer,
                                                      fromColor:UIColor,
                                                      color: UIColor,
                                                      duration:CFTimeInterval = 1 ){
        
            let animation = CABasicAnimation(keyPath: "backgroundColor")
            animation.fromValue = fromColor
            animation.toValue = color.cgColor
            animation.duration = duration
            animate(layer, animation)
            
        }
        
        static func SpringScaleFor(_ layer: CAShapeLayer, scaleTo: CGFloat, duration:CFTimeInterval = 1, delay: CFTimeInterval = 0 ){
            
            let springAnimation = CASpringAnimation(keyPath: "transform.scale")
            
            print("\(springAnimation.mass )")
            springAnimation.toValue = scaleTo
            springAnimation.initialVelocity = 10
            springAnimation.mass = 1.7
            springAnimation.damping = 13 
            springAnimation.duration = duration
            springAnimation.beginTime = delay
            springAnimation.fillMode =  kCAFillModeBoth
            animate(layer, springAnimation)
        }
        
        static func ImageTransitionFor(_ layer: CALayer,
                                    toPoint: CGPoint,
                                    fromPoint: CGPoint,
                                    duration: CFTimeInterval = 1, isHidenComplete: Bool){
        
            CATransaction.begin()
            let anim = CABasicAnimation(keyPath: "position")
            anim.fromValue = fromPoint
            anim.toValue = toPoint
            anim.duration = duration
            anim.isRemovedOnCompletion = false
            anim.fillMode =  kCAFillModeBoth
            CATransaction.setCompletionBlock {
                layer.isHidden = isHidenComplete
            }
            animate(layer, anim)
            CATransaction.commit()
        }
        
        static func BreathFor(_ layer: CAShapeLayer,
                                    fromScale:CGFloat,
                                breathScale:CGFloat,
                                scaleDownTo: CGFloat,
                                breathDuration:CFTimeInterval = 1,
                                scaleDownDuration:CFTimeInterval = 1,
                                delay: CFTimeInterval = 0 ){
            
            CATransaction.begin()
            
            let breathAnimation = CABasicAnimation(keyPath: "transform.scale")
            breathAnimation.fromValue = fromScale
            breathAnimation.toValue = breathScale
            breathAnimation.duration = breathDuration 
            breathAnimation.fillMode =  kCAFillModeBoth
            
            CATransaction.setCompletionBlock {
                let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
                scaleAnimation.fromValue = breathScale
                scaleAnimation.toValue = scaleDownTo 
                scaleAnimation.duration = scaleDownDuration
                breathAnimation.fillMode =  kCAFillModeBoth
                layer.add(scaleAnimation, forKey: nil)
            }
            
            animate(layer, breathAnimation)
            CATransaction.commit()
            
        }
        
        
        static func Transform(from layer1: CALayer,
                                    to layer2: CALayer,
                                    duration:CFTimeInterval = 0.6) {
            
            let angle = 90.degreesToRadians
            
            
            
            let halfDuration = duration / 2
            let startPosition = layer1.position
            let endPosition = layer2.position
            let middlePosition = CGPoint(
                x:  startPosition.x + (endPosition.x-startPosition.x)/2,
                y:  startPosition.y + (endPosition.y-startPosition.y)/2)
            
            
            
            
            CATransaction.begin()
            
            
            let foldAnim = CABasicAnimation(keyPath: "transform.rotation.x")
            foldAnim.toValue = angle 
            
            let moveAnim = CABasicAnimation(keyPath: "position")
            moveAnim.toValue = middlePosition
            
            let group1 = CAAnimationGroup()
            
            group1.animations = [foldAnim, moveAnim ]
            group1.duration = halfDuration
            group1.isRemovedOnCompletion = false
            group1.fillMode =  kCAFillModeForwards
            
       
            CATransaction.setCompletionBlock {
                layer1.isHidden = true
                layer2.isHidden = false
                
                let unfoldAnim = CABasicAnimation(keyPath: "transform.rotation.x")
                unfoldAnim.toValue = 0
                unfoldAnim.fromValue = angle
                
                let moveAnim2 = CABasicAnimation(keyPath: "position")
                moveAnim2.fromValue = middlePosition
                moveAnim2.toValue =  endPosition
                
                let group2 = CAAnimationGroup()
                group2.animations = [unfoldAnim, moveAnim2 ]
                group2.duration = halfDuration
                group2.isRemovedOnCompletion = false
                group2.fillMode =  kCAFillModeForwards
                animate(layer2, group2)
            }
            
            
            animate(layer1, group1 )
            CATransaction.commit()
        }
        
        
        static func ScaleStrokeFor(_ layer: CALayer,
                                            scaleFrom:CGFloat ,
                                            scaleTo: CGFloat,
                                            compressedRange: Range<CGFloat>,
                                            strokeRange: Range<CGFloat>,
                                            scaleDuration: CFTimeInterval = 0.5,
                                            strokeDuration: CFTimeInterval = 0.5){
        
            
             
            CATransaction.begin()
            layer.isHidden = false
            let anim = CABasicAnimation(keyPath: "transform.scale")
            anim.toValue = scaleTo
            anim.fromValue = scaleFrom
            anim.duration = scaleDuration
            anim.fillMode =  kCAFillModeBoth
            
            CATransaction.setCompletionBlock {
            
                let stroke1Anim = CABasicAnimation(keyPath: "strokeEnd")
                stroke1Anim.fromValue = compressedRange.upperBound
                stroke1Anim.toValue =  strokeRange.upperBound
                
                let stroke2Anim = CABasicAnimation(keyPath: "strokeStart")
                stroke2Anim.fromValue = compressedRange.lowerBound
                stroke2Anim.toValue =  strokeRange.lowerBound
                
                let strokeGroup = CAAnimationGroup()
                strokeGroup.duration = strokeDuration
                strokeGroup.isRemovedOnCompletion = false
                strokeGroup.fillMode =  kCAFillModeBoth
                strokeGroup.animations = [stroke1Anim, stroke2Anim]
                
                animate(layer, strokeGroup )
            }
            animate(layer, anim )
            CATransaction.commit()
        }
 

        static func ReverseScaleStrokeFor(_ layer: CALayer,
                                            scaleFrom:CGFloat ,
                                            scaleTo: CGFloat,
                                            compressedRange: Range<CGFloat>,
                                            strokeRange: Range<CGFloat>,
                                            scaleDuration: CFTimeInterval = 0.5,
                                            strokeDuration: CFTimeInterval = 0.5){
            
            CATransaction.begin()
            
       
            let stroke1Anim = CABasicAnimation(keyPath: "strokeEnd")
            stroke1Anim.fromValue = strokeRange.upperBound
            stroke1Anim.toValue =  compressedRange.upperBound
            
            let stroke2Anim = CABasicAnimation(keyPath: "strokeStart")
            stroke2Anim.fromValue = strokeRange.lowerBound
            stroke2Anim.toValue = compressedRange.lowerBound
            
            let strokeGroup = CAAnimationGroup()
            strokeGroup.duration = strokeDuration
            strokeGroup.isRemovedOnCompletion = false
            strokeGroup.fillMode =  kCAFillModeBoth
            strokeGroup.animations = [stroke1Anim, stroke2Anim]
            
            CATransaction.setCompletionBlock { 
                
                CATransaction.begin()
                let anim = CABasicAnimation(keyPath: "transform.scale")
                anim.toValue = scaleTo
                anim.fromValue = scaleFrom
                anim.duration = scaleDuration
                anim.fillMode =  kCAFillModeBoth
                CATransaction.setCompletionBlock {
                    layer.isHidden = true
                }
                
                animate(layer, anim )
                CATransaction.commit()
            }
            
            animate(layer, strokeGroup )
            CATransaction.commit()
        }
        

        static func StrokeFor(_ layer: CAShapeLayer,
                              strokeRange: Range<CGFloat>,
                              duration: CFTimeInterval = 0.5,
                              completionBlock: @escaping () -> Void){
            
            CATransaction.begin()
            
            let stroke1Anim = CABasicAnimation(keyPath: "strokeStart")
            stroke1Anim.fromValue = layer.strokeStart
            stroke1Anim.toValue =  strokeRange.lowerBound
            
            let stroke2Anim = CABasicAnimation(keyPath: "strokeEnd")
            stroke2Anim.fromValue = layer.strokeEnd
            stroke2Anim.toValue = strokeRange.upperBound
            
            let strokeGroup = CAAnimationGroup()
            strokeGroup.duration = duration 
            strokeGroup.animations = [stroke1Anim, stroke2Anim]
            
            CATransaction.setCompletionBlock {
                
                completionBlock()
            }
            
            animate(layer, strokeGroup )
            CATransaction.commit()
        }
        

    }

}
