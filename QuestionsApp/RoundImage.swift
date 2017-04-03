//
//  RoundImage.swift
//  LocalScore
//
//  Created by ricardo silva on 27/02/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit

class RoundImage: UIImageView {

    override func awakeFromNib() {
        self.layer.cornerRadius = self.frame.size.width / 2;
        self.clipsToBounds = true
    }


}
