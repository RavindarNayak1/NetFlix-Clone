//
//  YoutubeSearchresponce.swift
//  NetflixClone
//
//  Created by Ravindar Nayak on 13/09/23.
//

import Foundation

struct YoutubeSearchResponce: Codable {
    let items: [VideoElement]
    
}
struct VideoElement: Codable {
    let id: IdVideoElement
}
struct IdVideoElement: Codable{
    let kind: String
    let videoId: String
}

