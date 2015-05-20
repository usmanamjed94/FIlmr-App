//
//  suggestionsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/11/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit
import MediaPlayer

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var suggestionsData = []
    var tableData = []
    var imageCache = [String:UIImage]()
    var query = QueryModel()
    var movieDetails:NSArray = []
    
    
    @IBOutlet weak var movieSuggestionsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSuggestionsTableView.contentInset = UIEdgeInsetsZero
        movieSuggestionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        movieSuggestionsTableView.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)
        
        // Do any additional setup after loading the view.
        var nib1 = UINib(nibName: "singleMovieCell", bundle: nil)
        movieSuggestionsTableView.registerNib(nib1, forCellReuseIdentifier: "singleMovieCell")
        
        var nib2 = UINib(nibName: "doubleMovieCell", bundle: nil)
        movieSuggestionsTableView.registerNib(nib2, forCellReuseIdentifier: "doubleMovieCell")
        
        println(suggestionsData)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalData = suggestionsData.count
        println(totalData)
        switch totalData {
        
        case 1:
            return 1
            
        case 2:
            return 2
        
        case let x where x>2:
            if (x % 2) == 0
            {
                return (x/2) + 1
            }
            else
            {
                return ((x + 1)/2) + 1
            }
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        
        if (indexPath.row == 0) || (indexPath.row == 1)
        {
            var cell: SingleMovieCellClass = self.movieSuggestionsTableView.dequeueReusableCellWithIdentifier("singleMovieCell") as! SingleMovieCellClass
            
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
        
        else
        {
            var cell: DoubleMovieCellClass = self.movieSuggestionsTableView.dequeueReusableCellWithIdentifier("doubleMovieCell") as! DoubleMovieCellClass
            
            var row = (indexPath.row * 2) - 2
            
            if let rowData: NSDictionary = self.suggestionsData[row] as? NSDictionary
            {
                
                let urlString = "http://image.tmdb.org/t/p/w342/" + (rowData["poster_path"]! as! String)
                let imgURL = NSURL(string: urlString)
                let temp = rowData["id"]!
                let id = "\(temp)"
               
                // Start by setting the cell's image to a static file
                cell.leftMoviePoster.image = UIImage(named: "placeholderSmall.gif")
                cell.leftMovieID.text = id
                
                cell.leftMoviePoster.userInteractionEnabled = true
                cell.leftMoviePoster.tag = id.toInt()!
                var tappedLeft:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TappedOnLeftImage:")
                tappedLeft.numberOfTapsRequired = 1
                cell.leftMoviePoster.addGestureRecognizer(tappedLeft)
                
                
                if let img = imageCache[urlString]
                {
                    cell.leftMoviePoster.image = img
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
                            // Update the cell hello
                            dispatch_async(dispatch_get_main_queue(), {
                                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? DoubleMovieCellClass {
                                    cellToUpdate.leftMoviePoster.image = image
                                }
                            })
                        }
                        else {
                            println("Error: \(error.localizedDescription)")
                        }
                    })
                    
                }
                
            }
            
            if ((row+1) < self.suggestionsData.count)
            {
                if let rowData: NSDictionary = self.suggestionsData[row+1] as? NSDictionary
                {
                    
                    let urlString = "http://image.tmdb.org/t/p/w342/" + (rowData["poster_path"]! as! String)
                    let imgURL = NSURL(string: urlString)
                    let temp = rowData["id"]!
                    let id = "\(temp)"
                    let title = rowData ["original_title"] as! String
                    
                    // Start by setting the cell's image to a static file
                    cell.rightMoviePoster.image = UIImage(named: "placeholderSmall.gif")
                    cell.rightMovieID.text = id
                    
                    // Adding gesture which recognizes image tap on the right image
                    cell.rightMoviePoster.userInteractionEnabled = true
                    cell.rightMoviePoster.tag = id.toInt()!
                    var tappedRight:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "TappedOnRightImage:")
                    tappedRight.numberOfTapsRequired = 1
                    cell.rightMoviePoster.addGestureRecognizer(tappedRight)
                    
                    
                    
                    if let img = imageCache[urlString]
                    {
                        cell.rightMoviePoster.image = img
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
                                    if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? DoubleMovieCellClass {
                                        cellToUpdate.rightMoviePoster.image = image
                                    }
                                })
                            }
                            else {
                                println("Error: \(error.localizedDescription)")
                            }
                        })
                        
                    }
                }
                
            }
            
            else
            {
                cell.rightMoviePoster.image = UIImage(named: "placeholderSmall.gif")
                cell.rightMovieID.text = ""
            }
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 288
    }
    
    // Corresponding to selection of cell
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if ((indexPath.row == 0) || (indexPath.row == 1))
        {
            let selectedCell: SingleMovieCellClass = self.movieSuggestionsTableView.cellForRowAtIndexPath(indexPath) as! SingleMovieCellClass
            let movieId = selectedCell.movieId.text!
            movieDetails = query.getMovieDetails("\(movieId)")
            self.performSegueWithIdentifier("movieDetailsSegue", sender: self)
        }
        
    }
    
    // Function corresponding to left image tap gesture
    func TappedOnLeftImage(sender:UITapGestureRecognizer){
        movieDetails = query.getMovieDetails("\((sender.view?.tag)!)")
        self.performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    func TappedOnRightImage(sender:UITapGestureRecognizer){
        movieDetails = query.getMovieDetails("\((sender.view?.tag)!)")
        self.performSegueWithIdentifier("movieDetailsSegue", sender: self)
    }
    
    // Function to convert hexa code to UI Color
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    
    // Sending data of movies while segue happens for sugggestions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "movieDetailsSegue"
        {
            if let destinationVC = segue.destinationViewController as? DetailsTabBarController {
                destinationVC.data = movieDetails as Array
            }
            
        }
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
