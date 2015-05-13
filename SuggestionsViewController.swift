//
//  suggestionsViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/11/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class SuggestionsViewController: UIViewController {

    var querySentence: NSArray = []
    var tableData = []
    @IBOutlet weak var movieSuggestionsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println(querySentence)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Function that makes the search call for the movies
    func searchForMovies (searchTerm: String)
    {
        let urlPath = "http://50.19.18.196:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt&genres=Action,Adventure&keyword=fight"
        let url = NSURL(string: urlPath)
        let session = NSURLSession.sharedSession()
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
                        self.tableData = results
                        self.movieSuggestionsTableView!.reloadData()
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
