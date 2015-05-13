//
//  autocompleteModel.swift
//  Filmr
//
//  Created by Usman Amjed on 5/12/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import Foundation

class AutocompleteModel {
    
    init (){}
    
    // Function that makes the search call for the movies
    func searchForMovies (searchTerm: String) -> NSArray
    {
        let urlPath = "http://50.19.18.196:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt&genres=Action,Adventure&keyword=fight"
        let url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as! NSDictionary
        
        let results: NSArray = jsonResult["results"] as! NSArray
        return results
    }

    
    
    // Function that makes the search call for generes
    func searchForGenresSuggestions (searchTerm: String) -> Dictionary <String, Dictionary<Int, String>>
    {
        var suggestionsDictionary = [String: Dictionary<Int, String>]()
        let urlPath = "http://50.19.18.196:3000/autocompleteGenres?regex=" + searchTerm
        let url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as! NSDictionary
        
        if let results: NSArray = jsonResult["results"] as? NSArray
        {
            for (var i=0;i<results.count;i++)
            {
                if let suggestionData: NSDictionary = results[i] as? NSDictionary
                {
                    let id = suggestionData["id"] as! NSInteger
                    let name = (suggestionData["name"])
                    let type = "Keyword"
                    suggestionsDictionary["\(name!)"] = [id:type]
                }
            }
        }
        return suggestionsDictionary
    }
    

    
    // Function that makes the search call keywords
    func searchForKeywordsSuggestions (searchTerm: String) -> Dictionary<String,Any>
    {
        var suggestionsDictionary = [String: Any]()
        let urlPath = "http://50.19.18.196:3000/autocompleteKeywords?regex=" + searchTerm
        let url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as! NSDictionary
        
        if let results: NSArray = jsonResult["results"] as? NSArray
        {
            for (var i=0;i<results.count;i++)
            {
                if let suggestionData: NSDictionary = results[i] as? NSDictionary
                {
                    let id = suggestionData["id"] as! NSInteger
                    let name = (suggestionData["name"])
                    let type = "Keyword"
                    suggestionsDictionary["\(name!)"] = [id:type]
                }
            }
        }
        return suggestionsDictionary
    }

    
    // Function that makes the search call actors
    func searchForActorsSuggestions (searchTerm: String) -> Dictionary<String, Any>
    {
        var suggestionsDictionary = [String: Any]()
        let urlPath = "http://50.19.18.196:3000/autocompleteActors?regex=" + searchTerm
        let url = NSURL(string: urlPath)
//        let session = NSURLSession.sharedSession()
//        let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
//            if(error != nil) {
//                // If there is an error in the web request, print it to the console
//                println(error.localizedDescription)
//            }
//            var err: NSError?
//            if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
//                if(err != nil) {
//                    // If there is an error parsing JSON, print it to the console
//                    println("JSON Error \(err!.localizedDescription)")
//                }
//                
//                
//                if let results: NSArray = jsonResult["results"] as? NSArray {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        for (var i=0;i<results.count;i++)
//                        {
//                            if let suggestionData: NSDictionary = results[i] as? NSDictionary
//                            {
//                                let id = suggestionData["id"] as! NSInteger
//                                let name = (suggestionData["name"])
//                                //let type = "Actor"
//                                suggestionsDictionary["\(name!)"] = id
//                            }
//                        }
//                    })
//                    
//                }
//            }
//        })
//        
//        task.resume()
        
        var request = NSURLRequest(URL: url!)
        var response: NSURLResponse?
        var error: NSErrorPointer = nil
        var data = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: error)
        var jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: error) as! NSDictionary
        
        if let results: NSArray = jsonResult["results"] as? NSArray{
            for (var i=0;i<results.count;i++)
            {
                if let suggestionData: NSDictionary = results[i] as? NSDictionary
                {
                    let id = suggestionData["id"] as! NSInteger
                    let name = (suggestionData["name"])
                    let type = "Actor"
                    suggestionsDictionary["\(name!)"] = [id:type]
                }
            }
        }
        return suggestionsDictionary
    }

}