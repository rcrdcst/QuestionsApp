//
//  Utils.swift
//  QuestionsApp
//
//  Created by ricardo silva on 03/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit

func loadBlurView(view: UIView){
    if !UIAccessibilityIsReduceTransparencyEnabled() {
        //self.view.backgroundColor = UIColor.clearColor()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurEffectView.tag = 100

        let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
        label.textColor = UIColor.whiteColor()
        label.center = view.center
        label.textAlignment = NSTextAlignment.Center
        label.text = "No Connection Available!"
        blurEffectView.addSubview(label)


        view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
    }
}
