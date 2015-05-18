//
//  suggestionsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/11/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FBSDKLoginButtonDelegate {

    var suggestionsData :NSArray = []
    var tempMoviesData :NSMutableArray = []
    var FBUserMovies: NSArray = []
    var tableData = []
    var imageCache = [String:UIImage]()
    @IBOutlet weak var movieSuggestionsTableView: UITableView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            // User is already logged in, do work such as go to next view controller.
//        }
//        else
//        {
            let loginView : FBSDKLoginButton = FBSDKLoginButton()
            self.navigationController?.navigationBar.addSubview(loginView)
//            self.view.addSubview(loginView)
//            loginView.center = self.navigationController?.navigationBar.center
            loginView.frame = (frame: CGRect(x: 250, y: 0, width: 90, height: 40))
//            loginView.center = self.view.center
            loginView.readPermissions = ["public_profile", "email", "user_friends"]
//            self.navigationController.de
//            loginView.delegate = self.navigationController?.delegate
            loginView.delegate = self
//        }
        
        movieSuggestionsTableView.contentInset = UIEdgeInsetsZero
        movieSuggestionsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        
        // Do any additional setup after loading the view.
        var nib1 = UINib(nibName: "singleMovieCell", bundle: nil)
        movieSuggestionsTableView.registerNib(nib1, forCellReuseIdentifier: "singleMovieCell")
        
        var nib2 = UINib(nibName: "doubleMovieCell", bundle: nil)
        movieSuggestionsTableView.registerNib(nib2, forCellReuseIdentifier: "doubleMovieCell")
        
        println(suggestionsData)
    }
    // Facebook Delegate Methods
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        println("User Logged In")
        
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
                // Do work
            }
        }
        self.returnUserData()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
    }
    
    func returnUserData()
    {
        var params = [String:Int]()
        params["limit"] = 200
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/movies", parameters: params)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
            }
            else
            {
//                println("fetched user: \(result)")
                self.FBUserMovies = result.valueForKey("data") as! NSArray
                println(self.FBUserMovies[0])
                self.tempMoviesData = self.suggestionsData.mutableCopy() as! NSMutableArray
                for (index, suggestedMovie) in enumerate(self.tempMoviesData){
                    let rowData: NSDictionary = suggestedMovie as! NSDictionary
                    let suggestedMovieName = rowData ["original_title"] as! String
                    for movie in self.FBUserMovies {
                        let movieName = movie.valueForKey("name") as! String
                        if(movieName==suggestedMovieName){
                            self.tempMoviesData.removeObjectAtIndex(index)
                           println(suggestedMovieName ," ", index)
                            continue
                        }
                        
                    }
                    
                }
                self.suggestionsData = self.tempMoviesData
                // Do any additional setup after loading the view.
                var nib1 = UINib(nibName: "singleMovieCell", bundle: nil)
                self.movieSuggestionsTableView.registerNib(nib1, forCellReuseIdentifier: "singleMovieCell")
                
                var nib2 = UINib(nibName: "doubleMovieCell", bundle: nil)
                self.movieSuggestionsTableView.registerNib(nib2, forCellReuseIdentifier: "doubleMovieCell")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.movieSuggestionsTableView.reloadData()
                })
//                self.performSegueWithIdentifier("suggestionsViewSegue", sender: self)
            }
        })
        
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
        return 288
    }
    
    
    
    // Function that makes the search call for the movies
    func searchForMovies (searchTerm: String)
    {
        let urlPath = "http://localhost:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt&genres=Action,Adventure&keyword=fight"
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
