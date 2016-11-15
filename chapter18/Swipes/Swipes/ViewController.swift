//
//  ViewController.swift
//  Swipes
//
//  Created by Matt Stone on 10/4/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var label: UILabel!
    private var gestureStartPoint: CGPoint!
    private static let minimumGestureLength = Float(25.0)
    private static let maxmiumVariance = Float(5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Below is for gesture recognizer
        var touchCount = 1;
        while(touchCount <= 5){
            let vertical = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.reportVerticalSwipe(_:)))
            vertical.direction = [.Up, .Down]
            vertical.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(vertical)
            
            let horizontal = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.reportHorizontalSwipe(_:)))
            horizontal.direction = [.Left, .Right]
            horizontal.numberOfTouchesRequired = touchCount
            view.addGestureRecognizer(horizontal)
            
            //Increment loop variable
            touchCount += 1
        }
    }


//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            gestureStartPoint = touch.locationInView(self.view)
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first, gestureStartPoint = self.gestureStartPoint{
//            let currentPosition = touch.locationInView(self.view)
//            let deltaX = fabs(Float(gestureStartPoint.x - currentPosition.x))
//            let deltaY = fabs(Float(gestureStartPoint.y - currentPosition.y))
//            
//            //HORRIZONTAL: if the gesture is long enough and the gesture has little enough variance between X and y
//            if deltaX >= ViewController.minimumGestureLength && deltaY < ViewController.maxmiumVariance {
//                label.text = "Horrizontal swipe detected"
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue()){
//                    self.label.text = "" //remove the last swipe detected after 2 seconds
//                }
//            }
//            
//            //VERTICAL: 
//            else if deltaY >= ViewController.minimumGestureLength && deltaX < ViewController.maxmiumVariance {
//                label.text = "Vertical swipe detected"
//                let closure = {self.label.text = ""}
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), closure)
//            }
//        }
//    }
    
    func reportHorizontalSwipe(recognizer:UIGestureRecognizer){
        //label.text = "Horizontal Swipe Detected!"
        
        let count = descriptionForTouchCount(recognizer.numberOfTouches())
        label.text = "\(count)-finger horizontal swipe detected"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.label.text = ""
        })
    }
    
    
    func reportVerticalSwipe(recognizer:UIGestureRecognizer){
        //label.text = "Vertical Swipe Detected!"
        
        let count = descriptionForTouchCount(recognizer.numberOfTouches())
        label.text = "\(count)-finger vertical swipe detected"
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.label.text = ""
        })
    }
    
    func descriptionForTouchCount(touchCount:Int) -> String {
        switch touchCount {
        case 1: return "Single"
        case 2: return "Double"
        case 3: return "Triple"
        case 4: return "Quadruple"
        case 5: return "Quintuple"
        default: return ""
        }
    }

}

