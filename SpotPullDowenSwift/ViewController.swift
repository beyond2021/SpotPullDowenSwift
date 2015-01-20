//
//  ViewController.swift
//  SpotPullDowenSwift
//
//  Created by KEEVIN MITCHELL on 11/4/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
//

import UIKit

var canvasView:UIView!
var scrollView:UIScrollView!
var drawerView:UIVisualEffectView! //Added in IOS8




class ViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        
        
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        canvasView = UIView()
        scrollView = UIScrollView()
        drawerView = UIVisualEffectView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience override init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    
    
    
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let bounds:CGRect = self.view.bounds
        canvasView = UIView(frame: bounds)
        canvasView.backgroundColor = UIColor.darkGrayColor()
        self.view .addSubview(canvasView)
        
        let touchDelay = TouchDelayGestureRecognizer(target: self, action: nil)//stops highlighting when fast scrolling.
        
        
        
        canvasView.addGestureRecognizer(touchDelay)//SpecialGestRec to stop dots from blinkin with Pan. So the dots in the canvas can get the same behavior as the dots in the scrollView
        
        
        
        addDotts(25, toView: canvasView)
                DotView.arrangeDotsRandomlyInView(canvasView)
        
        
        
        
        
        let scrollViewBounds = self.view.bounds
        scrollView = OverlayScrollView(frame: scrollViewBounds)
        self.view .addSubview(scrollView)
        
       // let scrollView = UIScrollView(frame: UIScreen.mainScreen().bounds)
       
        
       let drawerViewBounds = self.view.bounds
        drawerView = UIVisualEffectView(frame: drawerViewBounds)
        
        
       drawerView = UIVisualEffectView(effect: UIBlurEffect(style: .Dark)) as UIVisualEffectView
        drawerView.frame = CGRectMake(0, 0, bounds.size.width, 650.0)
        scrollView.addSubview(drawerView)// Touches are broken here
        
        addDotts(25, toView:drawerView.contentView)// notice we ask for the contentview of the drawView beacuse its a uivisualEffectView and its blurring
       DotView.arrangeDotsNeatlyInView(drawerView.contentView)
        
        
        
        scrollView.contentSize = CGSizeMake(bounds.size.width, bounds.size.height + drawerView.frame.size.height)
        
        //To start off screen
        scrollView.contentOffset = CGPointMake(0, drawerView.frame.size.height)
  //      scrollView.userInteractionEnabled = false //turn off user interaction to allow touches to main view. Dots work but you cant scroll. To fix we will take the scroolview pan gesture and move it to another view. So we will move the scrollview panGest to our view
        
        
        
        
     //
        self.view.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        //lets add 20 dots to drawer
 //       addDotts(25, toView:drawerView.contentView)
        // notice we ask for the contentview of the scrool view
    //    DotView.arrangeDotsRandomlyInView(scrollView)
    
    
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  //HitTest
        
    
    
    
    func addDotts(count:NSInteger,toView view:UIView?){
        
            for index in 1...count {
            println("\(index) times 5 is \(index * 5)")
                      var shapeView = DotView()
           view?.addSubview(shapeView)
                let pressed =  UILongPressGestureRecognizer(target:self, action: "longPress:")
                pressed.cancelsTouchesInView = false //Keeps the press
                pressed.delegate = self//Hold Dots and scroll 1
                shapeView.addGestureRecognizer(pressed)
       
            
        }
            
        
    }
    
    func longPress(gesture:UIGestureRecognizer){
        //We are going to get the dot that was pressed by asking the gesture for its view
        let dot:UIView! = gesture.view as UIView!
        
        
        switch (gesture.state) {
            
        case UIGestureRecognizerState.Began:
            
            grabDot(dot, withGesture: gesture)
            
        case UIGestureRecognizerState.Changed:
            
            moveDot(dot, withGesture: gesture)
            
        case UIGestureRecognizerState.Ended,
            
            
        UIGestureRecognizerState.Cancelled:
                dropDot(dot, withGesture: gesture)
                
            
           default: break
           // otherwise, do something else
            
        }
        

        
        
        
    }

    func grabDot(dot:UIView, withGesture gesture:UIGestureRecognizer){
        
        dot.center = self.view.convertPoint(dot.center, fromView: dot.superview)
        //Anytime you reparent a view you Have to be carefuil that the origin of the new view IS the same as the origin of the old view
        
        
        self.view.addSubview(dot)
        //When u grab something you pull it to the front of everything over all of the rest of the content. We reparent the one that was grabbed and move it into the viewcontrollers view.
        
        
        
        //Make the dot a little bigger and alittle transparent to show that you grabbed it
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            dot.transform = CGAffineTransformMakeScale(1.2, 1.2)
            dot.alpha = 0.8
            self.moveDot(dot, withGesture: gesture)// notice self. in clousure
            //Calling this here stops the dot from jumping if its not first grabbed in the center. So it animates right away here. So it wouldnt have a jarring effect when they move their finger
        })
        scrollView.panGestureRecognizer.enabled = false
        scrollView.panGestureRecognizer.enabled = true
        //scroolview has somthinf called delaysContentTouches which causes quick scroll touches to not highlight but long touches to highlight like tableviews. It can be turned on to make touches go through without delay. ScrollViews have 3 gestureRecognizers
        //PanGestureRecognizer, pinchGestureRecognizer and TouchDeleayGestureRecognizer. TouchDeleayGestureRecognizer only livesto delay touches in scrollView.
        
        
        DotView.arrangeDotsNeatlyInViewWithNiftyAnimation(drawerView.contentView)
    }
    
    func moveDot(dot:UIView, withGesture gesture:UIGestureRecognizer){
        //What we want to do here is keep the dot under the user's finger. We set the dot to the center of the gesture in the view.
        dot.center = gesture.locationInView(self.view)
        
        
        
    }
    func dropDot(dot:UIView, withGesture gesture:UIGestureRecognizer){
        
        
        // To drop put in reverse
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            dot.transform = CGAffineTransformMakeScale(1.0, 1.0)
            dot.alpha = 1.0
        })
        
        //We have to determine where in the view hiarchy we are going to drop it. Are we putting it down in the drawer or in the canvas
        
        //We find out from the drawerView what is the location of the gesture
        let   locationIndrawer:CGPoint = gesture.locationInView(drawerView)
        
        //if the drawerView contains that location that means the dot has been dragged over the drawer
        if CGRectContainsPoint(drawerView.bounds, locationIndrawer){
            
            drawerView.contentView.addSubview(dot)
        } else{
            //Otherwise I add it to my canvas
            canvasView.addSubview(dot)
                }
         dot.center = self.view.convertPoint(dot.center, fromView: dot.superview)
        DotView.arrangeDotsNeatlyInViewWithNiftyAnimation(drawerView.contentView)
        
    }

    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true //We can do this safely here because its a small app
    }

}