import Foundation
import UIKit

public final class JumpingCirleMenuView: UIView {
    
    @IBInspectable var color1: UIColor = UIColor.orange
    @IBInspectable var color2: UIColor = UIColor.yellow
    
    
    //MARK: init
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        initPhase2()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initPhase2()
    }
    
    private var menuButtonLayer:MenuButtonLayer!
    
    private func initPhase2() {
        let color2 = UIColor(red: 32/255, green: 36/255, blue: 75/255, alpha: 1)
        let img1 = #imageLiteral(resourceName: "Fill 195.png")
        let img2 = #imageLiteral(resourceName: "Fill 196.png")
        let img3 = #imageLiteral(resourceName: "Fill 200.png")
        menuButtonLayer = MenuButtonLayer(frame: bounds,
                                          color1: UIColor.white,
                                          color2: color2,
                                          menuHighLightColor: UIColor.red,
                                          minimizedMenuRadius: 80,
                                          iconSize: CGSize(width: 40, height: 40),
                                          menuIcons: [img1,img2,img3])
        layer.addSublayer(menuButtonLayer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        
        let point = sender.location(in: self)
         
        menuButtonLayer.TapOnMenu(point: point)
    }
    
}
