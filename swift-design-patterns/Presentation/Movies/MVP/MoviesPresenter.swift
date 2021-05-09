//
//  MoviesPresenter.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation

class MoviesPresenter {
    fileprivate let httpClient: HttpClient
    fileprivate weak var view: MoviesProtocol?
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func attachView(_ view: MoviesProtocol) {
        self.view = view
    }
    
    func detachView() {
        self.view = nil
    }
    
    func getMovies(page: Int) {
        var url = WebServices.moviesUrl
        let params: [String : String] = ["{api_key}": "f2b566ae4212940dc51544f3986bd3ca",
            "{year}": "2021",
            "{page}": "\(page)"
        ]
        
        params.forEach { (key, value) in
            url = url.replacingOccurrences(of: key, with: value)
        }
        
        self.view?.shouldDisplayActivityIndicator(true)
        httpClient.performRequest(to: url, httpMethod: .Get, keyPath: "results") { [unowned self] (movies: [Movie]?, error) in
            self.view?.shouldDisplayActivityIndicator(false)
            if let e = error {
                self.view?.gotError(e)
            } else {
                self.view?.gotMovies(movieList: movies ?? [])
            }
        }
    }
}
