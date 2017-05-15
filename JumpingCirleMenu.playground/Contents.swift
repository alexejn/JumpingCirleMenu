//: Playground - noun: a place where people can play

import PlaygroundSupport
import UIKit

let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))

let width = CGFloat(300)
let jmFrame = CGRect(x: view.bounds.width-width,
                     y: view.bounds.height - width,
                     width: width,
                     height: width)

let jm = JumpingCirleMenuView(frame: jmFrame)
view.backgroundColor = UIColor(red: 32/255, green: 36/255, blue: 75/255, alpha: 1)
view.addSubview(jm)
 PlaygroundPage.current.liveView = view

