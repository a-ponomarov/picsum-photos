//
//  PhotosAPI.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation

final class PhotosAPI {
    
    let httpSession: any URLDataSession
    
    init(httpSession: any URLDataSession = URLSession.shared) {
        self.httpSession = httpSession
    }

    func photos(page: Int, size: Int = Constants.pageSize) async throws -> ([Photo], Bool) {
        let url = photosURL(page: page, size: size)
        let (data, response) = try await httpSession.httpData(from: url)
        let photos = try JSONDecoder().decode([Photo].self, from: data)
        let listHeader = response.value(forHTTPHeaderField: Constants.linkHeader) ?? String()
        let isNextPageExist = listHeader.contains(Constants.next)
        return (photos, isNextPageExist)
    }
    
    private func photosURL(page: Int, size: Int = Constants.pageSize) -> URL {
        var urlComponents = URLComponents.schemeHost
        urlComponents.path = Constants.listPath
        urlComponents.query = "\(Constants.page)=\(page)&\(Constants.limit)=\(size)"
        return urlComponents.url!
    }
    
    private enum Constants {
        static let next = "next"
        static let linkHeader = "Link"
        static let page = "page"
        static let limit = "limit"
        static let listPath = "/v2/list"
        static let pageSize = 10
    }

}
