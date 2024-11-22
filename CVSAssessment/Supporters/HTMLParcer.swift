//
//  HTMLParcer.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/22/24.
//

import Foundation
import SwiftSoup

class HTMLParcer {
  enum Tag: String {
    case img
    case p
  }
  
  static func htmlParcer(html: String, tag: Tag) -> [String] {
    do {
      let document: Document = try SwiftSoup.parse(html)
      if let body = document.body() {
        switch tag {
        case .img:
          let values: [String] = try body.getElementsByTag(tag.rawValue).compactMap { element in
            try? element.attr("src")
          }
          return values
        case .p:
          let values: [String] = try body.getElementsByTag(tag.rawValue).compactMap { element in
            try? element.html().htmlToString
          }
          return values
        }
      }
    } catch {
      print("Error: Parsing HTML", String(describing: error))
    }
    
    return []
  }
}
