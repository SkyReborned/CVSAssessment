//
//  FlickrImage.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/21/24.
//

import Foundation

struct FlickrImage: Codable, Identifiable {
  let id = UUID().uuidString
  let title: String
  let description: String?
  let author: String?
  let published: String?
  let media: Media
  
  enum CodingKeys: String, CodingKey {
    case title, description, author, published, media
  }
}

extension FlickrImage {
  struct Media: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
      case url = "m"
    }
  }
}
