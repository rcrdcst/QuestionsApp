//
//  APIService.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class APIService {

    private static let _instance = APIService()
    var totalRows = 0

    static var instance: APIService {
        return _instance
    }


    func checkServerHealth(group: dispatch_group_t, completion: (result: Bool) -> Void) {
        Alamofire.request(.GET, HEALTH_URL).validate().responseJSON { response in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let status = json["status"].stringValue
                if status == "OK" {
                    let banner = Banner(title: "Server is UP and Running", subtitle: "Let´s see the rest of the app!!", image: UIImage(named: "Thumb Up"), backgroundColor: UIColor(red:0.09, green:0.68, blue:0.12, alpha:1.0))
                    banner.dismissesOnTap = true
                    banner.show(duration: 1.5)
                }
                completion(result: true)
                dispatch_group_leave(group)
            case .Failure( _):
                let banner = Banner(title: "Cant Connect to the Server", subtitle: "Please try again later", image: UIImage(named: "Thumbs Down"), backgroundColor: UIColor(red:0.80, green:0.15, blue:0.15, alpha:1.0))
                banner.dismissesOnTap = true
                banner.show(duration: 1.5)
                dispatch_group_leave(group)
                completion(result: false)
            }
        }
    }

    func getAllQuestions(completion: (result: [Question]) -> Void) {
        Alamofire.request(.GET, "\(ALL_QUESTIONS_URL)\(NUMBER_ROWS)&\(totalRows)&").validate().responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                var questionsArr = [Question]()
                let questions = JSON(data)
                for question in questions {
                    let id = question.1["id"].int
                    let thumbURL = question.1["thumb_url"].string
                    let title = question.1["question"].string
                    let time = question.1["published_at"].string
                    let choices = question.1["choices"].array
                    let imgURL = question.1["image_url"].string
                    let quesionObj = Question(id: id!, thumbURL: thumbURL!, title: title!, time: time!, choices: choices!, imgURL: imgURL!)
                    questionsArr.append(quesionObj)
                }
                self.totalRows = self.totalRows + 10
                completion(result: questionsArr)
            case .Failure(let error):
                print(error)
            }
        }
    }


    func filterQuestions(filter: String,completion: (result: [Question]) -> Void) {
        Alamofire.request(.GET, "\(ALL_QUESTIONS_URL)&&\(filter)").validate().responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                var questionsArr = [Question]()
                let questions = JSON(data)
                for question in questions {
                    let id = question.1["id"].int
                    let thumbURL = question.1["thumb_url"].string
                    let title = question.1["question"].string
                    let time = question.1["published_at"].string
                    let choices = question.1["choices"].array
                    let imgURL = question.1["image_url"].string
                    let quesionObj = Question(id: id!, thumbURL: thumbURL!, title: title!, time: time!, choices: choices!, imgURL: imgURL!)
                    questionsArr.append(quesionObj)
                }
                completion(result: questionsArr)
            case .Failure(let error):
                print(error)
            }
        }
    }

    func getQuestion(id: Int, completion: (result: Question) -> Void){
        Alamofire.request(.GET, "\(SINGLE_QUESTION)\(id)").validate().responseJSON { (response) in
            switch response.result {
            case .Success(let data):
                let question = JSON(data)
                    let id = question["id"].int
                    let thumbURL = question["thumb_url"].string
                    let title = question["question"].string
                    let time = question["published_at"].string
                    let choices = question["choices"].array
                    let imgURL = question["image_url"].string
                    let singleQuestion = Question(id: id!, thumbURL: thumbURL!, title: title!, time: time!, choices: choices!, imgURL: imgURL!)
                    completion(result: singleQuestion)

            case .Failure(let error):
                print(error)
            }
        }
    }

    func shareQuestion(url: String) {
        Alamofire.request(.POST, url).validate().responseJSON(completionHandler: { (response) in
            switch response.result {
            case .Success(let data):
                let json = JSON(data)
                let status = json["status"].stringValue
                if status == "OK" {
                    let banner = Banner(title: "Email sent with success", subtitle: "", image: UIImage(named: "Thumb Up"), backgroundColor: UIColor(red:0.09, green:0.68, blue:0.12, alpha:1.0))
                    banner.dismissesOnTap = true
                    banner.show(duration: 2.0)
                }
            case .Failure(let _):
                let banner = Banner(title: "Failed to send the email", subtitle: "Please try again later", image: UIImage(named: "Thumbs Down"), backgroundColor: UIColor(red:0.80, green:0.15, blue:0.15, alpha:1.0))
                banner.dismissesOnTap = true
                banner.show(duration: 2.0)
            }
        })
    }


    func updateVotes(values: JSON, id: Int){
        let url = NSURL(string: "\(UPDATE_VOTE)\(id)")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let x = try? values.rawData()
        request.HTTPBody = x

        Alamofire.request(request)
            .responseJSON { response in
                // do whatever you want here
                switch response.result {
                case .Failure(let error):
                    print(error)

                    // if web service reports error, sometimes the body of the response
                    // includes description of the nature of the problem, e.g.

                    if let data = response.data, let responseString = String(data: data, encoding: NSUTF8StringEncoding) {
                        print(responseString)
                    }
                case .Success(let responseObject):
                    print(responseObject)
                }
        }
    }


}