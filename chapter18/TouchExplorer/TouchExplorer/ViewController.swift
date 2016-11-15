//
//  ViewController.swift
//  TouchExplorer
//
//  Created by Matt Stone on 10/4/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var tapsLabel: UILabel!
    @IBOutlet var touchesLabel: UILabel!
    @IBOutlet var forceLabel: UILabel!
    @IBOutlet var coordinateLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Method to be called when a touch is event is processed
    private func updateLabelsFromTouches(touch: UITouch?, allTouches: Set<UITouch>?){
        let numTaps = touch?.tapCount ?? 0
        let tapMessage = "\(numTaps) taps detected"
        tapsLabel.text = tapMessage
        
        let numTouches = allTouches?.count ?? 0  //?? is like tertiary operator, but for nil checks
        let touchMessage = "\(numTouches) touches detected"
        touchesLabel.text = touchMessage
        
        if traitCollection.forceTouchCapability == .Available {
            forceLabel.text = "Force: \(touch?.force ?? 0) \n Max force: \(touch?.maximumPossibleForce ?? 0)"
        } else {
            forceLabel.text = "3D Touch not available"
        }
        
        let touchXY = touch?.locationInView(self.view)
        coordinateLabel.text = "X: \(touchXY!.x) Y: \(touchXY!.y)"
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Began"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Cancelled"
        updateLabelsFromTouches(touches?.first, allTouches: event?.allTouches())
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Touches Ended"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        messageLabel.text = "Drag Detected"
        updateLabelsFromTouches(touches.first, allTouches: event?.allTouches())
    }
}

