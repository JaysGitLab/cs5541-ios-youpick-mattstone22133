//
//  Geometry.swift
//  TextShooter
//
//  Created by Matt Stone on 10/11/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import Foundation
import UIKit

//multiple a vector by a float
func vectorMultiply(v: CGVector, _ m: CGFloat) -> CGVector{
    return CGVectorMake(v.dx * m, v.dy * m)
}

//make two pointers into a vector (directio from p1 to p2)

func vectorBetweenPoints(p1: CGPoint, _ p2: CGPoint) -> CGVector {
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y)
}

//returns the length of the vector using pythagorean's theorm
func vectorLength(v: CGVector) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(v.dx),2) + powf(Float(v.dy),2)))
}

//calculates distance between two points using pythagorean
func pointDistance(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return CGFloat(
        sqrtf(powf(Float(p2.x - p1.x),2) + powf(Float(p2.y - p1.y), 2))
    )
}
