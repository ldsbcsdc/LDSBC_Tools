//
//  FeedbackViewController.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/13/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var feedbackForm: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Embed feedback form into the view.
        UIWebView.loadRequest(feedbackForm)(NSURLRequest(URL: NSURL(string: "https://docs.google.com/a/ldsbc.edu/forms/d/1PGgxSl2w9vsp4cq5jxii5Y6AOgCfCJ75o527xOrXD4U/viewform")!))
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
