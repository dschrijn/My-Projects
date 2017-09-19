//
//  DrawingViewController.swift
//  worldOfColorApp
//
//  Created by David A. Schrijn on 9/19/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {

    // Mark: Variables
    var lastPoint = CGPoint.zero
    var swiped = false
    
    // Mark: IBOutlets
    
    @IBOutlet weak var drawingview: UIImageView!
    
    // Mark: App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    // Mark: Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped  {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        drawingview.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        let context = UIGraphicsGetCurrentContext()
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(8)
        context?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        
        drawingview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    // Mark: IBActions 
    
    
    
    
    

}
