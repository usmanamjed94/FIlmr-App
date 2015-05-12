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
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationController!.navigationBar.barTintColor = UIColor.greenColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
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
            self.welcomeFirstLabel.alpha = 0
            self.welcomeSecondLabel.alpha = 0
            self.performSegueWithIdentifier("queryViewSegue", sender: self)
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

