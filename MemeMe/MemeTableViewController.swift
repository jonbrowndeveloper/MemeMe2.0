//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Jon on 9/29/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {

    var selectedCell = 0
    
    // get memes array from AppDelegate
    
    var memes: [Meme]
    {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return memes.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> CustomMemeTVCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("tvCell", forIndexPath: indexPath) as! CustomMemeTVCell
        
        let meme = memes[indexPath.item]
        
        cell.imageView?.image = meme.image
        
        cell.setCellProperties(meme.topText, bottomText: meme.bottomText)
        
        return cell
    }
    
    // MARK: - Table view selection
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        selectedCell = indexPath.row
        
        self.performSegueWithIdentifier("toDetailView", sender: self)
    }

    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if (segue.identifier == "toDetailView")
        {
            if let detailViewController = segue.destinationViewController as? MemeDetailViewController
            {
                detailViewController.meme = memes[selectedCell]
                
                detailViewController.memePosition = selectedCell
            }
        }
    }
    
}
