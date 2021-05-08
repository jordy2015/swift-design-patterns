//
//  ViewController.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 6/05/21.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    HttpClient.default.performRequest(to: "https://api.themoviedb.org/3/discover/movie?api_key=f2b566ae4212940dc51544f3986bd3ca&primary_release_year=2021&page=1", httpMethod: .Get, keyPath: "results", body: nil) { (movies: [Movie]?, error) in
      if let movieList = movies {
        movieList.forEach { (movie) in
          print(movie)
        }
      }
      
      if let e = error {
        let alert = UIAlertController(title: "Error", message: e.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "ok", style: .default)
        alert.addAction(action)
        self.present(alert, animated: true)
        
      }
    }
    
  }


}

