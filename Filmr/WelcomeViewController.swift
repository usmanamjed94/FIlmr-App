//
//  ViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/2/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    var welcomeFirstLabel: UILabel!
    var welcomeSecondLabel: UILabel!
    final var genres = [String: Dictionary<Int, String>]()
    final var keywords = [String: Dictionary<Int, String>]()
    var autocomplete = AutocompleteModel()
    
    override func viewWillAppear(animated: Bool) {
        genres.removeAll(keepCapacity: false)
        keywords.removeAll(keepCapacity: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Navigation bar color
        self.navigationController?.navigationBar.barTintColor = UIColorFromHex(0x181818, alpha: 1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
  
        // Main background
//        self.view.backgroundColor = UIColorFromHex(0x101010, alpha: 1.0)

        
        
        welcomeFirstLabel = UILabel()
        welcomeFirstLabel.text = "Welcome to"
        welcomeFirstLabel.font = UIFont.systemFontOfSize(36)
        welcomeFirstLabel.sizeToFit()
        welcomeFirstLabel.center = CGPoint (x: 150, y: 40)
        view.addSubview(welcomeFirstLabel)
        welcomeFirstLabel.alpha = 0
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations:{self.welcomeFirstLabel.center = CGPoint(x: 150, y: 40+200); self.welcomeFirstLabel.alpha = 1}, completion: nil)
        
        
        welcomeSecondLabel = UILabel()
        welcomeSecondLabel.text = "Filmr!"
        welcomeSecondLabel.font = UIFont.boldSystemFontOfSize(48)
        welcomeSecondLabel.sizeToFit()
        welcomeSecondLabel.center = CGPoint (x: 200, y: 90)
        view.addSubview(welcomeSecondLabel)
        welcomeSecondLabel.alpha = 0
        
        UIView.animateWithDuration(2.0, delay: 0.8, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: nil, animations: {self.welcomeSecondLabel.center = CGPoint(x: 200, y: 90+200); self.welcomeSecondLabel.alpha = 1}, completion: {
            (finished: Bool) -> Void in
            
            
            // Adding data from the server for genres and keywords locally so that none other call is made.
            let subView = self.showActivityIndicator(self.view)
            
            let genresPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(genresPriority, 0)) {
                self.genres = self.autocomplete.searchForGenresSuggestions("")
            }
            
            let keywordsPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(keywordsPriority, 0)) {
                self.keywords = self.autocomplete.searchForKeywordsSuggestions("")
                dispatch_async(dispatch_get_main_queue()) {
                    self.hideActivityIndicator(subView.container, indicator: subView.indicator)
                    self.performSegueWithIdentifier("queryViewSegue", sender: self)
                }
            }
            
        })
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sending data of movies while segue happens for sugggestions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "queryViewSegue"
        {
            if let destinationVC = segue.destinationViewController as? QueryViewController {
                destinationVC.genres = genres
                destinationVC.keywords = keywords
            }
        }
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
    
    
    // Function to convert hexa code to UI Color
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }


}

