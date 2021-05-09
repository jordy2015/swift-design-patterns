//
//  WebServices.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 8/05/21.
//

import Foundation

class WebServices {
    static let moviesUrl: String = "https://api.themoviedb.org/3/discover/movie?api_key={api_key}&primary_release_year={year}&page={page}"
    static let imagesUrl: String = "https://image.tmdb.org/t/p/w500/"
}
