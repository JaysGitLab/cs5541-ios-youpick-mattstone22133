//
//  SKNode+Extra.swift
//  TextShooter
//
//  Created by Matt Stone on 10/13/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

//import Foundation
import SpriteKit

extension SKNode {
    func receiveAttacker(attacker: SKNode, contact: SKPhysicsContact){
        // default implmentation does nothing, please override
    }
    
    func friendlyBumpFrom(node: SKNode){
        // Default implementation does nothing, please override
    }
}