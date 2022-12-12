//
//  ImagesAPI.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 12.12.2022.
//

import Foundation
import UIKit.UIImage

final class ImagesAPI {
    
    private let imageDownloader: ImageDownloader
    
    init(httpSession: any URLDataSession = URLSession.shared) {
        self.imageDownloader = ImageDownloader(session: httpSession)
    }
    
    func image(path: String, grayscale: Bool = false, blur: Int? = nil) async throws -> UIImage {
        let url = imageURL(path: path, grayscale: grayscale, blur: blur)
        return try await imageDownloader.image(url: url)
    }
    
    private func imageURL(path: String, grayscale: Bool = false, blur: Int? = nil) -> URL {
        var urlComponents = URLComponents.schemeHost
        urlComponents.path = path
        urlComponents.query = query(grayscale: grayscale, blur: blur)
        return urlComponents.url!
    }
    
    private func query(grayscale: Bool = false, blur: Int? = nil) -> String {
        var query = String()
        if grayscale { query = Constants.grayscale }
        if let blur { query.append("&\(Constants.blur)=\(blur)") }
        return query
    }
    
    private enum Constants {
        static let blur = "blur"
        static let grayscale = "grayscale"
    }

}
