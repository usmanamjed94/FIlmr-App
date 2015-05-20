//
//  CommentsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/20/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var reviewData: NSDictionary = NSDictionary()
    var reviewObject: NSArray = NSArray()
    var reviewCount: Int?
    var noReviewLabel: UILabel!
    var myMutableSentence: NSMutableAttributedString?
    
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reviewCount = reviewData["total_results"] as! Int
        
        
        self.view.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)
        self.commentsTableView.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)
        configureTableView()
        
        if (reviewCount! == 0)
        {
            commentsTableView.hidden = true
            noReviewLabel = UILabel(frame: CGRectMake(0, 0, 300, 200))
            noReviewLabel.center = CGPointMake(210, 300)
            noReviewLabel.textAlignment = NSTextAlignment.Left
            noReviewLabel.text = "SORRY! NO REVIEWS OF THE SELECTED MOVIE COULD BE FOUND!"
            noReviewLabel.font = UIFont.boldSystemFontOfSize(26.0)
            noReviewLabel.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
            noReviewLabel.numberOfLines = 4
            
            myMutableSentence = NSMutableAttributedString(string: noReviewLabel.text!)
            
            // Color coding the sentence according to our scheme.
            myMutableSentence!.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xdd7625, alpha: 1.0), range: NSRange(location: 10,length: 7))
            
            myMutableSentence!.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xcf2424, alpha: 1.0), range: NSRange(location: 0,length: 6))

            myMutableSentence!.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x8d1a33, alpha: 1.0), range: NSRange(location: 25,length: 8))
           
            
            myMutableSentence!.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x4C1242, alpha: 1.0), range: NSRange(location: 49,length: 6))
            
            noReviewLabel.attributedText = myMutableSentence

            
            self.view.addSubview(noReviewLabel)
        }
        
        else
        {
            reviewObject = reviewData["results"] as! NSArray
            commentsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
            commentsTableView.hidden = false
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView()
    {
        commentsTableView.rowHeight = UITableViewAutomaticDimension
        commentsTableView.estimatedRowHeight = 250.0
    }
    
    // Datasource and delegate functions of the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewCount!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ReviewCellClass = tableView.dequeueReusableCellWithIdentifier("Review Cell", forIndexPath: indexPath) as! ReviewCellClass
        
    
        let dataObject = reviewObject[indexPath.row] as! NSDictionary
        
        cell.titleLabel!.text = dataObject["author"] as! String
        cell.reviewLabel!.text = dataObject["content"] as! String
        cell.reviewLabel.textColor = UIColorFromHex(0x969a9d, alpha: 1.0)
        
        
        if ((indexPath.row % 2) == 0)
        {
            cell.backgroundColor = UIColorFromHex(0x8d1a33, alpha: 1.0)
        }
        
        else
        {
            cell.backgroundColor = UIColorFromHex(0x4c1242, alpha: 1.0)
        }
        
        return cell
    }
    

    // Function to convert hexa code to UI Color
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
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
