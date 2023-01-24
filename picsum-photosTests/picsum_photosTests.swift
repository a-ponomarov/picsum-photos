//
//  picsum_photosTests.swift
//  picsum-photosTests
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import XCTest
@testable import picsum_photos

final class picsum_photosTests: XCTestCase {

    func testAPI() async throws {
        let photosAPI = PhotosAPI()
        let (list, _) = try await photosAPI.photos(page: 1, size: 33)
        XCTAssert(list.count == 33)
        
        let firstPhoto = list[0]
        let path = list[0].path(size: CGSize(width: 33, height: 33))
        let imagesAPI = ImagesAPI()
        let image = try await imagesAPI.image(path: path)
        XCTAssert(image.size.width == 33 && image.size.height == 33)
        
    }

}
