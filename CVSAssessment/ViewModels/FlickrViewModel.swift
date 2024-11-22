//
//  FlickrViewModel.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/21/24.
//

import Foundation
import Combine
import SwiftSoup

@MainActor class FlickrViewModel: ObservableObject {
  @Published var images: [FlickrImage] = []
  @Published var isLoading = false
  
  var cancellables = Set<AnyCancellable>()
  
  func searchImages(for query: String) {
    guard !query.isEmpty else {
      self.images = []
      return
    }
    
    let formattedQuery = query.replacingOccurrences(of: " ", with: ",")
    let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(formattedQuery)"
    
    if let url = URL(string: urlString) {
      isLoading = true
      // This is actually pretty cool using combine to do this asynchronously. Makes things more readable. I usually do things the traditional way. Referenced: https://medium.com/@puneet.teng/fetch-remote-url-with-urlsession-combine-datataskpublisher-9aa34f98b905
      URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { element -> Data in
          guard let response = element.response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            throw URLError(.badServerResponse)
          }
          return element.data
        }
        .decode(type: FlickrResponse.self, decoder: JSONDecoder())
        .replaceError(with: FlickrResponse(title: "", description: "", items: []))
        .eraseToAnyPublisher()
        .sink { [weak self] status in
          if let self {
            switch status {
            case .finished:
              DispatchQueue.main.async {
                self.isLoading = false
              }
            case .failure(let error):
              // Log this in the future, Should display an errorm to the user.
              print("Reciever error \(error)")
              return
            }
          }
        } receiveValue: { [weak self] flickr in
          // images is empty if this fails
          if let self {
            DispatchQueue.main.async {
              self.images = flickr.items
            }
          }
        }
        .store(in: &cancellables)
    }
  }
}
