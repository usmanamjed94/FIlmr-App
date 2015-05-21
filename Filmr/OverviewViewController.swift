//
//  overviewViewController.swift
//  Filmr
//
//  Created by Usman Amjed on 5/20/15.
//  Copyright (c) 2015 Usman Amjed. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController {
    
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratings: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var keywordsLabel: UILabel!
    @IBOutlet weak var keywords: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var dataDictionary: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColorFromHex(0x262626, alpha: 1.0)
        
        var posterPath = ""
        
        if let collection = dataDictionary["belongs_to_collection"] as? NSDictionary
        {
            posterPath = (collection["poster_path"] as! String)
        }
        
        else
        {
            posterPath = (dataDictionary["poster_path"] as! String)
        }
        
        // Loading movie image
        let urlString = "http://image.tmdb.org/t/p/w500/" + posterPath
        let imgURL = NSURL(string: urlString)
        // Start by setting the cell's image to a static file
        movieImage.image = UIImage(named: "placeholderWide.gif")
        
        // The image isn't cached, download the img data
        // Performing this in the background thread
        let request: NSURLRequest = NSURLRequest(URL: imgURL!)
        let mainQueue = NSOperationQueue.mainQueue()
        NSURLConnection.sendAsynchronousRequest(request, queue: mainQueue, completionHandler: { (response, data, error) -> Void in
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                let image = UIImage(data: data)
                // Update the cell
                dispatch_async(dispatch_get_main_queue(), {
                    self.movieImage.image = image
                })
            }
            else {
                println("Error: \(error.localizedDescription)")
            }
        })
        
        // loading the ratings image
        let ratingNumber = dataDictionary["vote_average"] as! Int
        
        switch ratingNumber {
        case 1:
            ratings.image = UIImage(named: "Stars-01.png")
        case 2:
            ratings.image = UIImage(named: "Stars-02.png")
        case 3:
            ratings.image = UIImage(named: "Stars-03.png")
        case 4:
            ratings.image = UIImage(named: "Stars-04.png")
        case 5:
            ratings.image = UIImage(named: "Stars-05.png")
        case 6:
            ratings.image = UIImage(named: "Stars-06.png")
        case 7:
            ratings.image = UIImage(named: "Stars-07.png")
        case 8:
            ratings.image = UIImage(named: "Stars-08.png")
        case 9:
            ratings.image = UIImage(named: "Stars-09.png")
        case 10:
            ratings.image = UIImage(named: "Stars-10.png")
        default:
            ratings.image = UIImage(named: "Stars-05.png")
            
        }
        ratingLabel.font = UIFont(name: "Avenir-Black", size: 26.0)
        ratingLabel.textColor = UIColorFromHex(0x97999d, alpha: 1.0)
        
        // Loading genres
        let genresArray = dataDictionary["genres"] as! NSArray
        for (var i=0; i < genresArray.count; i++)
        {
            let genreDictionary = genresArray[i] as! NSDictionary
            let name = genreDictionary["name"]!
            if (i==0)
            {
                genre.text! = ("\(name)")
            }
                
            else
            {
                genre.text! += " , " + "\(name)"
            }
        }
        
        genre.backgroundColor = UIColorFromHex(0x4c1242, alpha: 1.0)
        genre.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        genreLabel.font = UIFont(name: "Avenir-Black", size: 26.0)
        genreLabel.textColor = UIColorFromHex(0x97999d, alpha: 1.0)
        
        // Adding keywords
        let keywordsDictionary = dataDictionary["keywords"] as! NSDictionary
        var keywordsArray = NSArray()
        var first = true
        for (id,details) in keywordsDictionary
        {
            keywordsArray = details as! NSArray

        }
        
        for (var i=0; i < keywordsArray.count; i++)
        {
            let keywordDictionary = keywordsArray[i] as! NSDictionary
            let name = keywordDictionary["name"]!
            if (i==0)
            {
                keywords.text! = ("\(name)")
            }
                
            else
            {
                keywords.text! += " , " + "\(name)"
            }
        }
    
        keywords.backgroundColor = UIColorFromHex(0xdd7625, alpha: 1.0)
        keywords.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        keywordsLabel.font = UIFont(name: "Avenir-Black", size: 26.0)
        keywordsLabel.textColor = UIColorFromHex(0x97999d, alpha: 1.0)
        
        
        // Adding overview
        overview.text = dataDictionary["overview"] as! String
        overview.backgroundColor = UIColorFromHex(0x8d1a33, alpha: 1.0)
        overview.textColor = UIColorFromHex(0xffffff, alpha: 1.0)
        overviewLabel.font = UIFont(name: "Avenir-Black", size: 26.0)
        overviewLabel.textColor = UIColorFromHex(0x97999d, alpha: 1.0)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Function to convert hexa code to UI Color
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
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
