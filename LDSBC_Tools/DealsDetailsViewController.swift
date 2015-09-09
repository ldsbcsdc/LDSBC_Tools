//
//  DealsDetailsViewController.swift
//  BC Tools
//
//  Created by Riley Hooper on 7/14/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import Parse

class DealsDetailsViewController: UIViewController {
    
    @IBOutlet weak var dealImage: UIImageView!
    
    @IBOutlet weak var dealTitle: UILabel!
    
    @IBOutlet weak var dealDescription: UILabel!
    
    @IBOutlet weak var companyLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var startLabel: UILabel!
    
    // Class variables.
    var currentDeal : deal?
    var startDate = NSDate()
    var endDate = NSDate()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create format for date.
        let dateFormatter = NSDateFormatter()
        // Create format for time.
        let timeFormatter = NSDateFormatter()
        // Set custom style.
        dateFormatter.dateFormat = "MMM d"
        //timeFormatter.dateFormat = "h:mm a"
        // Set time zone.
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: +0)
        timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: +0)
        
        
        // Create date from parse object.
        startDate = currentDeal!.startDate
        endDate = currentDeal!.endDate
        // Create string with start and end time.
        let stringDate = dateFormatter.stringFromDate(startDate) + " to " + dateFormatter.stringFromDate(endDate)
        
        // Cast image from PFFile to UIImage.
        currentDeal?.image.getDataInBackgroundWithBlock {(date, error) -> Void in
            if let dealImage = UIImage(data: date!) {
                self.dealImage.image = dealImage
            }
        }
        
        // Fill the fields in the view with data from the passed object.
        dealTitle.text = currentDeal?.title
        // description background color is 388E3C on Android.
        dealDescription.text = currentDeal?.description
        companyLabel.text = currentDeal!.company
        addressLabel.text = currentDeal?.address
        startLabel.text = stringDate
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
