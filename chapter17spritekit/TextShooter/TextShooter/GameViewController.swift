//
//  GameViewController.swift
//  TextShooter
//
//  Created by Matt Stone on 10/11/16.
//  Copyright (c) 2016 Matt Stone. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Makes the starting scene
        //let scene = GameScene(size: view.frame.size, levelNumber: 1);
        let scene = StartScene(size: view.frame.size)
        
        //we just set the scene size to the view size, sow e don't need scalMode setting
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        /* Set the scale mode to scale to fit the window */
        //scene.scaleMode = .AspectFill //view and scene are the same size due to init()
        
        skView.presentScene(scene)
        
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
}
