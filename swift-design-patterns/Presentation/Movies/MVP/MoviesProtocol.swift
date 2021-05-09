//
//  MoviesProtocol.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation

protocol MoviesProtocol: class {
    func shouldDisplayActivityIndicator(_ shouldDisplay: Bool)
    func gotError(_ error: Error)
    func gotMovies(movieList: [Movie])
}
