//
//  suggestionsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/11/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var suggestionsData: NSArray = []
    var tableData = []
    var imageCache = [String:UIImage]()
    @IBOutlet weak var movieSuggestionsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieSuggestionsTableView.contentInset = UIEdgeInsetsZero
        movieSuggestionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
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
                            // Update the cell
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
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 268
    }
    
    
    
    // Function that makes the search call for the movies
    func searchForMovies (searchTerm: String)
    {
        let urlPath = "http://50.19.18.196:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt&genres=Action,Adventure&keyword=fight"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession();
        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
            println("The api call was made.")
            if(error != nil) {
                // If there is an error in the web request, print it to the console
                println(error.localizedDescription)
            }
            var err: NSError?
            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                if(err != nil) {
                    // If there is an error parsing JSON, print it to the console
                    println("JSON Error \(err!.localizedDescription)")
                }
                if let results: NSArray = jsonResult["results"] as? NSArray {
                    dispatch_async(dispatch_get_main_queue(), {
                        println(results)
                    })
                }
            }
        })
        
        task.resume()
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
