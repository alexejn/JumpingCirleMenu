import UIKit
import QuartzCore
import CoreImage
import UIKit

public final class MenuButtonLayer: CAShapeLayer {

    public enum State {
        case minimized
        case expand
    }
    
    public private(set) var state = State.minimized
    {
        didSet {
            if  state != oldValue {
                changeState()
            }
        }
    }
    
    internal var currentSelectedItemNum: Int! {
        didSet{
            if  currentSelectedItemNum != oldValue {
                
                let strokeRange = getStrokeRangeFor(currentSelectedItemNum) 
                Animate.StrokeFor(highlightLayer,
                                  strokeRange: strokeRange,
                                  duration: 0.15)
                {
                    self.highlightLayer.strokeStart = strokeRange.lowerBound
                    self.highlightLayer.strokeEnd = strokeRange.upperBound
                    self.state = State.minimized }
            } else {
                state = State.minimized
            }
            
        }
    }
    internal var color1:UIColor!
    internal var color2:UIColor!
    internal var menuHighLightColor:UIColor!
    internal var minimizedMenuRadius:CGFloat!
    internal var menuIcons:[UIImage]!
    internal var iconSize:CGSize!
    
    let segment2ScaleFactor:CGFloat = 2.9
    let highlightSegmentCompressor:CGFloat = 0.1
    let segment1ScaleFactor:CGFloat = 1.5
    let breathScaleAddictionFactor:CGFloat = 0.35
    var imgPositionRadius: CGFloat {
        
       let toCenter = (maxSector2Radius - minimizedMenuRadius)/2
       return   maxSector2Radius - toCenter
    }
    
    var maxSector2Radius: CGFloat { return minimizedMenuRadius * segment2ScaleFactor  }
    
    func getStrokeRangeFor(_ itemNum: Int) -> Range<CGFloat> {
        
        let step = 1.0 / CGFloat(menuIcons.count)
        let start = CGFloat(itemNum - 1) * step
        let end = CGFloat(itemNum)  * step
        return Range<CGFloat>(uncheckedBounds: (lower: start , upper: end ))
    }
    
   func calcCompressedRange(compressor: CGFloat, range: Range<CGFloat>) -> Range<CGFloat> {
        
        let length = range.upperBound - range.lowerBound
        let compressedLength = length * compressor
        let padding = (length - compressedLength)/2
        
        return Range<CGFloat>(uncheckedBounds: (lower: range.lowerBound + padding ,
                                                upper: range.upperBound - padding ))
    }
    
    
    internal var segment1Layer: CAShapeLayer!
    internal var segment2Layer: CAShapeLayer!
    internal var hightLighingSegmaneLayer: CAShapeLayer!
    internal var minimizedMenuIconLayer: CAShapeLayer!
    internal var expandMenuIconLayer: CAShapeLayer!
    internal var highlightLayer: CAShapeLayer!
    internal var imagesIconLayers: [CALayer]!

    public func TapOnMenu(point: CGPoint) {
     
        if isPointInSegment1Layer(point) {
            state = state == .minimized ? .expand : .minimized
        } else if state == .expand {
            
            var currentNumIterator = 1
            for iconLayer in imagesIconLayers {
                if isPointInIconImageLayer(point, iconLayer ) {
                    currentSelectedItemNum = currentNumIterator
                    break
                } else {
                    currentNumIterator += 1
                }
            }
        }
         
    }
    
    private func isPointInIconImageLayer(_ point: CGPoint, _ layer: CALayer ) -> Bool {
     
        let convertedPoint = convert(point, to: layer)
        return layer.bounds.contains(convertedPoint)
    }

    private func isPointInSegment1Layer(_ point: CGPoint) -> Bool {
    
       let convertedPoint = convert(point, to: segment1Layer)
       if let maskLayer =   segment1Layer.mask as? CAShapeLayer ,
          let path = maskLayer.path, path.contains(convertedPoint)
       {
            return true
       } else {
            return false
       }
    }
 
    public init(
        frame: CGRect,
        color1: UIColor = UIColor.white,
        color2: UIColor = UIColor.blue,
        menuHighLightColor: UIColor,
        minimizedMenuRadius: CGFloat,
        iconSize: CGSize,
        menuIcons: [UIImage],
        currentSelectedItemNum: Int = 2
        ) {
        super.init()
        
        self.color1 = color1
        self.color2 = color2
        self.minimizedMenuRadius =  minimizedMenuRadius
        self.menuHighLightColor = menuHighLightColor
        self.menuIcons = menuIcons
        self.iconSize = iconSize
        self.frame = frame
        self.currentSelectedItemNum = currentSelectedItemNum
        initPhase2()
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    let show = { (l:CALayer) in l.isHidden = false }
    let hide = { (l:CALayer) in l.isHidden = true }
    
}


// MARK: Logics
extension MenuButtonLayer {
    

    
    func initPhase2() {
    
        let builder = LayerBuilder(frame: self.frame)
        segment1Layer = builder.buildSegment1Layer(radius: minimizedMenuRadius,
                                                   layerColor: color1)
        segment2Layer = builder.buildSegment2Layer(radius: minimizedMenuRadius,
                                                   layerColor: color1)
        
        minimizedMenuIconLayer = builder.buildMinimizedMenuIconLayer(iconColor: color2, margingBot: 15, marginRight: 15, size: CGSize(width: 30, height: 28))
        
        expandMenuIconLayer = builder.buildExpandMenuIconLayer(iconColor: color1, margingBot: 35, marginRight: 35, size: CGSize(width: 20, height: 20))
        

        imagesIconLayers = builder.buildImagesIconLayers(size: iconSize, imgs: menuIcons, imgColor: color2, positionRadius: imgPositionRadius )
        
        
        let selectedItemStrokeRange = getStrokeRangeFor(currentSelectedItemNum)
        let initStroke = calcCompressedRange(compressor: highlightSegmentCompressor,
                                             range: selectedItemStrokeRange)
        highlightLayer = builder.buildHighlightLayer(inerRadius: minimizedMenuRadius,
                                                     maxRadius: maxSector2Radius,
                                                     color: menuHighLightColor,
                                                     strokeRange: initStroke
        )
        
        
        
        let buttonContainerLayer = CALayer()
        buttonContainerLayer.frame = frame
        buttonContainerLayer.addSublayer(minimizedMenuIconLayer)
        buttonContainerLayer.addSublayer(expandMenuIconLayer)
        
        
        
        // Adding sublayers 
         addSublayer(segment2Layer)
         addSublayer(highlightLayer)
         imagesIconLayers.forEach(addSublayer)
         [segment1Layer, buttonContainerLayer].forEach(addSublayer)
        
        imagesIconLayers.forEach(hide)
        hide(expandMenuIconLayer)
        hide(highlightLayer)
        
    }
    
