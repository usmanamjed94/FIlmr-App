//
//  SimilarViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/20/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class SimilarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var suggestionsTable: UITableView!
    var suggestionsData = NSArray()
    var imageCache = [String:UIImage]()
    var query = QueryModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Main background
        self.view.backgroundColor = UIColorFromHex(0x262626, alpha: 1.0)
        suggestionsTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.suggestionsTable.backgroundColor = UIColorFromHex(0x262626, alpha: 1.0)
        
        // Do any additional setup after loading the view.
        var nib1 = UINib(nibName: "singleMovieCell", bundle: nil)
        suggestionsTable.registerNib(nib1, forCellReuseIdentifier: "singleMovieCell")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestionsData.count
    }


    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: SingleMovieCellClass = self.suggestionsTable.dequeueReusableCellWithIdentifier("singleMovieCell") as! SingleMovieCellClass
        
        if let rowData: NSDictionary = self.suggestionsData[indexPath.row] as? NSDictionary
        {
            
            let urlString = "http://image.tmdb.org/t/p/w500/" + (rowData["poster_path"]! as! String)
            let imgURL = NSURL(string: urlString)
            let temp = rowData["id"]!
            let id = "\(temp)"
            let title = rowData ["original_title"] as! String
            
            // Start by setting the cell's image to a static file
            cell.moviePoster.image = UIImage(named: "placeholderWide.gif")
            cell.movieId.text = id
            
            if let img = imageCache[urlString]
            {
                cell.moviePoster.image = img
            }
                
            else
            {
                // The image isn't cached, download the img data
                // Performing this in the background thread
                let request: NSURLRequest = NSURLRequest(URL: imgURL!)
                let mainQueue = NSOperationQueue.mainQueue()
                NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
                    if error == nil {
                        // Convert the downloaded data in to a UIImage object
                        let image = UIImage(data: data)
                        // Store the image in to our cache
                        self.imageCache[urlString] = image
                        // Update the cell
                        dispatch_async(dispatch_get_main_queue(), {
                            if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? SingleMovieCellClass {
                                cellToUpdate.moviePoster.image = image
                            }
                        })
                    }
                    else {
                        println("Error: \(error.localizedDescription)")
                    }
                })
                
            }
        }
        
        return cell

    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 300
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
