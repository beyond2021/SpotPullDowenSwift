//
//  OverlayScrollView.swift
//  SpotPullDowenSwift
//
//  Created by KEEVIN MITCHELL on 11/7/14.
//  Copyright (c) 2014 Beyond 2021. All rights reserved.
// The purpose of this class is to not return itself

import UIKit

class OverlayScrollView: UIScrollView {

    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView is UIScrollView {
            return nil
        }
        
        //3
        return hitView
    }

}
