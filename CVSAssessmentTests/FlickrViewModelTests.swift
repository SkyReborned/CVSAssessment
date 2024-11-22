//
//  CVSAssessmentTests.swift
//  CVSAssessmentTests
//
//  Created by SkyReborned on 11/22/24.
//

import XCTest
@testable import CVSAssessment

@MainActor
class FlickrViewModelTests: XCTestCase {
    var viewModel: FlickrViewModel!

    override func setUp() {
        super.setUp()
        viewModel = FlickrViewModel()
    }

  @MainActor func testSearchImages() {
        let expectation = self.expectation(description: "Fetch images")
        
        viewModel.$images
            .dropFirst() // skip the initial empty state
            .first()
            .sink { images in
                XCTAssertFalse(images.isEmpty, "Images should not be empty")
                expectation.fulfill()
            }
            .store(in: &viewModel.cancellables)

        viewModel.searchImages(for: "forest") // Trigger the search
        waitForExpectations(timeout: 5, handler: nil)
    }
}
