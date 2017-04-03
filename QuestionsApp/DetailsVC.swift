//
//  DetailsVC.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit
import Charts
import SCLAlertView

class DetailsVC: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var choiceList = [String]()
    var votes = [Double]()
    var question: Question!
    @IBOutlet weak var questionImg: UIImageView!
    @IBOutlet weak var questionNameLbl: UILabel!

    override func viewDidLoad() {
        let choices = question.choices
        for choice in choices {
            choiceList.append(choice["choice"].stringValue)
            votes.append(choice["votes"].doubleValue)
        }
        barChartView.descriptionText = ""
        barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
        barChartView.xAxis.labelPosition = .BottomInside
        barChartView.xAxis.labelRotationAngle = 270
        barChartView.legend.enabled = false
        setChart(choiceList, values: votes)

        questionImg.setImageFromURl(stringImageUrl: question.imgURL)
        questionNameLbl.text = question.title

    }


    func setChart(dataPoints: [String], values: [Double]) {
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "Total Votes")
        let chartData = BarChartData(xVals: choiceList, dataSet: chartDataSet)
        barChartView.data = chartData
        chartDataSet.colors = ChartColorTemplates.colorful()
        
    }
    @IBAction func shareEmail(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false
        )

        let alert = SCLAlertView(appearance: appearance)
        let txt = alert.addTextField("Enter the Email")
        alert.addButton("Send Email") {
            if let email = txt.text {
                if self.isValidEmail(email){
                    let url = "\(SHARE_URL)\(email)&blissrecruitment://questions?question_id=\(self.question.id)"
                    APIService.instance.shareQuestion(url)
                } else {
                    let banner = Banner(title: "Invalid Email", subtitle: "Try again", image: UIImage(named: "Thumbs Down"), backgroundColor: UIColor(red:0.80, green:0.15, blue:0.15, alpha:1.0))
                    banner.dismissesOnTap = true
                    banner.show(duration: 1.5)
                }
            } else{
                let banner = Banner(title: "Could not send the email", subtitle: "The Field is Empty", image: UIImage(named: "Thumbs Down"), backgroundColor: UIColor(red:0.80, green:0.15, blue:0.15, alpha:1.0))
                banner.dismissesOnTap = true
                banner.show(duration: 1.5)
            }

        }
        alert.showEdit("Share Via Email", subTitle: "Share this Question Details via Email")
    }

    @IBAction func doneBtnPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true) { 

        }
    }
    @IBAction func voteBtnPressed(sender: AnyObject) {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!
        )

        // Initialize SCLAlertView using custom Appearance
        let alert = SCLAlertView(appearance: appearance)


        alert.addButton("Vote Swift") {
            self.updateVoteAndSend(0)
        }
        alert.addButton("Vote Python") {
            self.updateVoteAndSend(1)
        }
        alert.addButton("Vote Objective-c") {
            self.updateVoteAndSend(2)
        }
        alert.addButton("Vote Ruby") {
            self.updateVoteAndSend(3)
        }
        alert.showNotice("Choose a Language", subTitle: "Vote in your favorite language", closeButtonTitle: "Close", duration: 0, colorStyle: 0xD21414, colorTextButton: 0xFFFFFF, circleIconImage: UIImage(named: "Thumbs Up"), animationStyle: .TopToBottom)
    }

    func updateVoteAndSend(voteID: Int){
        let votesCount = self.question.choices[voteID]["votes"].doubleValue
        self.question.choices[voteID]["votes"].doubleValue = (votesCount + 1.0)
        APIService.instance.updateVotes(self.question.createJSON(), id: question.id)
    }

    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"

        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
}
