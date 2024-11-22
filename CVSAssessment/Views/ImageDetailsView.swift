//
//  ImageDetailsView.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/22/24.
//

import SwiftUI

struct ImageDetailsView: View {
  var image: FlickrImage
  @State var parsedDescriptions: [String] = []
  @State var parsedImageFromDescription: String? = nil

  init(image: FlickrImage) {
    self.image = image
  }
  
  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 16) {
        Group {
          if #available(iOS 15, *) {
            AsyncImage(url: URL(string: image.media.url)) { phase in
              switch phase {
              case .success(let image):
                image.resizable()
                  .aspectRatio(contentMode: .fit)
              case .empty:
                ProgressView()
              default:
                // Placeholder for error
                Color.red
              }
            }
          } else {
            CustomAsyncImage(url: URL(string: image.media.url), placeholder: {
              ProgressView()
            })
          }
        }
        .accessibilityHidden(true)
        
        Text(image.title)
          .font(.headline)
          .accessibilityLabel(Text("Image Titled: \(image.title)"))
        
        if let description = parsedDescriptions.last, !description.isEmpty {
          Text(description)
            .accessibilityLabel(Text("Description: \(description)"))
        }
        
        if let author = image.author, !author.isEmpty {
          Text("Author: \(author)")
            .font(.subheadline)
            .accessibilityLabel(Text("Author: \(author)"))
        }
        
        if let published = image.published, !published.isEmpty {
          Text("Published: \(published)")
            .font(.subheadline)
            .accessibilityLabel(Text("Published: \(published)"))
        }
      }
      .padding()
      .navigationTitle("Image Details")
      .toolbarTitleDisplayMode(.inline)
    }
    .onAppear {
      parsedImageFromDescription = HTMLParcer.htmlParcer(html: image.description ?? "", tag: .img).first
      parsedDescriptions = HTMLParcer.htmlParcer(html: image.description ?? "", tag: .p)
    }
  }
}

#Preview {
  ImageDetailsView(image: FlickrImage(title: "Cool Image", description: "Some cool description about the image.", author: "Some Cool Author", published: "Some Published Date", media: FlickrImage.Media(url: "https://live.staticflickr.com/65535/54142899515_8cc3c29fea_m.jpg")))
}
