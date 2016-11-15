//
//  PlayerNode.swift
//  TextShooter
//
//  Created by Matt Stone on 10/11/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import SpriteKit

class PlayerNode: SKNode {

    override init(){
        super.init()
        name = "Player \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    private func initNodeGraph(){
        let label = SKLabelNode(fontNamed: "Courier")
        label.fontColor = SKColor.darkGrayColor()
        label.fontSize = 40
        label.text = "v"
        label.zRotation = CGFloat(M_PI)
        label.name = "label"
        self.addChild(label)
    }
    
    func moveToward(location: CGPoint) -> Void {
        removeActionForKey("movement")  //cancel last movement
        removeActionForKey("wobble")    //cancel last wobble
        let distance = pointDistance(position, location)
        let screenWidth = UIScreen.mainScreen().bounds.size.width
        let duration = NSTimeInterval(2 * distance/screenWidth)
        
        //Run the move
        runAction(SKAction.moveTo(location, duration: duration), withKey: "movement")
        
        //Set up and run the wobble
        let wobbleTime = 0.3
        let halfWobbleTime = wobbleTime/2
        let wobbling = SKAction.sequence([
                SKAction.scaleXTo(0.2, duration: halfWobbleTime), //first action shrinks x
                SKAction.scaleXTo(1.0, duration: halfWobbleTime)  //second action restores x
            ])
        let wobbleCount = Int(duration/wobbleTime) //get how many wobbles in duration (wobble time is 0.3)
        runAction(SKAction.repeatAction(wobbling, count: wobbleCount), withKey: "wobbling")
    }
    
    private func initPhysicsBody(){
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(20, 20))
        body.affectedByGravity = false
        body.categoryBitMask = PlayerCategory
        body.contactTestBitMask = EnemyCategory
        body.collisionBitMask = 0
        body.fieldBitMask = 0   //prevents it from feeling the effects of gravity fields
        physicsBody = body
    }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        let path = NSBundle.mainBundle().pathForResource("EnemyExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 50
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        runAction(SKAction.playSoundFileNamed("playerHit.wav", waitForCompletion: false))
    }
    
}
