//
//  MoviesMVVMViewController.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 9/05/21.
//

import UIKit
import Combine

class MoviesMVVMViewController: UIViewController {
    
    let viewModel: MoviesViewModel = MoviesViewModel(httpClient: HttpClient.default)
    private var cancellables: Set<AnyCancellable> = []
    
    let loader: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    private func bindViewModel() {
        viewModel.objectWillChange.sink { [weak self] in
            guard let self = self else {
                return
            }
            self.viewModel.isLoading ? self.loader.startAnimating() :self.loader.stopAnimating()
            self.moviesCollectionView.reloadData()
        }.store(in: &cancellables)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.fetchMovies(page: 1)
    }
    
    func setupUI() {
        self.view.addSubview(moviesCollectionView)
        self.view.addSubview(self.loader)
        
        self.moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
       
        self.moviesCollectionView.dataSource = self
        self.moviesCollectionView.delegate = self
    }
}

extension MoviesMVVMViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = viewModel.movies[indexPath.row]
        cell.setImage(path: movie.posterPath)
        return cell
    }
}

extension MoviesMVVMViewController: UICollectionViewDelegate {
    
}

extension MoviesMVVMViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 15
        return CGSize(width: width, height: width + 80)
    }
}
