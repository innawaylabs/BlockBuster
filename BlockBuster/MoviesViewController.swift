//
//  MoviesViewController.swift
//  BlockBuster
//
//  Created by Ravi Mandala on 9/18/17.
//  Copyright © 2017 Ravi Mandala. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var networkErrorView: UIView!
    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [NSDictionary]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.moviesTableView.dataSource = self
        self.moviesTableView.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        moviesTableView.insertSubview(refreshControl, at: 0)
        
        refreshControlAction(refreshControl)
    }

    // Makes a network request to get updated data
    // Updates the tableView with the new data
    // Hides the RefreshControl
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        let url = URL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let task: URLSessionDataTask = session.dataTask(
            with: request as URLRequest,
            completionHandler: { (data, response, error) in
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                
                if let data = data {
                    self.networkErrorView.isHidden = true
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                        self.movies = (responseDictionary["results"] as! [NSDictionary])
                        self.moviesTableView.reloadData()
                        refreshControl.endRefreshing()
                    }
                } else {
                    self.networkErrorView.isHidden = false
                }
        });
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview

        if let posterPath = movie["poster_path"] as? String {
            let baseUrl = "https://image.tmdb.org/t/p/w500"
            let imageUrl = NSURL(string: baseUrl + posterPath)
            cell.posterImageView.setImageWith(imageUrl as! URL)
        } else {
            cell.posterImageView = nil
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! MovieCell
        let indexPath = moviesTableView.indexPath(for: cell)
        let movie = movies![indexPath!.row]
        let movieDetailsViewController = segue.destination as! MovieDetailsViewController
        
        movieDetailsViewController.movie = movie
    }
}
