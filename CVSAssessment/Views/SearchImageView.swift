//
//  SearchImageView.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/21/24.
//

import SwiftUI

struct SearchImageView: View {
  @StateObject private var viewModel = FlickrViewModel()
  @State private var searchText = ""
  
  var body: some View {
    NavigationStack {
      Group {
        if viewModel.isLoading {
          ProgressView()
        } else {
          ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
              ForEach(viewModel.images) { image in
                NavigationLink(destination: ImageDetailsView(image: image)) {
                  Group {
                    if #available(iOS 15, *) {
                      AsyncImage(url: URL(string: image.media.url)) { phase in
                        switch phase {
                        case .success(let image):
                          image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                        case .empty:
                          ProgressView()
                        default:
                          // Placeholder for error we should change this in the future
                          Color.red
                        }
                      }
                      .frame(height: 100)
                    } else {
                      CustomAsyncImage(url: URL(string: image.media.url)) {
                        ProgressView()
                      }
                    }
                  }
                  .accessibilityHidden(true)
                }
              }
            }
            .padding()
          }
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .navigationTitle("Flickr Image Search")
      .onChange(of: searchText) { _, newValue in
        viewModel.searchImages(for: newValue)
      }
    }
    .searchable(text: $searchText)
  }
}

#Preview {
  SearchImageView()
}
