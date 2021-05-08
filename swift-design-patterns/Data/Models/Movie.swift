//
//  Movie.swift
//  swift-design-patterns
//
//  Created by Jordy Gonzalez on 6/05/21.
//

struct Movie: Decodable {
  let id: Int
  let backdropPath: String
  let title: String
  let overview: String
  let posterPath: String
  let releaseDate: String
  let voteAverage: Double
  
  enum CodingKeys: String, CodingKey {
    case id
    case backdropPath = "backdrop_path"
    case title
    case overview
    case posterPath = "poster_path"
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
  }
}
