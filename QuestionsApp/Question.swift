//
//  Question.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit
import SwiftyJSON

class Question {

    var id: Int
    var thumbURL: String
    var title: String
    var time: String
    var choices: [JSON]
    var imgURL: String

    init(id: Int, thumbURL: String, title: String, time: String, choices: [JSON], imgURL: String) {
        self.id = id
        self.thumbURL = thumbURL
        self.title = title
        self.time = time
        self.choices = choices
        self.imgURL = imgURL
    }

    func createJSON() -> JSON{
        let json = JSON(choices)

        var teste: JSON = 	[
            "id": self.id,
            "image_url": self.imgURL,
            "thumb_url": self.thumbURL,
            "question": self.title,
            "choices": json.arrayObject!
        ]
        return teste
    }
}
