//
//  ViewController.swift
//  dragging
//
//  Created by Justin Vallely on 5/27/15.
//  Copyright (c) 2015 Pajama Donkey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var xFromCenter: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Generate UI element with code instead of on the main storyboard
        let label:UILabel = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - 100, self.view.bounds.height / 2 - 50, 200, 100))
        label.text = "Drag Me!"
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
        
        // Add gesture recognizer
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(ViewController.wasDragged(_:)))
        label.addGestureRecognizer(gesture)
        
        // Manually tell xcode that we want to make the label interactive since it's not a button or something normally interactive
        label.userInteractionEnabled = true
        
    }
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        // Determine the amount of translation
        let translation = gesture.translationInView(self.view)
        
        // Get the thing in the gesture (label above)
        let label = gesture.view!
        
        // Keep track of how far the object is from center
        xFromCenter += translation.x
        
        // Scale gets smaller as distance from the center gets greater
        // If scale is larger than 1, it'll be set to 1, otherwise it will be less than 1
        var scale = min(100 / abs(xFromCenter), 1)
        
        // Set the new center point of the thing in the gesture
        label.center = CGPoint(x: label.center.x + translation.x, y: label.center.y + translation.y)
        
        // Reset the translation back to zero
        gesture.setTranslation(CGPointZero, inView: self.view)
        
        // Rotate the object, angle in radians
        // Rotate more if the object is moved along the x axis more
        var rotation: CGAffineTransform = CGAffineTransformMakeRotation(xFromCenter / 200)
        
        // Shrink the object as it moves away from the center, apply the rotation transformation at the same time
        var stretch: CGAffineTransform = CGAffineTransformScale(rotation, scale, scale)
        
        // Apply the shrink and rotation
        label.transform = stretch
        
        // Look for left and right bounds
        if label.center.x < 100 {
            
            print("Left Bounds")
            
        } else if label.center.x > self.view.bounds.width - 100 {
            
            print("Right Bounds")
        }
        
        // Look for the user to let go
        if gesture.state == UIGestureRecognizerState.Ended {
            
            // Reset the object's position, rotation, and size
            label.center = CGPointMake(self.view.bounds.width / 2, self.view.bounds.height / 2)
            
            scale = max(abs(xFromCenter) / 100, 1)
            
            rotation = CGAffineTransformMakeRotation(0)
            
            stretch = CGAffineTransformScale(rotation, scale, scale)
            
            label.transform = stretch
            
            xFromCenter = 0
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

