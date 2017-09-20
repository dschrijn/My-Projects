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
    var red: CGFloat = 0.0
    var redErase: CGFloat = 1.0
    var green: CGFloat = 0.0
    var greenErase: CGFloat = 1.0
    var blue: CGFloat = 0.0
    var blueErase: CGFloat = 1.0
    
    var tool: UIImageView!
    var isDrawing = true
    var isErasing = false
    var selectedImage: UIImage!
    var brushSize: CGFloat = 5.0
    var opacityValue: CGFloat = 1.0
    
    var storedColoringPages: [UIImage] = []

    
    // Mark: IBOutlets
    
    @IBOutlet weak var drawingview: UIImageView!
    @IBOutlet weak var eraseButton: UIButton!
    
    // Mark: App Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawingTool()
        
    }
    // Mark: Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        let settingsVC = segue.destination as! SettingsViewController
        settingsVC.delegate = self
        settingsVC.red = red
        settingsVC.green = green
        settingsVC.blue = blue
        settingsVC.brushSize = brushSize
        settingsVC.opacityValue = opacityValue
    }

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
        tool.center = toPoint
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        if (isErasing) {
            context?.setStrokeColor(UIColor(red: redErase, green: greenErase, blue: blueErase, alpha: 1.0).cgColor)
        } else {
            context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        }
        
        context?.strokePath()
        
        drawingview.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
    }
    
    func drawingTool() {
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 38, height: 38)
        tool.image = #imageLiteral(resourceName: "paintBrush")
        self.view.addSubview(tool)
    }
    
    // Mark: IBActions 
    
    @IBAction func resetButton(_ sender: Any) {
        self.drawingview.image = nil
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let alert = UIAlertController(title: "Pick your option", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Pick an image", style: .default, handler: { (_) in
            
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)

        }))
        
        alert.addAction(UIAlertAction(title: "Save your image", style: .default, handler: { (_) in
            if let image = self.drawingview.image {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }

    @IBAction func eraseButton(_ sender: Any) {
        
        if (isDrawing) {
            isErasing = true
            tool.image = #imageLiteral(resourceName: "EraserIcon")
            eraseButton.setImage(#imageLiteral(resourceName: "paintBrush"), for: .normal)
        } else if (!isDrawing) {
            isErasing = false
            tool.image = #imageLiteral(resourceName: "paintBrush")
            eraseButton.setImage(#imageLiteral(resourceName: "EraserIcon"), for: .normal)
        }
        
        isDrawing = !isDrawing
    }
    
    @IBAction func colorsPicked(_ sender: UIButton) {
        
        switch(Colors(rawValue: sender.tag)!) {
        case .red:
            (red,green,blue) = (1,0,0)
        case .green:
            (red,green,blue) = (0,1,0)
        case .blue:
            (red,green,blue) = (0,0,1)
        case .yellow:
            (red,green,blue) = (1,1,0)
        case .purple:
            (red,green,blue) = (1,0,1)
        case .white:
            (red,green,blue) = (1,1,1)
        case .black:
            (red,green,blue) = (0,0,0)
        }
    }

    
    
    
    

}

extension DrawingViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, SettingsViewControllerDelegate {
    
    enum Colors: Int {
        case red = 0, green, blue, yellow, purple, white, black
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imagePicked = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.selectedImage = imagePicked
            self.drawingview.image = selectedImage
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func settingsViewControllerDidFinish(_ settingsVC: SettingsViewController) {
        self.red = settingsVC.red
        self.green = settingsVC.green
        self.blue = settingsVC.blue
        self.brushSize = settingsVC.brushSize
        self.opacityValue = settingsVC.opacityValue
    }
    
}



