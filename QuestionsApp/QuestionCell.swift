//
//  QuestionCell.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    
    @IBOutlet weak var questionImgView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!


    func configureCell(question: Question) {
        questionImgView.setImageFromURl(stringImageUrl: question.imgURL)
        titleLbl.text = question.title
        timeLbl.text = question.time
    }

}
