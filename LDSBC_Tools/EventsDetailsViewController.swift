//
//  EventsDetailsViewController.swift
//  LDSBC_Tools
//
//  Created by  Riley Hooper on 5/30/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
import Foundation

class EventsDetailsViewController: UIViewController, EKEventEditViewDelegate {

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    // Image icons outlets.
    
    // Class variables.
    // Object to hold data from parent view controller.
    var currentEvent : event?
    var startDate = NSDate()
    var endDate = NSDate()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create format for date.
        let dateFormatter = NSDateFormatter()
        // Create format for time.
        let timeFormatter = NSDateFormatter()
        // Set custom style.
        dateFormatter.dateFormat = "MMM d, h:mm a"
        timeFormatter.dateFormat = "h:mm a"
        // Set time zone.
        dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: +0)
        timeFormatter.timeZone = NSTimeZone(forSecondsFromGMT: +0)
        
        
        // Create date from object.
        startDate = currentEvent!.startDate
        endDate = currentEvent!.endDate
        // Create string with start and end time.
        let stringDate = dateFormatter.stringFromDate(startDate) + " to " + timeFormatter.stringFromDate(endDate)
        // Set labels with values from object.
        namelabel.text = currentEvent?.name
        descriptionLabel.text = currentEvent?.description
        dateTimeLabel.text = stringDate
        locationLabel.text = currentEvent?.location
        
        // Cast image from PFFile to UIImage.
        currentEvent?.image.getDataInBackgroundWithBlock {(date, error) -> Void in
            if let image = UIImage(data: date!) {
                self.image.image = image
            }
        }
    }

    // Add to calendar button.
    @IBAction func addToCalendar(sender: AnyObject) {
        
        var eventController = EKEventEditViewController()
        var editViewDelegate: EKEventEditViewDelegate!
        var store = EKEventStore()
        eventController.eventStore = store
        eventController.editViewDelegate = self

        // create event with data from object.
        var event = EKEvent(eventStore: store)
        event.title = currentEvent?.name
        event.startDate = currentEvent?.startDate.dateByAddingTimeInterval(21600)
        event.endDate = currentEvent?.endDate.dateByAddingTimeInterval(21600)
        event.location = currentEvent?.location
        event.notes = currentEvent?.description
        eventController.event = event

        // Check authorization.
        var status = EKEventStore.authorizationStatusForEntityType(EKEntityTypeEvent)
        switch status {
        case .Authorized:
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.presentViewController(eventController, animated: true, completion: nil)
            })

        case .NotDetermined:
            store.requestAccessToEntityType(EKEntityTypeEvent, completion: { (granted, error) -> Void in
                if granted == true {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.presentViewController(eventController, animated: true, completion: nil)
                    })
                }
            })
            
        case .Denied, .Restricted:
            UIAlertView(title: "Access Denied", message: "Permission is needed to access the calendar. Go to Settings > Privacy > Calendars to allow access for the Be Collective app.", delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
    }
    
    
    @IBAction func websiteButton(sender: AnyObject) {
    }
    
    
    
    // Function to handle the actions from the EventEditViewController.
    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction){
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Error pop up window.
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { ACTION in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
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
