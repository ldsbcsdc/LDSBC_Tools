//
//  DirectoryDetailsViewController.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/27/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import MessageUI

class DirectoryDetailsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    // Button outlets.
    @IBOutlet weak var departNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var phoneButtonLabel: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var websiteButton: UIButton!
    
    // Image icons outlets.
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var websiteImage: UIImageView!
    
    // Constraints outlets.
    @IBOutlet weak var locationTop: NSLayoutConstraint!
    @IBOutlet weak var phoneTop: NSLayoutConstraint!
    @IBOutlet weak var emailTop: NSLayoutConstraint!
    
    // Height constraints
    @IBOutlet weak var locationHeight: NSLayoutConstraint!
    @IBOutlet weak var phoneHeight: NSLayoutConstraint!
    @IBOutlet weak var emailHeight: NSLayoutConstraint!
    
    
    
    
    // Class variables.
    //object to hold data from parent view controller.
    var currentDepart : department?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Transfer data from parse object to page fields.
        departNameLabel.text = currentDepart?.name
        descriptionLabel.text = currentDepart?.description
        
        // Location. Display only if field has content.
        if currentDepart?.location != "" {
            locationLabel.text = currentDepart?.location
            locationLabel.hidden = false
            locationIcon.hidden = false
        } else {
            locationLabel.hidden = true
            locationIcon.hidden = true
            locationHeight.constant = 0
            locationTop.constant = 0
        }
        
        // Phone Button. Display only if field has content.
        if currentDepart?.phone != "" {
            phoneButtonLabel.setTitle(currentDepart?.phone, forState: UIControlState.Normal)
            phoneButtonLabel.hidden = false
            phoneIcon.hidden = false
        } else {
            phoneButtonLabel.hidden = true
            phoneIcon.hidden = true
            phoneHeight.constant = 0
            phoneTop.constant = 0
        }
        
        // Email button. Display only if field has content.
        if currentDepart?.email != "" {
            emailButton.setTitle(currentDepart?.email, forState: UIControlState.Normal)
            emailButton.hidden = false
            emailIcon.hidden = false
        } else {
            emailButton.hidden = true
            emailIcon.hidden = true
            emailTop.constant = 0
            emailHeight.constant = 0
        }
        
        // Website button. Display only if field has content.
        if currentDepart?.website == "" {
            websiteButton.hidden = true
            websiteImage.hidden = true
        } else {
            websiteButton.hidden = false
            websiteImage.hidden = false
        }
        
    }

    // Call button.
    @IBAction func callButton(sender: AnyObject) {
        // Call the "callNumber" method.
        callNumber("\(currentDepart!.phone)")
    }
    
    // Email button.
    @IBAction func emailDepartment(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    // Website button.
    @IBAction func launchWebsite(sender: AnyObject) {
        getLink("\(currentDepart!.website)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call method.
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string:"tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    // Email method.
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([currentDepart!.email as String])
        // mailComposerVC.setSubject("Sending you an in-app e-mail...")
        // mailComposerVC.setMessageBody("Sending e-mail in-app is not so bad!", isHTML: false)
        
        return mailComposerVC
    }
    
    // Link method.
    func getLink(linkString: String) {
        let targetURL = NSURL(string: linkString)
        let application = UIApplication.sharedApplication()
        application.openURL(targetURL!);
    }
    
    // Email error method.
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
/////////////
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


