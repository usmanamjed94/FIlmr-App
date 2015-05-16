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
    @IBOutlet weak var getRecommendations: UIButton!
    
    var suggestions = [String]()
    var suggestionsDictionary = [String: Dictionary<Int, String>]()
    var autocomplete = AutocompleteModel()
    var recommendations:NSArray = []
    final var genres = [String: Dictionary<Int, String>]()
    final var keywords = [String: Dictionary<Int, String>]()
    final var actors = [String: Dictionary<Int, String>]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        textField.delegate = self
        self.view.backgroundColor = UIColorFromHex(0x191919, alpha: 1.0)
        
        
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteCell")
        autocompleteTableView.backgroundColor = UIColorFromHex(0x191919, alpha: 1.0)
        autocompleteTableView.separatorColor = UIColorFromHex(0xffffff, alpha: 1.0)
        autocompleteTableView.separatorInset = UIEdgeInsetsZero
        
        getRecommendations.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)

        getRecommendations.layer.cornerRadius = 15
        getRecommendations.layer.borderWidth = 1
        getRecommendations.layer.borderColor = UIColorFromHex(0x191919, alpha: 1.0).CGColor
        
        
        
        sentence.numberOfLines = 0
        sentence.text = "Hello, What would you like to watch today?"
        
        // Adding data from the server for genres and keywords locally so that none other call is made.
        let subView = showActivityIndicator(self.view)
        
        let genresPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(genresPriority, 0)) {
            self.genres = self.autocomplete.searchForGenresSuggestions("")
        }
        
        let keywordsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(keywordsPriority, 0)) {
            self.keywords = self.autocomplete.searchForKeywordsSuggestions("")
            dispatch_async(dispatch_get_main_queue()) {
                self.hideActivityIndicator(subView.container, indicator: subView.indicator)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Function corresponding to writting inside the input field
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var substring = (self.textField.text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        if (substring != "")
        {
            autocompleteTableView.hidden = false
        }
        else
        {
            autocompleteTableView.hidden = true
        }
        
        searchAutocompleteEntriesWithSubstring(substring)
        return true
        
    }
    
    // Fix the autocomplete feature
    func searchAutocompleteEntriesWithSubstring (subString: String)
    {
        suggestions.removeAll(keepCapacity: false)
        suggestionsDictionary.removeAll(keepCapacity: false)
        
        for (name,details) in genres
        {
            if name.uppercaseString.hasPrefix(subString.uppercaseString)
            {
                suggestions.append(name)
                for (id, type) in details
                {
                    suggestionsDictionary[name] = [id:type]
                }
            }
        }
        
        
        for (name,details) in keywords
        {
            if name.uppercaseString.hasPrefix(subString.uppercaseString)
            {
                suggestions.append(name)
                for (id, type) in details
                {
                    suggestionsDictionary[name] = [id:type]
                }
            }
        }
        
        // Shuffling suggestions
        if (suggestions.count > 2)
        {
            suggestions = shuffle(suggestions as [String])
        }
        
        
        
        let actorsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(actorsPriority, 0)) {
            self.actors = self.autocomplete.searchForActorsSuggestions(subString)
            dispatch_async(dispatch_get_main_queue()) {
                for (name,details) in self.actors
                {
                    self.suggestions.append(name)
                    for (id, type) in details
                    {
                        self.suggestionsDictionary[name] = [id:type]
                    }
                }
                
                if (self.suggestions.count>2)
                {
                    self.suggestions = self.shuffle(self.suggestions as [String])
                }
                self.autocompleteTableView.reloadData()
            }
        }
        
        self.autocompleteTableView.reloadData()
        
    }

    // Function that searches for movies and shows the spinner
    @IBAction func searchForRecommendations(sender: AnyObject)
    {
        let subView = showActivityIndicator(self.view)
        let recommendationsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(recommendationsPriority, 0)) {
            self.recommendations = self.autocomplete.searchForMovies("")
            dispatch_async(dispatch_get_main_queue())
            {
                if (self.recommendations.count != 0)
                {
                    self.performSegueWithIdentifier("suggestionsViewSegue", sender: self)
                }
                else
                {
                    let alert = UIAlertView()
                    alert.title = "Oops!"
                    alert.message = "We couldn't find any recommendations for you."
                    alert.addButtonWithTitle("Take me back!")
                    alert.show()
                }
                // Stopping the activity indicator and removing the subview
                self.hideActivityIndicator(subView.container, indicator: subView.indicator)
            }
        }

        
        
    }
    
    // Datasource and delegate functions of the table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return suggestions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("AutocompleteCell", forIndexPath: indexPath) as! UITableViewCell
        
        //let dictionaryObject = suggestionsDictionary[indexPath.row]
        
        cell.textLabel!.text = suggestions[indexPath.row]
        cell.textLabel!.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        cell.textLabel!.font = UIFont.boldSystemFontOfSize(16.0)
        
        let details = suggestionsDictionary[suggestions[indexPath.row]]!
        for (id, type) in details
        {
            switch type {
                case "Actor":
                    cell.backgroundColor = UIColorFromHex(0xcf2424, alpha: 1.0)
                case "Keyword":
                    cell.backgroundColor = UIColorFromHex(0xdd7625, alpha: 1.0)
                case "Genre":
                    cell.backgroundColor = UIColorFromHex(0x4c1242, alpha: 1.0)
                default:
                    println("default")
            }
        }
        
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
        animateViewMoving(true, moveValue: 220)
    }
    
    // When the focus ends ; moving the view back in
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 220)
        
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
    
    // Function to convert hexa code to UI Color
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }

    // Function to show activity indicator
    func showActivityIndicator(uiView: UIView) -> (indicator: UIActivityIndicatorView, container: UIView)
    {
        var container: UIView = UIView()
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColorFromHex(0xffffff, alpha: 0.3)
        
        var loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColorFromHex(0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        actInd.center = CGPointMake(loadingView.frame.size.width / 2,
            loadingView.frame.size.height / 2);
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()

        return (actInd, container)
    }
    
    // Function to hide activity indicator
    func hideActivityIndicator(subView: UIView, indicator: UIActivityIndicatorView) {
        indicator.stopAnimating()
        subView.removeFromSuperview()
    }
    
    // Sending data of movies while segue happens for sugggestions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "suggestionsViewSegue"
        {
            if let destinationVC = segue.destinationViewController as? SuggestionsViewController {
                destinationVC.suggestionsData = recommendations
            }
        }
    }
    
    // Shuffling funtion
    func shuffle<C: MutableCollectionType where C.Index.Distance == Int>(var list: C) -> C {
        var n = count(list)
        if n == 0 { return list }
        let oneBeforeEnd = advance(list.startIndex, n.predecessor())
        for i in list.startIndex..<oneBeforeEnd {
            let ran = Int(arc4random_uniform(UInt32(n--)))
            let j = advance(i,ran)
            swap(&list[i], &list[j])
        }
        return list
    }
}
