//
//  MoviesRxViewController.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 9/05/21.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesRxViewController: UIViewController {
    
    private let items = BehaviorRelay<[Movie]>(value: [])
    private let disposeBag = DisposeBag()
    
    let moviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor.white
        collectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        fetchMovies(page: 1)
    }
    
    func setupUI() {
        self.view.addSubview(self.moviesCollectionView)
        
        self.moviesCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.moviesCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        self.moviesCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        self.moviesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func setupCollectionView() {
        moviesCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "MovieCell")
        moviesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        items.asObservable().observeOn(MainScheduler.instance).bind(to: moviesCollectionView.rx.items(cellIdentifier: "MovieCell", cellType: MovieCell.self)) { (row, element, cell) in
            cell.setImage(path: element.posterPath)
        }.disposed(by: disposeBag)
        
    }
    
    func fetchMovies(page: Int) {
        var urlString = WebServices.moviesUrl
        let params = ["{api_key}": "f2b566ae4212940dc51544f3986bd3ca",
                      "{year}": "2021",
                      "{page}": "\(page)"]
        
        params.forEach { (key, value) in
            urlString = urlString.replacingOccurrences(of: key, with: value)
        }
        
        HttpClient.default.performRequest(to: urlString, httpMethod: .Get, keyPath: "results") { [unowned self] (moviesList: [Movie]?, error) in
            
            if let moviesList = moviesList {
                self.items.accept(moviesList)
            }
        }
    }
}

extension MoviesRxViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 15
        return CGSize(width: width, height: width + 80)
    }
}

