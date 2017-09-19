//
//  MovieDetailsViewController.swift
//  BlockBuster
//
//  Created by Ravi Mandala on 9/18/17.
//  Copyright © 2017 Ravi Mandala. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!

    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterPath = movie["poster_path"] as! String
        let baseUrl = "https://image.tmdb.org/t/p/w500"
        
        let imageUrl = NSURL(string: baseUrl + posterPath)
        
        print (movie)
        titleLabel.text = title
        overviewLabel.text = overview
        posterImageView.setImageWith(imageUrl as! URL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
