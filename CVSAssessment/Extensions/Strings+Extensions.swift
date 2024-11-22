//
//  Strings+Extensions.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/22/24.
//

import Foundation

extension String {
  var htmlToString: String? {
    guard let data = self.data(using: .utf8) else { return nil }
    
    do {
      let attributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
      return attributedString.string
    } catch {
      return nil
    }
  }
}
