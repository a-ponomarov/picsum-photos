//
//  URLComponentsExtension.swift
//  picsum-photos
//
//  Created by Andrii Ponomarov on 12.12.2022.
//

import Foundation

extension URLComponents {
    
    static var schemeHost: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        return urlComponents
    }
    
    private enum Constants {
        static let host = "picsum.photos"
        static let scheme = "https"
    }
    
}
