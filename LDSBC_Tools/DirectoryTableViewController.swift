//
//  DirectoryTableViewController.swift
//  LDSBC_Tools
//
//  Created by Riley Hooper on 5/13/15.
//  Copyright (c) 2015 LDS BC. All rights reserved.
//

import UIKit
import Parse

class DirectoryTableViewController: UITableViewController {
    
    // Class variables
    var departments = [department]()
    
    // Create activityIndicator.
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
         return departments.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var currentDepart = departments[indexPath.row]
        cell.textLabel?.text = currentDepart.name

        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Activate segue when row is touched.
        self.performSegueWithIdentifier("dirDetails", sender: parentViewController)
    }
    
    
    // Hide tab bar in child view.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dirDetails"{
            // Hide tab bar in child view.
            let bottomBar = segue.destinationViewController as! UIViewController
            bottomBar.hidesBottomBarWhenPushed = true
        
            // Get the new view controller using [segue destinationViewController].
            var secondScene = segue.destinationViewController as! DirectoryDetailsViewController
            
            // Pass the selected object to the new view controller.
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let selectedDepart = departments[indexPath.row]
                secondScene.currentDepart = selectedDepart
            }
        }
    }

    // Method for querying Parse.
    func loadData(sender: AnyObject) {

        // Create query to add titles of PFObjects into array.
        var query = PFQuery(className: "serviceDirectory")
        // Set limit and ordering of query.
        //query.limit = 1000
        query.orderByAscending("serviceName")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // Clear array before adding data.
                self.departments.removeAll(keepCapacity: true)
                
                if let objects = objects as? [PFObject] {
                    // Loop through all objects.
                    for object in objects {
                        // Create local object with data from Parse object.
                        var newDepartment = department(
                            name : (object.objectForKey("serviceName") as? String)!,
                            description : (object.objectForKey("description") as? String)!,
                            location : (object.objectForKey("Location") as? String)!,
                            phone : (object.objectForKey("phone") as? String)!,
                            email : (object.objectForKey("email") as? String)!,
                            website : (object.objectForKey("website") as? String)!)
                        // Add object to object array
                        self.departments.append(newDepartment)
                    }
                }
                self.stopActivityIndicator()
            } else {
                // stop activityIndicator
                self.stopActivityIndicator()
                var alert = UIAlertController(title: "Cannot Load Directory", message: "No Internet connection available.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
           
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
    

}




