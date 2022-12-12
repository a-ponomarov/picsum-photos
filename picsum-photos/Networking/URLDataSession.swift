//
//  URLDataSession.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 08.12.2022.
//

import Foundation

protocol URLDataSession {
    func httpData(from: URL) async throws -> (Data, HTTPURLResponse)
}

private let validStatus = 200...299

extension URLSession: URLDataSession {
    
    func httpData(from url: URL) async throws -> (Data, HTTPURLResponse) {
        guard let (data, response) =
                try await data(from: url) as? (Data, HTTPURLResponse),
                validStatus.contains(response.statusCode) else { throw ErrorType.networkError }
        return (data, response)
    }
    
}
