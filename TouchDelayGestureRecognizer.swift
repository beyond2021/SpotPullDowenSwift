//
//  TouchDelayGestureRecognizer.swift
//  SpotPullDowenSwift
//
//  Created by KEEVIN MITCHELL on 11/8/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
// subClassing uigesturerec to stop dots from blinking with fast scroll

import UIKit
import UIKit.UIGestureRecognizerSubclass

class TouchDelayGestureRecognizer: UIGestureRecognizer {
    
    // MARK: - Properties
    var timer: NSTimer?
    // MARK: - Init
    
    
    override init(target: AnyObject, action: Selector) {
        super.init(target: target, action: action)
        delaysTouchesBegan = true // Enable delay touches
       
    }
    // MARK: - Override
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        timer = NSTimer.scheduledTimerWithTimeInterval(0.15, target: self, selector: Selector("fail"), userInfo: nil, repeats: false)
    }
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        fail()
    }
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        fail()
    }
    func fail() {
        state = .Failed
    }
    override func reset() {
        timer?.invalidate()
        timer = nil
    }
    
    
    
    
    
}
    
    
   

