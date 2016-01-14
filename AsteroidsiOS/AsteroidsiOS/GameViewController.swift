//
//  GameViewController.swift
//  AsteroidsiOS
//
//  Created by Mathias on 10/12/2015.
//  Copyright (c) 2015 Mathias. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var backgroundColor: UIColor!
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.setHidesBackButton(true, animated:true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.backgroundColor = backgroundColor
            scene.viewController = self
            skView.presentScene(scene)
            
        }
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    func gameOver() {
        //self.view!.window!.rootViewController!.performSegueWithIdentifier("gameOverSegue", sender: self)
    }
}
