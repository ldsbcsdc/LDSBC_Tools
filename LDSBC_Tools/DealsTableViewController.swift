//
//  FoodTableViewController.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/13/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import Parse

class DealsTableViewController: UITableViewController {
    
    // Class variables.
    var deals = [deal]()
    // Create format for date.
    let dateFormatter = NSDateFormatter()
    // Create activityIndicator.
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add refresh function to view controller.
        self.refreshControl?.addTarget(self, action: "loadData:", forControlEvents: UIControlEvents.ValueChanged)

        // Start ActivityIndicator to show loading.
        self.startActivityIndicator()
        
        // Call loadData method to fill table with data on load.
        loadData(self)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return deals.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let myCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! Cell // "Cell" is the custom UITableViewCell class created in "Cell.swift" file.
        
        var currentDeal = deals[indexPath.row]
        
        // Get image from parse and set it to the cell image.
        currentDeal.image.getDataInBackgroundWithBlock {(date, error) -> Void in
            if let dealImage = UIImage(data: date!) {
                myCell.dealImage.image = dealImage
            }
        }
        // Set cell title.
        myCell.dealTitle.text = currentDeal.title
        
        
        return myCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Activate segue when row is touched.
        self.performSegueWithIdentifier("dealDetails", sender: parentViewController)
    }
    
    // Hide tab bar in child view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dealDetails"{
            // Hide tab bar in child view.
            let bottomBar = segue.destinationViewController as! UIViewController
            bottomBar.hidesBottomBarWhenPushed = true
            
            
            // Get the new view controller using [segue destinationViewController].
            var secondScene = segue.destinationViewController as! DealsDetailsViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let selectedObject = deals[indexPath.row]
                secondScene.currentDeal = selectedObject
            }
        }
        
        
    }
    
    // Method for querying Parse.
    func loadData(sender:AnyObject) {
        
        // Create query to add titles of PFObjects into array.
        var query = PFQuery(className: "deals")
        // Set limit and ordering of query.
        //query.limit = 1000
        query.orderByAscending("startDate")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // Clear arrays before adding data.
                self.deals.removeAll(keepCapacity: true)
                
                if let objects = objects as? [PFObject] {
                    // Loop through all objects.
                    for object in objects {
                        // Create local object with data from Parse object.
                        var newDeal = deal(
                            image : (object.objectForKey("image") as! PFFile),
                            title : (object.objectForKey("title") as! String),
                            description : (object.objectForKey("description") as! String),
                            company : (object.objectForKey("company") as! String),
                            address : (object.objectForKey("address") as! String),
                            startDate : (object.objectForKey("startDate") as! NSDate),
                            endDate : (object.objectForKey("endDate") as! NSDate))
                        
                        // Set custom style.
                        self.dateFormatter.dateFormat = "MMMM, d, h:mm a"
                        
                        // Set time zone.
                        self.dateFormatter.timeZone = NSTimeZone(forSecondsFromGMT: -21600)
                        // current date and time.
                        var date = NSDate()
                        // end time of the event
                        var dateOfEvent: NSDate = object.objectForKey("endDate") as! NSDate
                        // Set proper time zone. Minus 6 hours from UTC for Mountain Standard time.
                        date = NSDate(timeIntervalSinceNow: -21600)
                        
                        // Compare current date and end date.
                        var dateComparisonResult:NSComparisonResult = date.compare(dateOfEvent)
                        // Only display the upcoming events.
                        if dateComparisonResult == NSComparisonResult.OrderedAscending {
                            // Add object to object array
                            self.deals.append(newDeal)
                        }
                    }
                }
                self.stopActivityIndicator()
            } else {
                // stop activityIndicator
                self.stopActivityIndicator()
                var alert = UIAlertController(title: "Cannot Get Deals", message: "No Internet connection available.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                println(error)
            }
            // Reload table view.
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }) 
    }

    
    // Error pop up window.
    func displayAlert(title:String, error:String) {
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { ACTION in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    // Start activityIndicator
    func startActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        //UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
    
    // Stop activityIndicator
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        //UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
