//
//  CustomAsyncImage.swift
//  CVSAssessment
//
//  Created by SkyReborned on 11/22/24.
//
import SwiftUI
import UIKit

// Created this to support < iOS 15 since AsyncImage was introduced in iOS 15+. Project is set to iOS 18.1 so it's not needed if our lowest iOS version was 18.1 but in most cases, existing projects want to support old iOS versions for the users. Usually iOS versions Should be like three versions behind the latest versions.
struct CustomAsyncImage<Placeholder: View>: View {
  @State private var image: UIImage? = nil
  private let url: URL?
  private let placeholder: Placeholder
  
  init(url: URL?, @ViewBuilder placeholder: () -> Placeholder) {
    self.url = url
    self.placeholder = placeholder()
  }
  
  var body: some View {
    Group {
      if let image {
        Image(uiImage: image)
          .resizable()
      } else {
        placeholder
      }
    }
    .onAppear(perform: load)
  }
  
  private func load() {
    guard let url = url else { return }
    
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data = data, let uiImage = UIImage(data: data) else { return }
      DispatchQueue.main.async {
        self.image = uiImage
      }
    }.resume()
  }
}
