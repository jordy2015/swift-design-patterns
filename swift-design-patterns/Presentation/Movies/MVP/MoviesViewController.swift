//
//  MoviesViewController.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation
import UIKit

class MoviesViewController: UIViewController {
    
    let presenter = MoviesPresenter(httpClient: HttpClient.default)
    var movieList: [Movie] = [] {
        didSet {
            self.moviesColletionView.reloadData()
        }
    }
    
    let loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let moviesColletionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        presenter.attachView(self)
        presenter.getMovies(page: 1)
    }
    
    func setupUI() {
        self.view.addSubview(self.moviesColletionView)
        self.view.addSubview(self.loader)
        self.moviesColletionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.moviesColletionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.moviesColletionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.moviesColletionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.moviesColletionView.delegate = self
        self.moviesColletionView.dataSource = self
    }
    
    deinit {
        presenter.detachView()
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCell
        let movie = movieList[indexPath.row]
        cell.setImage(path: movie.posterPath)
        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 15
        return CGSize(width: width, height: width + 80)
    }
}

extension MoviesViewController: MoviesProtocol {
    func shouldDisplayActivityIndicator(_ shouldDisplay: Bool) {
        shouldDisplay ? self.loader.startAnimating() : self.loader.stopAnimating()
    }
    
    func gotError(_ error: Error) {
        let alert = UIAlertController(title: "Server Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func gotMovies(movieList: [Movie]) {
        self.movieList.append(contentsOf: movieList)
    }
}
