//
//  MoviesViewModel.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 9/05/21.
//

import Foundation
import Combine

class MoviesViewModel: ObservableObject {
    let objectWillChange = PassthroughSubject<Void, Never>()
    private (set) var movies: [Movie] = []
    private (set) var isLoading: Bool = false
    private (set) var onError: Error? = nil
    
    private let httpClient: HttpClient
    
    init(httpClient: HttpClient) {
        self.httpClient = httpClient
    }
    
    func fetchMovies(page: Int) {
        var urlString = WebServices.moviesUrl
        let params = ["{api_key}": "f2b566ae4212940dc51544f3986bd3ca",
                      "{year}": "2021",
                      "{page}": "\(page)"]
        
        params.forEach { (key, value) in
            urlString = urlString.replacingOccurrences(of: key, with: value)
        }
        
        self.isLoading = true
        onError = nil
        objectWillChange.send()
        httpClient.performRequest(to: urlString, httpMethod: .Get, keyPath: "results") { [unowned self] (moviesList: [Movie]?, error) in
            self.isLoading = false
            if let moviesList = moviesList {
                self.movies.append(contentsOf: moviesList)
            }
            
            if let e = error {
                onError = e
            }
            objectWillChange.send()
        }
    }
}
