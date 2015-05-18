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
    
    var myMutableSentence = NSMutableAttributedString()
    var attributesPositions = [String: [Int:Int]]()
    
    var timer:NSTimer?
    var myCounter = 0
    
    var suggestions = [String]()
    var suggestionsDictionary = [String: Dictionary<Int, String>]()
    var query = QueryModel()
    var recommendations:NSArray = []
    final var genres = [String: Dictionary<Int, String>]()
    final var keywords = [String: Dictionary<Int, String>]()
    final var actors = [String: Dictionary<Int, String>]()
    
    // Initializing era's
    var era = ["1950's":[195001019591230: "Era"],"1960's":[196001019691230: "Era"],"1970's":[197001019791230: "Era"],"1980's":[198001019891230: "Era"],"1990's":[199001019991230: "Era"],"2000's":[200001020151230: "Era"]]
    
    final var constraintsDictionary = [String: Dictionary<Int, String>]()
    
    
    
    // Function corresponding to any appearence of the view
    override func viewWillAppear(animated: Bool) {
        textField.text = ""
        constraintsDictionary.removeAll(keepCapacity: false)
        suggestionsDictionary.removeAll(keepCapacity: false)
        attributesPositions.removeAll(keepCapacity: false)
        
        sentence.text = "I WANT TO WATCH A MOVIE CONTAINING KEYWORD STARRING ACTOR FROM THE ERA INVOLVING GENRE?"
        
        myMutableSentence = NSMutableAttributedString(string: sentence.text!)
        
        // Keyword Coloring
        myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xdd7625, alpha: 1.0), range: NSRange(location: 35,length: 7))
        myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: 35,length: 7))
        // Actor Coloring
        myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xcf2424, alpha: 1.0), range: NSRange(location: 52,length: 5))
        myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: 35,length: 7))
        // ERA Coloring
        myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x8d1a33, alpha: 1.0), range: NSRange(location: 67,length: 3))
        myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: 35,length: 7))
        // Genre Coloring
        myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x8d1a33, alpha: 1.0), range: NSRange(location: 81,length: 5))
        myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: 35,length: 7))
        
        sentence.attributedText = myMutableSentence
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        textField.delegate = self
        self.view.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)
        sentence.textColor = UIColorFromHex(0x565454, alpha: 1.0)
        
        
        sentence.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        sentence.font = UIFont.boldSystemFontOfSize(24.0)
        
        
        autocompleteTableView.delegate = self
        autocompleteTableView.dataSource = self
        autocompleteTableView.scrollEnabled = true
        autocompleteTableView.hidden = true
        autocompleteTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "AutocompleteCell")
        autocompleteTableView.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)
        autocompleteTableView.separatorColor = UIColorFromHex(0xffffff, alpha: 1.0)
        autocompleteTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        getRecommendations.backgroundColor = UIColorFromHex(0xffffff, alpha: 1.0)
        getRecommendations.layer.cornerRadius = 15
        getRecommendations.layer.borderWidth = 1
        getRecommendations.layer.borderColor = UIColorFromHex(0x191919, alpha: 1.0).CGColor
        
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
        
        for (name,details) in era
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
            self.actors = self.query.searchForActorsSuggestions(subString)
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
            self.recommendations = self.query.searchForMovies(self.queryBuilder(self.constraintsDictionary))
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
                case "Era":
                    cell.backgroundColor = UIColorFromHex(0x8d1a33, alpha: 1.0)
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
        let details = suggestionsDictionary[textField.text]!
        
        for (id, type) in details
        {
            constraintsDictionary[textField.text] = [id:type]
        }
        textField.text = ""
        
        animateSentence(sentence)
        autocompleteTableView.hidden = true
        
    }
    

    // Function corresponding to focus state of input field
    
    func textFieldDidBeginEditing(textField: UITextField) {
        animateViewMoving(true, moveValue: 220)
    }
    
    // When the focus ends ; moving the view back in
    func textFieldDidEndEditing(textField: UITextField) {
        animateViewMoving(false, moveValue: 220)
        
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
    
    // Shuffling funtion for an array
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
    
    
    
    
    
    // Function that builds the sentence
    func buildSentence (constraints: Dictionary<String, Dictionary<Int, String>>) -> String
    {
        println(constraints)
        var startSentence = "I WANT TO WATCH A "
        var firstEntry: Bool = true
        var totalLengthBefore = 0
        var lengthOfEntry = 0
        
        totalLengthBefore = count(startSentence)
        
        // Checking for genre
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Genre")
                {
                    if (firstEntry)
                    {
                        startSentence = startSentence + name.uppercaseString + " "
                        firstEntry = false
                        lengthOfEntry += count(name)
                    }
                        
                    else
                    {
                        lengthOfEntry += 3 + count(name)
                        startSentence = startSentence + ", " + name.uppercaseString + " "
                    }
                }
            }
        }
        
        
        startSentence += "MOVIE "
        firstEntry = true
        attributesPositions["Genre"] = [totalLengthBefore: lengthOfEntry]
        totalLengthBefore = count(startSentence)
        lengthOfEntry = 0
        
        // Checking for era
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Era")
                {
                    if (firstEntry)
                    {
                        startSentence = startSentence + "FROM THE ERA OF " + name.uppercaseString + " "
                        totalLengthBefore += 16
                        firstEntry = false
                        lengthOfEntry += count(name)
                    }
                        
                    else
                    {
                        startSentence = startSentence + ", " + name.uppercaseString + " "
                        lengthOfEntry += 3 + count(name)
                    }
                }
            }
        }
        
        firstEntry = true
        attributesPositions["Era"] = [totalLengthBefore: lengthOfEntry]
        totalLengthBefore = count(startSentence)
        lengthOfEntry = 0
        
        // Checking for actors
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Actor")
                {
                    if (firstEntry)
                    {
                        startSentence = startSentence + "STARRING " + name.uppercaseString + " "
                        totalLengthBefore += 9
                        firstEntry = false
                        lengthOfEntry += count(name)
                    }
                        
                    else
                    {
                        startSentence = startSentence + ", " + name.uppercaseString + " "
                        lengthOfEntry += 3 + count(name)
                    }
                }
            }
        }
        firstEntry = true
        attributesPositions["Actor"] = [totalLengthBefore: lengthOfEntry]
        totalLengthBefore = count(startSentence)
        lengthOfEntry = 0
        
        // Checking for keywords
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Keyword")
                {
                    if (firstEntry)
                    {
                        startSentence = startSentence + "INVOLVING " + name.uppercaseString + " "
                        totalLengthBefore += 10
                        firstEntry = false
                        lengthOfEntry += count(name)
                    }
                    
                    else
                    {
                        startSentence = startSentence + ", " + name.uppercaseString + " "
                        lengthOfEntry += 3 + count(name)
                    }
                }
            }
        }
        attributesPositions["Keyword"] = [totalLengthBefore: lengthOfEntry]
        println(attributesPositions)
        println(startSentence)
        return startSentence
    }
    
    
    // Function that color codes given sentence based on the ranges provided
    func colorCodeSentence (positions: Dictionary<String, Dictionary<Int, Int>>, sentence: String) -> NSMutableAttributedString
    {
        var myMutableSentence = NSMutableAttributedString(string: sentence)
        
        for (type, details) in positions
        {
            if (type == "Keyword")
            {
                for (start,end) in details
                {
                    // Keyword Coloring
                    myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xdd7625, alpha: 1.0), range: NSRange(location: start,length: end))
                    myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: start,length: end))

                }
            }
            
            else if (type == "Actor")
            {
                for (start,end) in details
                {
                    // Actor Coloring
                    myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0xcf2424, alpha: 1.0), range: NSRange(location: start,length: end))
                    myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: start,length: end))

                }
            }
            
            if (type == "Genre")
            {
                for (start,end) in details
                {
                    // Genre Coloring
                    myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x8d1a33, alpha: 1.0), range: NSRange(location: start,length: end))
                    myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: start,length: end))

                }
            }
            
            if (type == "Era")
            {
                for (start,end) in details
                {
                    // ERA Coloring
                    myMutableSentence.addAttribute(NSBackgroundColorAttributeName, value: UIColorFromHex(0x8d1a33, alpha: 1.0), range: NSRange(location: start,length: end))
                    myMutableSentence.addAttribute(NSForegroundColorAttributeName, value: UIColorFromHex(0xffffff, alpha: 1.0), range: NSRange(location: start,length: end))
                }
            }
            
        }
     
        return myMutableSentence
    }
    
    // Animating the sentence. Sentence is first built; then colorcoded; and then animated into view
    
    func animateSentence (sentence: UILabel)
    {
        // Fade out to set the text
        
        UIView.animateWithDuration(1.25, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlUp, animations: {
            self.sentence.alpha = 0.0
            }, completion: {
                (finished: Bool) -> Void in
                
                //Once the label is completely invisible, set the text and fade it back in
                self.sentence.text = self.buildSentence(self.constraintsDictionary)
                self.sentence.attributedText = self.colorCodeSentence(self.attributesPositions, sentence: self.sentence.text!)
                
                // Fade in
                UIView.animateWithDuration(1.25, delay: 0.0, options: UIViewAnimationOptions.TransitionCurlDown, animations: {
                    self.sentence.alpha = 1.0
                    }, completion: nil)
        })

    }
    
    // Function that builds the query for recommendations
    func queryBuilder (constraints: Dictionary<String, Dictionary<Int, String>>) -> String
    {
        var initialQuery = "http://50.19.18.196:3000/fetchRecommendation?"
        var firstEntry = true
        var completeEraString = ""
        var startEra:NSMutableString = ""
        var endEra:NSMutableString = ""
        
        
        initialQuery += "era_start=&era_end="
        
        // Checking for era and building era constraints
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Era")
                {
                    completeEraString = "\(id)"
                    startEra = NSMutableString(string: completeEraString.substringToIndex(advance(completeEraString.startIndex,8)))
                    endEra = NSMutableString(string: completeEraString.substringFromIndex(advance(completeEraString.startIndex,7)))
                    
                    
                    if (firstEntry)
                    {
                        startEra.insertString("-", atIndex: 4)
                        startEra.insertString("-", atIndex: 7)
                        endEra.insertString("-", atIndex: 4)
                        endEra.insertString("-", atIndex: 7)
                        initialQuery = initialQuery.substringToIndex(advance(initialQuery.startIndex,45))
                        initialQuery += "era_start=" + (startEra as String) + "&" + "era_end=" + (endEra as String)
                        firstEntry = false
                    }
                        
                    else
                    {
                        var nextStart = startEra as String
                        var nextEnd = endEra as String
                        nextStart.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                        nextEnd.stringByReplacingOccurrencesOfString("-", withString: "", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
                        
                        var nextStartInt = nextStart.toInt()
                        var nextEndInt = nextEnd.toInt()
                        
                        var prevStart = initialQuery.substringWithRange(Range(start:advance(initialQuery.startIndex,55),end: advance(initialQuery.startIndex, 65)))
                        var prevEnd = initialQuery.substringWithRange(Range(start:advance(initialQuery.startIndex,74),end: advance(initialQuery.startIndex, 84)))
                        
                        var prevStartInt = prevStart.toInt()
                        var prevEndInt = prevEnd.toInt()

                        startEra.insertString("-", atIndex: 4)
                        startEra.insertString("-", atIndex: 7)
                        endEra.insertString("-", atIndex: 4)
                        endEra.insertString("-", atIndex: 7)
                        
                        
                        if (prevStart > nextStart)
                        {
                            initialQuery.replaceRange(Range(start:advance(initialQuery.startIndex,55),end: advance(initialQuery.startIndex, 65)), with: (startEra as String))
                        }
                        
                        if (prevEnd < nextEnd)
                        {
                            initialQuery.replaceRange(Range(start:advance(initialQuery.startIndex,74),end: advance(initialQuery.startIndex, 84)), with: (endEra as String))
                        }
                        
                    }
                }
            }
        }
        
        initialQuery += "&actor="
        firstEntry = true
        
        // Checking for actors
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Actor")
                {
                    if (firstEntry)
                    {
                        initialQuery += "\(id)"
                        firstEntry = false
                    }
                    
                    else
                    {
                        initialQuery += ",\(id)"
                    }
                }
            }
        }
        
        initialQuery += "&genres="
        firstEntry = true
        
        // Checking for genres
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Genre")
                {
                    if (firstEntry)
                    {
                        initialQuery += "\(id)"
                        firstEntry = false
                    }
                        
                    else
                    {
                        initialQuery += "|\(id)"
                    }
                }
            }
        }
        
        initialQuery += "&keywords="
        firstEntry = true
        
        // Checking for keywords
        for (name, details) in constraints
        {
            for (id, type) in details
            {
                if (type == "Keyword")
                {
                    if (firstEntry)
                    {
                        initialQuery += "\(id)"
                        firstEntry = false
                    }
                        
                    else
                    {
                        initialQuery += ",\(id)"
                    }
                }
            }
        }
        
        return initialQuery

    }
    
}
