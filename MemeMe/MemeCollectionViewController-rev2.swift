//
//  MemeCollectionViewController-rev2.swift
//  MemeMe
//
//  Created by Jon on 9/16/16.
//  Copyright © 2016 jonbrown. All rights reserved.
//

import UIKit

class MemeCollectionViewController_rev2: UICollectionViewController {

    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var selectedCell = 0
    
    // get memes array from app delegate
    
    var memes: [Meme]
    {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        collectionView?.backgroundView?.contentMode = UIViewContentMode.ScaleAspectFill
        
        // flow layout
        
        let space: CGFloat = 3.0
        let dimension = (self.view.frame.size.width - (2 * space)) / 3
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        // make sure collection view reloads app delegate memes array 
        
        collectionView?.reloadData()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int
    {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        // use array to set number of cells in the single main section
        
        return memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> CustomMemeCell
    {
        // create UICollectionViewCell with image
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CustomMemeCell", forIndexPath: indexPath) as! CustomMemeCell
        let meme = memes[indexPath.item]
        cell.setText(meme.topText, bottomText: meme.bottomText)
        
        let imageView = UIImageView(image: meme.image)
        imageView.contentMode = .ScaleAspectFill
        cell.backgroundView = imageView
        
        return cell
    }
    
    // MARK: - collection view selection
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
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
