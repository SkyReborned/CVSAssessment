//
//  FlickrResponse.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/22/24.
//

struct FlickrResponse: Codable {
  let title: String
  let description: String
  let items: [FlickrImage]
}
