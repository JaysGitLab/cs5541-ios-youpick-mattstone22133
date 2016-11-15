//
//  ViewController.swift
//  touchGame
//
//  Created by Matt Stone on 10/4/16.
//  Copyright © 2016 Matt Stone. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var moveFirstLabel: UILabel!
    @IBOutlet weak var moveSecondLabel: UILabel!
    @IBOutlet weak var moveThirdLabel: UILabel!
    @IBOutlet weak var moveFourthLabel: UILabel!
    @IBOutlet weak var successLabel: UILabel!

    private var moves:[String] = []
    private var states:[Bool] = []
    
    private var startPoint:CGPoint?
    private let tolerance = CGFloat(10)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        resetLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func testMove(move:String) -> Void {
        //test each move
        if !states[0]{
            if (move == moves[0]){
                states[0] = true;
                moveFirstLabel.alpha = CGFloat(0.25)
            }
        } else if !states[1] {
            if (move == moves[1]){
                states[1] = true;
                moveSecondLabel.alpha = CGFloat(0.25)
            }
        } else if !states[2] {
            if (move == moves[2]){
                states[2] = true;
                moveThirdLabel.alpha = CGFloat(0.25)
            }
        } else if !states[3] {
            if (move == moves[3]){
                states[3] = true;
                moveFourthLabel.alpha = CGFloat(0.25)

            }
        }
        
        if states[3]{   //could combine this is last if else statement
            moveFirstLabel.alpha = CGFloat(0)
            moveSecondLabel.alpha = CGFloat(0)
            moveThirdLabel.alpha = CGFloat(0)
            moveFourthLabel.alpha = CGFloat(0)
            successLabel.text = "You Win!"
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
                self.resetLabels();
            })
        }
    }

    func populateMoves() -> Void {
        moves.removeAll()
        states.removeAll()
        
        //Loop 4 times to add 4 moves
        var i = 0;
        while i < 4 {
            states.append(Bool(false))
            let moveVal = Int(arc4random_uniform(4))
            switch moveVal{
            case 0:
                moves.append("up")
                break;
            case 1:
                moves.append("down")
                break;
            case 2:
                moves.append("right")
                break;
            case 3:
                moves.append("left")
                break;
            default:
                moves.append("up")
                break;
            }
            
            i += 1
        }
    }
    
    
    func resetLabels(){
        moveFirstLabel.text = ""
        moveFirstLabel.alpha = CGFloat(1)
        
        moveSecondLabel.text = ""
        moveSecondLabel.alpha = CGFloat(1)
        
        moveThirdLabel.text = ""
        moveThirdLabel.alpha = CGFloat(1)
        
        moveFourthLabel.text = ""
        moveFourthLabel.alpha = CGFloat(1)
        
        titleLabel.text = "Let's play a never ending game..."
        successLabel.text = ""
        populateMoves()
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.moveFirstLabel.text = self.moves[0]
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.moveSecondLabel.text = self.moves[1]
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.moveThirdLabel.text = self.moves[2]
        })
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.moveFourthLabel.text = self.moves[3]
        })
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first{
            startPoint = touch.locationInView(view)
        }
    }
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let endPoint = touch.locationInView(view)
            let xDist = (endPoint.x - startPoint!.x)
            let yDist = (endPoint.y - startPoint!.y)
            
            //check left/right (x distance changed was greater than y distance)
            if fabs(xDist) > fabs(yDist) && yDist < tolerance{
                //end point is greater in x, therefore swiped right
                if startPoint!.x < endPoint.x {
                    testMove("right")
                } else {
                    testMove("left")
                }
            }
            //check up/down
            else if xDist < tolerance {
                //end point is greater in y, therefore swiped down
                if startPoint!.y < endPoint.y {
                    testMove("down")
                } else {
                    testMove("up")
                }
            }
            
            
        }
    }
}

