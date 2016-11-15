//
//  EnemyNode.swift
//  TextShooter
//
//  Created by Matt Stone on 10/11/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

//import UIKit
import SpriteKit

class EnemyNode: SKNode {
    override init(){
        super.init()
        name = "Enemy \(self)"
        initNodeGraph()
        initPhysicsBody()
    }
    
    
    required init?(coder aDecorder: NSCoder){
        super.init(coder: aDecorder);
    }
    
    private func initPhysicsBody(){
        let body = SKPhysicsBody(rectangleOfSize: CGSizeMake(40, 40))
        body.affectedByGravity = false
        body.categoryBitMask = EnemyCategory
        body.contactTestBitMask = PlayerCategory | EnemyCategory
        body.mass = 0.2
        body.angularDamping = 0
        body.linearDamping = 0
        body.fieldBitMask = 0

        physicsBody = body
    }
    
    func initNodeGraph(){
        let topRow = SKLabelNode(fontNamed: "Courier-Bold")
        topRow.fontColor = SKColor.brownColor()
        topRow.fontSize = 20
        topRow.text = "x x"
        topRow.position = CGPointMake(0, 15)    //15 above base (which is 0)
        addChild(topRow)
        
        let middleRow = SKLabelNode(fontNamed: "Courier-Bold")
        middleRow.fontColor = SKColor.brownColor()
        middleRow.fontSize = 20
        middleRow.text = "x"
        addChild(middleRow) //default position is fine
        
        let bottomRow = SKLabelNode(fontNamed: "Courier-Bold")
        bottomRow.fontColor = SKColor.brownColor()
        bottomRow.fontSize = 20
        bottomRow.text = "x x"
        bottomRow.position = CGPointMake(0, -15)    //15 above base (which is 0)
        addChild(bottomRow)
        
        
    }
    
    override func friendlyBumpFrom(node: SKNode) {
        physicsBody!.affectedByGravity = true
    }
    
    override func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact) {
        physicsBody!.affectedByGravity = true
        
        //use the attacker's velocity multiplied by the collision implulse as force
        let force = vectorMultiply(attacker.physicsBody!.velocity, contact.collisionImpulse)
        
        //convert the scene's contact point, to the grid system within this node
        let myContact = scene!.convertPoint(contact.contactPoint, toNode: self)
        
        //apply the force (attacker's velocity * impulse) at the converted point
        physicsBody!.applyForce(force, atPoint: myContact)
        
        //PARTICLE 
        let path = NSBundle.mainBundle().pathForResource("MyParticle", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 20
        explosion.position = contact.contactPoint
        scene!.addChild(explosion)
        
        //SOUND EFFECTS
        runAction(SKAction.playSoundFileNamed("enemyHit.wav", waitForCompletion: false))
    }
}
