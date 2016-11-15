//
//  GmeOverScene.swift
//  TextShooter
//
//  Created by Matt Stone on 10/13/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit
import SpriteKit

class GameOverScene: SKScene {
    override init(size: CGSize){
        super.init(size: size)
        
        backgroundColor = SKColor.purpleColor()
        let text = SKLabelNode(fontNamed: "Courier")
        text.text = "Game Over"
        text.fontColor = SKColor.whiteColor()
        text.fontSize = 50
        
        //make the label appear at the middle of the screen
        text.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(text)
    }
    
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        
        let closure = {
            let transition = SKTransition.flipVerticalWithDuration(1)
            let start = StartScene(size: self.frame.size)   //set the start size 
            view.presentScene(start, transition: transition)
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * Int64(NSEC_PER_SEC)), dispatch_get_main_queue(), closure)
    }
}
