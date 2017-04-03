//
//  ViewController.swift
//  QuestionsApp
//
//  Created by ricardo silva on 02/04/2017.
//  Copyright © 2017 ricardo silva. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import PullToRefresh
import SCLAlertView
import Reachability

class HomeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var questionsTableView: UITableView!

    var questions = [Question]()
    let refresher = PullToRefresh()
    var currentCell: NSIndexPath?
    var searchBarText: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        questionsTableView.delegate = self
        questionsTableView.dataSource = self
        searchBar.delegate = self

        loadindData()

        let reachability: Reachability
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
            return
        }

        reachability.reachableBlock = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                if reachability.isReachableViaWiFi() {
                    self.loadindData()
                    print("Reachable via WiFi")
                } else {
                    self.loadindData()
                    print("Reachable via Cellular")
                }
            }
        }
        reachability.unreachableBlock = { reachability in
            dispatch_async(dispatch_get_main_queue()) {
                self.loadBlurView()
            }
        }
        
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }

    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }

    func loadindData(){
        self.questionsTableView.addPullToRefresh(self.refresher) {
            APIService.instance.getAllQuestions({ (questions) in
                self.questions += questions
                self.questionsTableView.reloadData()
                self.questionsTableView.endRefreshing(at: .Top)
            })
        }

        self.startActivityIndicator()
        let group = dispatch_group_create()
        dispatch_group_enter(group)
        APIService.instance.checkServerHealth(group) { (result) in
            if result {
                APIService.instance.getAllQuestions({ (questions) in
                    self.questions = questions
                    self.questionsTableView.reloadData()
                    if let txt = self.searchBarText {
                        self.searchBar.text = txt
                        self.searchArray(txt)
                    }
                })
                self.view.viewWithTag(100)?.removeFromSuperview()
            } else {
                self.loadBlurView()
            }
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.stopActivityIndicator()
        }
    }

    func loadBlurView(){
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            //self.view.backgroundColor = UIColor.clearColor()

            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
            blurEffectView.tag = 100

            let label = UILabel(frame: CGRectMake(0, 0, 200, 21))
            label.textColor = UIColor.whiteColor()
            label.center = CGPointMake(160, 284)
            label.textAlignment = NSTextAlignment.Center
            label.text = "No Connection Available!"
            blurEffectView.addSubview(label)


            self.view.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
    }


    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.questions.removeAll()
            APIService.instance.filterQuestions(searchText, completion: { (questions) in
                self.questions = questions
                self.questionsTableView.reloadData()
            })

        }
        searchArray(searchText)
    }

    func searchArray(searchText: String){
        questions = questions.filter { (question) -> Bool in
            return question.title.lowercaseString.containsString(searchText.lowercaseString)
        }

        self.questionsTableView.reloadData()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = questionsTableView.dequeueReusableCellWithIdentifier("question", forIndexPath: indexPath) as? QuestionCell {
            cell.configureCell(questions[indexPath.row])
            return cell
        }
            
        return UITableViewCell()
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = questionsTableView.indexPathForSelectedRow!
        currentCell = indexPath

        performSegueWithIdentifier("details", sender: self)
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }




    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "details") {
            // initialize new view controller and cast it as your view controller
            //let viewController = segue.destinationViewController as! DetailsVC
            let nav = segue.destinationViewController as! UINavigationController
            let addEventViewController = nav.topViewController as! DetailsVC
            // your new view controller should have property that will store passed value
            if let index = currentCell?.row {
                addEventViewController.question = questions[index]
            }

        }
    }


    func startActivityIndicator() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White

        // Change background color and alpha channel here
        activityIndicator.backgroundColor = UIColor.blackColor()
        activityIndicator.clipsToBounds = true
        activityIndicator.alpha = 0.5

        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }

    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }



}

