//
//  GameScene.swift
//  TextShooter
//
//  Created by Matt Stone on 10/11/16.
//  Copyright (c) 2016 Matt Stone. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var levelNumber: Int
    private var playerLives: Int {
        didSet{
            let lives = childNodeWithName("LivesLabel") as! SKLabelNode
            lives.text = "Lives: \(playerLives)"
        }
    }
    private var finished: Bool = false
    private let playerNode: PlayerNode = PlayerNode()
    private let enemies = SKNode() //save all enemies in this node, rather than an array
    private let playerBullets = SKNode()  //save all bullets in this object
    private let forceFields = SKNode()
    
    //similar to a static method, but this conforms to the protocol for static methods
    class func scene(size:CGSize, levelNumber:Int) -> GameScene{
        return GameScene(size: size, levelNumber: levelNumber)
    }
    
    override convenience init(size:CGSize){
        self.init(size: size, levelNumber: 1)
    }
    
    init(size:CGSize, levelNumber:Int){
        self.levelNumber = levelNumber
        self.playerLives = 5
        super.init(size: size)
        
        //Lives Label
        backgroundColor = SKColor.lightGrayColor()
        let lives = SKLabelNode(fontNamed: "Courier")
        lives.fontSize = 16
        lives.fontColor = SKColor.blackColor()
        lives.name = "LivesLabel"
        lives.text = "Lives \(playerLives)"
        lives.verticalAlignmentMode = .Top
        lives.horizontalAlignmentMode = .Right
        lives.position = CGPointMake(frame.size.width, frame.size.height)
        addChild(lives)
        
        //Level Label
        let level = SKLabelNode(fontNamed: "Courier")
        level.fontSize = 16
        level.fontColor = SKColor.blackColor()
        level.name = "LevelLabel"
        level.text = "Level \(levelNumber)"
        level.verticalAlignmentMode = .Top
        level.horizontalAlignmentMode = .Left
        level.position = CGPointMake(0, frame.height)
        addChild(level)
        
        //Player Node Class set up
        playerNode.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) * 0.1)
        addChild(playerNode) //node, did middle of y * 0.1 to put object near bottom
        
        addChild(enemies)
        spawnEnemies()
        
        addChild(playerBullets)
        
        
        //set up force field
        addChild(forceFields)
        createForceFields();
        
        //set up the physics world
        physicsWorld.gravity = CGVectorMake(0, -1)
        physicsWorld.contactDelegate = self
        
    }
    
    //Decode a saved file
    required init?(coder aDecoder: NSCoder) {
        levelNumber = aDecoder.decodeIntegerForKey("level")
        playerLives = aDecoder.decodeIntegerForKey("playerLives")
        super.init(coder: aDecoder)
    }
    
    //Encode a file for saving
    override func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(Int(levelNumber), forKey: "level")
        aCoder.encodeInteger(playerLives, forKey: "playerLives")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            //check if the y location is less than height *0.2
            if location.y < CGRectGetHeight(frame) * 0.2 {
                //touched in movement area
                let target = CGPointMake(location.x, playerNode.position.y)
                playerNode.moveToward(target)
            } else {
                //touched in shooting area
                let bullet = BulletNode.bullet(from: playerNode.position, toward: location)
                playerBullets.addChild(bullet)
            }
        }
    }
    
    private func spawnEnemies(){
        let count = Int(log(Float(levelNumber))) + levelNumber
        for _ in 0..<count {
            let enemy = EnemyNode()
            let size = frame.size;
            let x = arc4random_uniform(UInt32(size.width * 0.8)) + UInt32(size.width * 0.1)
            let y = arc4random_uniform(UInt32(size.height * 0.5)) + UInt32(size.height * 0.5)
            enemy.position = CGPointMake(CGFloat(x), CGFloat(y))
            enemies.addChild(enemy) //store the enemy as a child in the enemies node (as opposed to using array)
            
        }
    }
    

    
    private func updateBullets(){
        var bulletsToRemove:[BulletNode] = []
        for bullet in playerBullets.children as! [BulletNode]{
            // remove offscreen bullets
            if !CGRectContainsPoint(frame, bullet.position){
                //bullet is off screen, mark it for removal
                bulletsToRemove.append(bullet)
                continue
            }
            
            //apply thrust to remaining bullets
            bullet.applyRecurringForce()
        }
        playerBullets.removeChildrenInArray(bulletsToRemove)
    }
    
    private func updateEnemies(){
        var enemiesToRemove:[EnemyNode] = []
        for node in enemies.children as! [EnemyNode] {
            if !CGRectContainsPoint(frame, node.position){
                enemiesToRemove.append(node)
            }
        }
        enemies.removeChildrenInArray(enemiesToRemove)
        
    }
    
    private func checkForNextLevel(){
        if enemies.children.isEmpty {
            goToNextLevel()
        }
    }
    
    private func goToNextLevel(){
        finished = true
        let label = SKLabelNode(fontNamed: "Courier")
        label.text = "Level Complete!"
        label.fontColor = SKColor.blueColor()
        label.fontSize = 32
        label.position = CGPointMake(frame.size.width * 0.5, frame.size.height*0.5)
        addChild(label)
        
        let nextLevel = GameScene(size: frame.size, levelNumber: levelNumber + 1)
        nextLevel.playerLives = playerLives
        view!.presentScene(nextLevel, transition: SKTransition.flipHorizontalWithDuration(1.0))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if finished {
            return
        }
        updateBullets()
        updateEnemies()
        if(!checkForGameOver()){
            checkForNextLevel()
        }
        
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        //if bodyA and bodyB are the same type of object
        if contact.bodyA.collisionBitMask == contact.bodyB.collisionBitMask {
            let nodeA = contact.bodyA.node!
            let nodeB = contact.bodyB.node!
            
            //What should we do w/ these nodes?
            nodeA.friendlyBumpFrom(nodeB)
            nodeB.friendlyBumpFrom(nodeA)
        }
        //bodyA and bodyB are not the same type of physical object
        else {
            var attacker: SKNode
            var attackee:SKNode
            
            //set up the attacker and attackee
            if contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask{
                //BodyA is attacking bodyB
                attacker = contact.bodyA.node!
                attackee = contact.bodyB.node!
            } else {
                attacker = contact.bodyB.node!
                attackee = contact.bodyA.node!
            }
            
            //do logic
            if attackee is PlayerNode {
                playerLives -= 1
            }
            
            //extra logic for attacker/attackee
            attackee.receiveAttacker(attacker, contact: contact)
            
            //"blanket" style remove object 
            playerBullets.removeChildrenInArray([attacker]) //does nothing if not child
            enemies.removeChildrenInArray([attacker]) //does nothing if not child
        }
    }
    

    private func triggerGameOver(){
        finished = true
        let path = NSBundle.mainBundle().pathForResource("EnemyExplosion", ofType: "sks")
        let explosion = NSKeyedUnarchiver.unarchiveObjectWithFile(path!) as! SKEmitterNode
        explosion.numParticlesToEmit = 200
        explosion.position = playerNode.position
        scene!.addChild(explosion)
        playerNode.removeFromParent()
        
        let transition = SKTransition.doorsOpenVerticalWithDuration(1)
        let gameOver = GameOverScene(size: frame.size)
        view!.presentScene(gameOver, transition: transition)
        runAction(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
    }
    
    private func checkForGameOver() -> Bool {
        if playerLives <= 0{
            triggerGameOver()
            return true
        }
        return false
    }
    
    private func createForceFields() {
        let fieldCount = 3
        let size = frame.size
        let sectionWidth = Int(size.width)/fieldCount
        for i in 0 ..< fieldCount {
            let x = CGFloat(UInt32(i*sectionWidth) + arc4random_uniform(UInt32(sectionWidth)))
            //get a random number based on 1/4 height, and add in 1/4 height
            let y = CGFloat(arc4random_uniform(UInt32(size.height * 0.25)) + UInt32(size.height * 0.25))
            let gravityField = SKFieldNode.radialGravityField()
            gravityField.position = CGPointMake(x,y)
            gravityField.categoryBitMask = GravityFieldCategory
            gravityField.strength = 4
            gravityField.falloff = 2
            gravityField.region = SKRegion(size: CGSizeMake(size.width * 0.3, size.height * 0.1))
            forceFields.addChild(gravityField)
            
            let fieldLocationNode = SKLabelNode(fontNamed: "Courier")
            fieldLocationNode.fontSize = 16
            fieldLocationNode.fontColor = SKColor.redColor()
            fieldLocationNode.name = "GravityField"
            fieldLocationNode.text = "*"
            fieldLocationNode.position = CGPointMake(x , y)
            forceFields.addChild(fieldLocationNode)
        }
    }
}
