//
//  ViewController.swift
//  touchTrackingExperiment
//
//  Created by Matt Stone on 9/8/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var touchCounter:Int = 0;
    @IBOutlet weak var labelForPosition: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        touchCounter += 1;
        labelForPosition.text = "Touches Dectected: \(touchCounter)"
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }


}

