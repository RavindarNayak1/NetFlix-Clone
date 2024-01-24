//
//  Movie.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 09/09/23.
//

import Foundation
struct TrendingMovieResponce: Codable {
    let results :[Movie]
}

struct Movie: Codable {
    let id:Int
    let media_name: String?
    let original_name: String?
    let original_title: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int?
    let release_date: String?
//    let vote_avarage: Double
    
    
    
    
}
