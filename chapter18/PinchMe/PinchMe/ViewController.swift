//
//  ViewController.swift
//  PinchMe
//
//  Created by Matt Stone on 10/4/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    private var imageView: UIImageView!
    private var scale = CGFloat(1)
    private var previousScale = CGFloat(1)
    private var rotation = CGFloat(0)
    private var previousRotation = CGFloat(0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let image = UIImage(named: "StaceyAndMe")
        imageView = UIImageView(image: image)
        imageView.userInteractionEnabled = true
        imageView.center = view.center
        view.addSubview(imageView)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(doPinch))
        pinchGesture.delegate = self
        imageView.addGestureRecognizer(pinchGesture)
        
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(doRotate))
        rotationGesture.delegate = self
        imageView.addGestureRecognizer(rotationGesture)
    }
    
    //allow multiple gestures to be processed at same time
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldREcognizeSimultaneouslyWithGestureRecognizer otherGestureREcognizer: UIGestureRecognizer) -> Bool {
        return true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func transformImageView(){
        var t = CGAffineTransformMakeScale(scale * previousScale, scale * previousScale)
        t = CGAffineTransformRotate(t, previousRotation + rotation)
        imageView.transform = t
    }
    
    func doPinch(gesture:UIPinchGestureRecognizer){
        scale = gesture.scale
        transformImageView()
        if gesture.state == .Ended {
            previousScale = scale * previousScale
        }
    }
    
    func doRotate(gesture:UIRotationGestureRecognizer){
        rotation = gesture.rotation
        transformImageView()
        if gesture.state == .Ended {
            previousRotation = rotation + previousRotation
            rotation = 0
        }
        
    }
    
    
}