    func showHideLayerFor(state: State) {
        

        switch state {
        case .expand:
            [segment2Layer, expandMenuIconLayer].forEach(show)
            [minimizedMenuIconLayer].forEach(hide)
        case .minimized:
            [segment2Layer, expandMenuIconLayer].forEach(hide)
            [minimizedMenuIconLayer].forEach(show)
            
        }
    }
 
    func changeState() {
        
        let strokeRange = getStrokeRangeFor(currentSelectedItemNum)
        let compressedRange = calcCompressedRange(compressor: highlightSegmentCompressor,
                                                  range: strokeRange)
  
        switch state {
        case .expand:
            segment1Layer.backgroundColor = color2.cgColor
            Animate.ChangeBackgroundColorFor(segment1Layer,
                                                              fromColor: color1,
                                                              color: color2,
                                                              duration: 0.2)
            
            segment1Layer.transform = CATransform3DMakeScale(segment1ScaleFactor,segment1ScaleFactor, 1)
            Animate.SpringScaleFor(segment1Layer, scaleTo: segment1ScaleFactor, duration: 1)
            
            segment2Layer.transform = CATransform3DMakeScale(segment2ScaleFactor, segment2ScaleFactor, 1)
            Animate.SpringScaleFor(segment2Layer,
                                                scaleTo: segment2ScaleFactor,
                                                duration: 0.6)
            
            Animate.Transform(from: minimizedMenuIconLayer,
                                           to: expandMenuIconLayer,
                                           duration: 0.3)
            
            var delayIncrement = 0.2
            imagesIconLayers.forEach {  layer in
                DispatchQueue.main.asyncAfter(deadline: .now() + delayIncrement) {
                    
                    self.show(layer)
                    Animate.ImageTransitionFor(layer,
                                                    toPoint: layer.position,
                                                    fromPoint: CGPoint(x: self.frame.maxX,
                                                                       y: self.frame.maxY),
                                                    duration: 0.3,
                                                    isHidenComplete: false)
                }
                delayIncrement += 0.07
            }
             
            Animate.ScaleStrokeFor(highlightLayer,
                                                    scaleFrom: 0,
                                                    scaleTo: 1,
                                                    compressedRange: compressedRange,
                                                    strokeRange: strokeRange,
                                                    scaleDuration:  0.35,
                                                    strokeDuration:  0.35)
            
        case .minimized:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.segment1Layer.backgroundColor = self.color1.cgColor
                Animate.ChangeBackgroundColorFor(self.segment1Layer,
                                                                  fromColor: self.color2,
                                                                  color: self.color1,
                                                                  duration: 0.2 )
            }
            
           DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                 Animate.Transform(from: self.expandMenuIconLayer,
                                                        to: self.minimizedMenuIconLayer,
                                                        duration: 0.3)
            }
            
            segment1Layer.transform = CATransform3DMakeScale(1, 1, 1)
            Animate.BreathFor(segment1Layer,
                                            fromScale: segment1ScaleFactor,
                                            breathScale: segment1ScaleFactor + breathScaleAddictionFactor,
                                            scaleDownTo: 1,
                                            breathDuration: 0.2,
                                            scaleDownDuration: 0.3)
            
            segment2Layer.transform = CATransform3DMakeScale(1, 1, 1)
            Animate.BreathFor(segment2Layer,
                                            fromScale: segment2ScaleFactor,
                                            breathScale: segment2ScaleFactor + breathScaleAddictionFactor,
                                            scaleDownTo: 1,
                                            breathDuration: 0.2,
                                            scaleDownDuration: 0.3)
             
            imagesIconLayers.forEach { layer in
                Animate.ImageTransitionFor(layer,
                                                toPoint: CGPoint(x: frame.maxX, y: frame.maxY) ,
                                                fromPoint:layer.position,
                                                duration: 0.3,
                                                isHidenComplete: true)
            }
            
            Animate.ReverseScaleStrokeFor(highlightLayer,
                                                    scaleFrom: 1,
                                                    scaleTo: 0,
                                                    compressedRange: compressedRange,
                                                    strokeRange: strokeRange,
                                                    scaleDuration:  0.3,
                                                    strokeDuration:  0.2)
        }
         
 
    }
    
}


