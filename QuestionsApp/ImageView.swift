//
//  ImageView.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit

extension UIImageView{

    func setImageFromURl(stringImageUrl url: String){

        if let url = NSURL(string: url) {
            if let data = NSData(contentsOfURL: url) {
                self.image = UIImage(data: data)
            }
        }
    }
}

extension NSURL {
    func getQueryItemValueForKey(key: String) -> String? {
        guard let components = NSURLComponents(URL: self, resolvingAgainstBaseURL: false) else {
            return nil
        }

        guard let queryItems = components.queryItems else { return nil }
        return queryItems.filter {
            $0.name == key
            }.first?.value
    }
}