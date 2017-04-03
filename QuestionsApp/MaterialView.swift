//
//  MaterialView.swift
//  DreamLister
//
//  Created by ricardo silva on 20/02/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit

private var materialKey = false
private var cornerRadius = 0.0

extension UIView {


    @IBInspectable var cornerRadiusDesign: Double {

        get {
            return cornerRadius
        }

        set {
            cornerRadius = newValue
        }

    }

    @IBInspectable var materialDesign: Bool {

        get {
            return materialKey
        }
        set {
            materialKey = newValue

            if materialKey {
                self.layer.masksToBounds = false
                self.layer.cornerRadius = CGFloat(cornerRadiusDesign)
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).CGColor
            } else {
                self.layer.cornerRadius = 0
                self.layer.shadowOpacity = 0
                self.layer.shadowRadius = 0
                self.layer.shadowColor = nil

            }
        }
    }

}
