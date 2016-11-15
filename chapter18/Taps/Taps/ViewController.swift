//
//  ViewController.swift
//  Taps
//
//  Created by Matt Stone on 10/4/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var singleLabel: UILabel!
    @IBOutlet weak var doubleLabel: UILabel!
    @IBOutlet weak var tripleLabel: UILabel!
    @IBOutlet weak var quadrupleLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.singleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(singleTap)
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.doubleTap))
        doubleTap.numberOfTapsRequired = 2
        doubleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(doubleTap)
        singleTap.requireGestureRecognizerToFail(doubleTap)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tripleTap))
        tripleTap.numberOfTapsRequired = 3
        tripleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tripleTap)
        doubleTap.requireGestureRecognizerToFail(tripleTap)
        
        let quadrupleTap = UITapGestureRecognizer(target: self, action: #selector(ViewController.quadrupleTap))
        quadrupleTap.numberOfTapsRequired = 4
        quadrupleTap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(quadrupleTap)
        tripleTap.requireGestureRecognizerToFail(quadrupleTap)
        
        
    }
    
    func singleTap() {
        showText("Single Tap Detected", inLabel: singleLabel)
    }
    
    func doubleTap(){
        showText("Double Tap Detected", inLabel: doubleLabel)
    }
    
    func tripleTap(){
        showText("Triple Tap Detected", inLabel: tripleLabel)
    }
    
    func quadrupleTap(){
        showText("Quadruple Tap Detected", inLabel: quadrupleLabel)
    }
    
    private func showText(text:String, inLabel label:UILabel){
        label.text = text
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {label.text = ""})
        
    }
    
    

//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }



}

