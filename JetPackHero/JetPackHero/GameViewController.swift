//
//  GameViewController.swift
//  JetPackHero
//
//  Created by David A. Schrijn on 4/23/17.
//  Copyright © 2017 David A. Schrijn. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, GameSceneDelegate {
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        //Setting up scene based on Aspect Ratio
        if let skView = self.view as? SKView {
            if skView.scene == nil {
                let aspectRatio = skView.bounds.size.height / skView.bounds.size.width
                let scene = GameScene(size: CGSize(width: 320, height: 320 * aspectRatio), stateClass: MainMenuState.self, delegate: self)
                
                skView.showsFPS = false
                skView.showsNodeCount = false
                skView.showsPhysics = false
                skView.ignoresSiblingOrder = true
                
                scene.scaleMode = .aspectFit
                
                skView.presentScene(scene)
            }
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //Function to capture screen image
    func screenShot() -> UIImage{
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 1.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    //Function to share the image with UIActivityViewController
    func shareString(_ string: String, url: URL, image: UIImage) {
        let activityViewController = UIActivityViewController(activityItems: [string, url, image], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    
}
