//
//  DetailsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/20/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class DetailsTabBarController: UITabBarController {
    
    var data = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //title icon code
        var titleicon: UIImage!
        titleicon = UIImage(named:"logo1-small")
        let titleview = UIImageView(image:titleicon)
        titleview.frame = (frame: CGRect(x: 140, y: -20, width: 50, height: 40))
        self.navigationItem.titleView = titleview
        
        let dataDictionary: NSDictionary = (data[0] as? NSDictionary)!
        //println("Data: \(dataDictionary)")
        
        var reviews = dataDictionary["reviews"] as! NSDictionary
        var similar = dataDictionary["similar"] as! NSDictionary
        var similarArray = similar["results"] as! NSArray
        
        
        // Passing desired data onto tab bar view controllers
        let detailViewControllers = self.viewControllers

        let overviewController = detailViewControllers![0] as! OverviewViewController
        let reviewController = detailViewControllers![1] as! CommentsViewController
        let similarController = detailViewControllers![2] as! SimilarViewController
        
        
        reviewController.reviewData = reviews
        overviewController.dataDictionary = dataDictionary
        similarController.suggestionsData = similarArray
        
        // Do any additional setup after loading the view.
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
