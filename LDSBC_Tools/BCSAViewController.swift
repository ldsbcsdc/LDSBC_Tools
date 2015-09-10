//
//  BCSAViewController.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/13/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import MediaPlayer

class BCSAViewController: UIViewController {
    
    // Class variables.
    var moviePlayer:MPMoviePlayerController!
    var linkString = ""

    @IBOutlet weak var scrollView: UIScrollView!
    
    // play Get involved video.
    @IBAction func playVideo(sender: AnyObject) {
        let targetURL = NSURL(string: "http://bcmessenger.com/wp-content/uploads/2014/09/Student_Involvement_condesnsed_02.mp4?_=1")
        let application = UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }
    
    // Link to BCMessenger website.
    @IBAction func bcMessenger(sender: AnyObject) {
        getLink("http://bcmessenger.com/")
    }
    
    // Link to Marketing request form.
    @IBAction func marketingForm(sender: AnyObject) {
        getLink("https://app.smartsheet.com/b/form?EQBCT=673583d1ff9b41babe313d9a2f73d341")
    }
    
    // Link to BCSA page on FaceBook.
    @IBAction func fbBCSA(sender: AnyObject) {
        
        let facebookURL = NSURL(string: "fb://profile/620248604755560")!
        if UIApplication.sharedApplication().canOpenURL(facebookURL) {
            // Open in native Facebook app.
            UIApplication.sharedApplication().openURL(facebookURL)
        } else {
            // Open in web browser if Facebook app is not installed.
            UIApplication.sharedApplication().openURL(NSURL(string: "https://www.facebook.com/ldsbcsa")!)
        }
    }
    
    // Link to Club application form.
    @IBAction func clubApplication(sender: AnyObject) {
        getLink("https://docs.google.com/a/ldsbc.edu/forms/d/1glk2fRRRkHvzIgalqhTFeA946BmTUluwul1cT5DVNfI/viewform")
    }
    
    // Link to Activity request form.
    @IBAction func activityRequest(sender: AnyObject) {
        getLink("https://docs.google.com/a/ldsbc.edu/forms/d/18vzBKPuAjJgZYvlWvPJ2TLqUNBSu2GebEmNtfBL8V1c/viewform")
    }
    
    // Link to Student Mentor form.
    @IBAction func StudentMentor(sender: AnyObject) {
        getLink("https://docs.google.com/a/ldsbc.edu/forms/d/1m9kEzCOASM1agdmP4QqVyakg1KOTPn5EzoUdhhVuCAo/viewform")
    }
    
    // Link to Feedback form.
    @IBAction func ideasFeedback(sender: AnyObject) {
        getLink("https://docs.google.com/a/ldsbc.edu/forms/d/1hzaCk2J-7u6Y0If-QTUQXPOIdQCbsYnWg-6lF5jKa1Y/viewform")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Link method for all buttons.
    func getLink(linkString: String) {
        let targetURL = NSURL(string: linkString)
        let application = UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
