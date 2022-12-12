//
//  ImageDownloader.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation
import UIKit

final class ImageDownloader {
    
    private let cache: NSCache<NSURL, ImageCacheObject> = NSCache()
    private let session: any URLDataSession
    
    init(session: any URLDataSession = URLSession.shared) {
        self.session = session
    }
    
    func image(url: URL) async throws -> UIImage {

        if let cached = cache[url] {
            switch cached {
            case .ready(let image):
                return image
            case .inProgress(let task):
                return try await task.value
            }
        }
        
        let task = Task<UIImage, Error> {
            let (data, _) = try await session.httpData(from: url)
            guard let image = UIImage(data: data) else { throw ErrorType.missingData }
            return image
        }
        
        cache[url] = .inProgress(task)
        
        do {
            let image = try await task.value
            cache[url] = .ready(image)
            return image
        } catch {
            cache[url] = nil
            throw error
        }
    }

}
