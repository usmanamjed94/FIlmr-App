//
//  queryViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/10/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class QueryViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var sentence: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var autocompleteTableView: UITableView!
    var pastUrls = ["Hello","Baby","Alaska", "Tom Cruise", "Tom Clancy", "Theon Greyjoy"]
    var suggestions = ["Hello","Baby","Alaska", "Tom Cruise", "Tom Clancy", "Theon Greyjoy"]
    var autocomplete = AutocompleteModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        textField.delegate = self
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteCell")
        sentence.numberOfLines = 0
        sentence.text = "Hello, What would you like to watch today?"

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Function corresponding to writting inside the input field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        autocompleteTableView.hidden = false
        var substring = (self.textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        searchAutocompleteEntriesWithSubstring(substring)
        return true
        
    }
    
    // Fix the autocomplete feature
    func searchAutocompleteEntriesWithSubstring (subString: String)
    {
        suggestions.removeAll(keepCapacity: false)
        
        let genresPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(genresPriority, 0)) {
            var genres = self.autocomplete.searchForGenresSuggestions(subString)
            dispatch_async(dispatch_get_main_queue()) {
                println(genres)
            }
        }
        
        let keywordsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(keywordsPriority, 0)) {
            var keywords = self.autocomplete.searchForKeywordsSuggestions(subString)
            dispatch_async(dispatch_get_main_queue()) {
                println(keywords)
            }
        }
        
        let actorsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(actorsPriority, 0)) {
            var actors = self.autocomplete.searchForActorsSuggestions (subString)
            dispatch_async(dispatch_get_main_queue()) {
                println(actors)
            }
        }
//        for (name, id) in actors
//        {
//            suggestions.append(name)
//        }
        
        
//        for suggestionString in pastUrls
//        {
//            println(suggestionString)
//            if suggestionString.uppercaseString.hasPrefix(subString.uppercaseString)
//            {
//                suggestions.append(suggestionString)
//            }
//        }
        
        
        autocompleteTableView.reloadData()
        
    }

    
    // Datasource and delegate functions of the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AutocompleteCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel!.text = suggestions[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedCell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        textField.text = selectedCell.textLabel!.text
        textField.resignFirstResponder()
        autocompleteTableView.hidden = true
        
    }
    

    // Function corresponding to focus state of input field
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 250)
    }
    
    // When the focus ends ; moving the view back in
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 250)
        
        // Fade out to set the text
        
        UIView.animateWithDuration(1.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            self.sentence.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                self.sentence.text = "I want to watch a movie starring tom cruise"
                
                // Fade in
                UIView.animateWithDuration(1.25, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                    self.sentence.alpha = 1.0
                    }, completion: nil)
        })
    }
    
    // Animate function for moving views upwards
    func animateViewMoving (up:Bool, moveValue :CGFloat){
        var movementDuration:NSTimeInterval = 0.50
        var movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = CGRectOffset(self.view.frame, 0,  movement)
        UIView.commitAnimations()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "suggestionsViewSegue"
        {
            if let destinationVC = segue.destinationViewController as? SuggestionsViewController {
                destinationVC.querySentence = textField.text
            }
        }
    }
    
}
