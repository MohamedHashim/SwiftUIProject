//
//  ImageData.swift
//  ImagesProject
//
//  Created by Mohamed Ahmed on 08/09/2022.
//

import Foundation

class ImageData {
    
    let id = UUID()
    let location: String?
    let tags: [String]
    let url: String
    var isLiked: Bool
    
    init(location: String?, tags: [String], url: String, isLiked: Bool) {
        self.location = location
        self.tags = tags
        self.url = url
        self.isLiked = isLiked
    }
    
}
