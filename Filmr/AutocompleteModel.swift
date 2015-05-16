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
//        http://50.19.18.196:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt&genres=Action,Adventure&keyword=fight
        let urlPath = "http://50.19.18.196:3000/getRecommendation?era_start=1990-01-01&era_end=2010-12-30&actors=brad%20pitt"
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
                    let type = "Genre"
                    suggestionsDictionary["\(name!)"] = [id:type]
                }
            }
        }
        return suggestionsDictionary
    }
    

    
    // Function that makes the search call keywords
    func searchForKeywordsSuggestions (searchTerm: String) -> Dictionary<String,Dictionary<Int, String>>
    {
        var suggestionsDictionary =  [String: Dictionary<Int, String>]()
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
    func searchForActorsSuggestions (searchTerm: String) -> Dictionary<String,Dictionary<Int, String>>
    {
        let escapedSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        var suggestionsDictionary = [String: Dictionary<Int, String>]()
        let urlPath = "http://50.19.18.196:3000/autocompleteActors?regex=" + escapedSearchTerm
        let url = NSURL(string: urlPath)
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