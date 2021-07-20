//
//  MovieResult.swift
//  CarbonAssement
//
//  Created by Anthony Odu on 10/07/2021.
//

import Foundation

// MARK: - Welcome
struct MovieResult:Codable {
    let page, totalResults, totalPages: Int?
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let voteCount: Int
    let posterPath: String?
    let id: Int
    let backdropPath: String?
    let title: String
    let voteAverage: Double
    let overview, releaseDate: String?
    var favourite:Bool? = false
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case id
        case backdropPath = "backdrop_path"
        case title
        case voteAverage = "vote_average"
        case overview
        case releaseDate = "release_date"
    }
}


struct AllResult: Codable {
    let voteCount: Int
    let posterPath: String
    let id: Int
    let backdropPath: String
    let title: String
    let voteAverage: Double
    let overview, releaseDate: String
    var favourite:Bool
    
}
